function nch=calibrateDissipation(channel,tf,debug)
%Calibrate dissipation using transfer function
ch=channel;
h=findobj(ch.spm.UserChannel,'Type','calibrateDissipation','-and','ParentChannel',ch);

if ~isempty(h)
    disp('From cache');
    nch=h;
else
    if isa(tf,'SPM.spm');
        nch = SPM.format.userchannel;
        nch.ParentChannel=ch;
        nch.Parameters = {tf};
        nch.Type = 'calibrateDissipation';
        nch.Name = 'calibratedDissipation';
        nch.Units = ch.Units;
        nch.spm = ch.spm;
        nch.Direction = ch.Direction;
        nch.setData(correctData);
        
        %ch.spm.UserChannel = cat(1,ch.spm.UserChannel,nch);
    end
end

    function out=correctData
        %% Loading Data
        %Spectrum
        myDriveAmpl=ch.spm.ChannelByName('Excitation').Data;
        myFrequency=ch.spm.ChannelByName('Frequency Shift').Data;
        myBias=ch.spm.ChannelByName('Bias').Data;
        
        
        %Transfer function
        frequency=tf.ChannelByName('PIEZO Frequency shift').Data;
        piezoAmpl=tf.ChannelByName('PIEZO Amplitude').Data;
        piezoAmpl=piezoAmpl/max(piezoAmpl);
        
        elecAmpl=tf.ChannelByName('ELEC Amplitude').Data;
        elecAmpl=elecAmpl/max(elecAmpl);
        
        %% Drift correction 
        if (debug==true)
           f=figure;
           plot(frequency,elecAmpl,frequency,piezoAmpl);
           title('Amplitude (is there drift)');
           legend('elec','piezo');
        end
        
        %% Assign ratio and difference
        % Assign Ratio between both datasets
        ratio = piezoAmpl./elecAmpl;
        abs_X = smooth(ratio,5);
        
        if (debug==true) % Look at the transfer function
            f=figure;
            plot(frequency,abs_X);
            title('|XC|/|C|');
        end
        
        % Compute phase difference
        piezoPhase=tf.ChannelByName('PIEZO Phase').Data;
        elecPhase=tf.ChannelByName('ELEC Phase').Data;
        difference = piezoPhase - elecPhase;
        PhaseDiff = smooth(difference,5);
        
        if (debug==true)
            f=figure;
            plot(frequency,PhaseDiff);
            title('Phase difference');
        end
        
        %% Reconstruct the frequency sweep
        f = figure;
        plot(myBias(ceil(end/10):ceil(end/1.12)), myFrequency(ceil(end/10):ceil(end/1.12)));
        title('Section we will fit');
        P = polyfit(myBias(ceil(end/10):ceil(end/1.12)), myFrequency(ceil(end/10):ceil(end/1.12)), 2);
        myInterpFrequency = polyval(P, myBias);
        
        f=figure;
        plot(myBias, myFrequency, myBias, myInterpFrequency);
        title('Interpolated frequency');
        
        f=figure;
        plot(myInterpFrequency, myDriveAmpl);
        title('Drive current versus frequency');
        
        % normalize gain factor by its initial value
        Lambda = myDriveAmpl/0.160;
        
        f=figure;
        plot(myInterpFrequency, Lambda);
        title('\lambda (normalized drive current) versus frequency');
        
        
        %% Correcting
        start_theta = -90;
        resonanceFrequency = 0;
        myAbsFrequency = myInterpFrequency + resonanceFrequency;
        
        %ind=find(frequency<0);
        %ind=ind(1); % Index of the element at the resonance frequency
        abs_X = abs_X./abs_X(end-10);
        PhaseDiff = PhaseDiff - PhaseDiff(end-10);
        
        theta_factor=sind(start_theta) ./ sind(start_theta - PhaseDiff);
        x_factor=abs_X.^-1;
        ne = x_factor .* theta_factor ;
        neInterp = interp1(frequency, ne, myAbsFrequency);
        
        f=figure;
        plot(frequency,x_factor,frequency,theta_factor,myAbsFrequency,Lambda,myAbsFrequency,neInterp);
        legend('X factor','Theta factor','\lambda','Ne');
        
        
        f=figure;
        plot(frequency,ne,myAbsFrequency,Lambda,myAbsFrequency,(Lambda./neInterp-1));
        legend('Ne','\lambda','(\lambda/ne - 1)');
        
        out = (ch.Data0./neInterp - 1);
    end
end



