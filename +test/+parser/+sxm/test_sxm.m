function test_suite = test_sxm
initTestSuite;

function f = setup
[pathstr, name, ext] = fileparts(mfilename('fullpath'));
f = [pathstr '/fixture/LN_AuNP-07-07-2011015.sxm'];

function testIsValidFormat(f)
bool = SPM.parser.sxm.spm.is_valid_format(f);
assertTrue(bool);

function testLoad(f)
s=SPM.load(f);

function testParseChannel(f)
s = SPM.parser.sxm.spm(f);
assertEqual(length(s.Channel),14);

function testChannelData(f)
s = SPM.parser.sxm.spm(f);
assertEqual(size(s.Channel(1).Data),[256 256])

function testParseDate(f)
s = SPM.parser.sxm.spm(f);
assertEqual(s.Date,'2011-07-25T17:43:19');

