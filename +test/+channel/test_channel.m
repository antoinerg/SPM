function test_suite = test_channel
initTestSuite;

function f = setup
[pathstr, name, ext] = fileparts(mfilename('fullpath'));
f = [pathstr './../+parser/+sxm/fixture/LN_AuNP-07-07-2011015.sxm'];

function testLoad(f)
s=SPM.load(f);

function testOffset(f)
s=SPM.load(f);
a=4;
x=mean(s.Channel(1).Data(:));
y=mean(s.Channel(1).Offset(a).Data(:));
assertElementsAlmostEqual(x+a,y);
