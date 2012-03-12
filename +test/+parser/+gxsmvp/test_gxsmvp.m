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

function testParseChannel(f)
s = SPM.parser.gxsmvp.spm(f);
assertEqual(length(s.Channel),2);

function testChannelData(f)
s = SPM.parser.gxsmvp.spm(f);
assertEqual(size(s.Channel(1).Data),[256 1])

