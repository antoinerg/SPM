function test_suite = test_gxsmvp
initTestSuite;

function f = setup
[pathstr, name, ext] = fileparts(mfilename('fullpath'));
f = [pathstr '/fixture/STS_2x.vpdata'];

function testIsValidFormat(f)
bool = SPM.parser.gxsmvp.spm.is_valid_format(f);
assertTrue(bool);

function testLoad(f)
s=SPM.load(f);

function testDate(f)
s=SPM.load(f);
assertEqual(s.Date,'03-Feb-2012 21:17:20');

function testNPoints(f);
s=SPM.load(f);
assertEqual(s.NPoints,4000);

function testParseChannel(f)
s = SPM.load(f);
assertEqual(length(s.Channel),4);

function testChannelData(f)
s = SPM.load(f);
assertEqual(size(s.Channel(1).Data),[4000 1])

function testChannelNameUnit(f)
s = SPM.load(f);
assertEqual(s.Channel(1).Name,'Bias');
assertEqual(s.Channel(1).Units,'V');

function testHeader(f)
s = SPM.load(f);
assertElementsAlmostEqual(s.Header.Bias,-0.05);
assertElementsAlmostEqual(s.Header.Current,0.2);
assertEqual(s.Header.Comment,'"Nobody@mantis\nSession Date: Wed Feb  1 22:05:04 2012\n"');
