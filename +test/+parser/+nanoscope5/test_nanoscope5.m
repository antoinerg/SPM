function test_suite = test_nanoscope5
initTestSuite;

function f = setup
[pathstr, name, ext] = fileparts(mfilename('fullpath'));
f = [pathstr '/fixture/045auto.016'];

function testIsValidFormat(f)
bool = SPM.parser.nanoscope5.spm.is_valid_format(f);
assertTrue(bool);

function testLoad(f)
s=SPM.load(f);

function testParseChannel(f)
s = SPM.parser.nanoscope5.spm(f);
assertEqual(length(s.Channel),2);

function testChannelData(f)
s = SPM.parser.nanoscope5.spm(f);
assertEqual(size(s.Channel(1).Data),[512 512])

