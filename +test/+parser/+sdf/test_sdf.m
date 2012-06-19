function test_suite = test_sdf
initTestSuite;

function f = setup
[pathstr, name, ext] = fileparts(mfilename('fullpath'));
image = [pathstr '/fixture/image.sdf'];
spectrum = [pathstr '/fixture/spectrum.sdf'];
f = struct('image',image,'spectrum',spectrum); 

function testIsValidFormat(f)
bool = SPM.parser.sdf.spm.is_valid_format(f.image);
assertTrue(bool);
bool = SPM.parser.sdf.spm.is_valid_format(f.spectrum);
assertTrue(bool);

function testLoad(f)
s=SPM.load(f.image);
assertEqual(s.Format,'sdf');
s2=SPM.load(f.spectrum);
assertEqual(s2.Format,'sdf');

function testParseChannel(f)
s = SPM.parser.sdf.spm(f.image);
assertEqual(length(s.Channel),16);
s = SPM.parser.sdf.spm(f.spectrum);
assertEqual(length(s.Channel),16);

function testChannelData(f)
s = SPM.parser.sdf.spm(f.image);
assertEqual(size(s.Channel(1).Data),[255 256]);
assertEqual(s.Width,400);
assertEqual(s.Height,400);
s = SPM.parser.sdf.spm(f.spectrum);
assertEqual(size(s.Channel(1).Data),[1 29999]);

function testDate(f)
s = SPM.parser.sdf.spm(f.image);
assertEqual(s.Date,'2011-05-30T16:08:00');

