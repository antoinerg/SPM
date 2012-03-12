function test_suite = test_nanonisspectrum
initTestSuite;

function f = setup
[pathstr, name, ext] = fileparts(mfilename('fullpath'));
f = [pathstr '/fixture/sweep.dat'];

function testIsValidFormat(f)
bool = SPM.parser.nanonisspectrum.spm.is_valid_format(f);
assertTrue(bool);

function testLoad(f)
s=SPM.load(f);

function testParseChannel(f)
s = SPM.parser.nanonisspectrum.spm(f);
assertEqual(length(s.Channel),4);

function testChannelData(f)
s = SPM.parser.nanonisspectrum.spm(f);
assertEqual(size(s.Channel(1).Data),[256 1])

