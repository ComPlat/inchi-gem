require 'test/unit'

require 'inchi-gem'
include InChIGem

class InChIGemTest < Test::Unit::TestCase
  def test_sample01
    sample_01 = File.read('./test/data/sample_01.mol')

    rv = Inchi::ExtraInchiReturnValues.new;
    inchi = Inchi::molfileToInchi(sample_01, rv);

    correct_inchi = "InChI=1S/C5H8O/c1-2-4-6-5-3-1/h1-2H,3-5H2"

    assert_equal(inchi, correct_inchi)
  end

# List options:
# - LooseTSACheck (new in v. 1.06)
#     Relax strictness of tetrahedral stereo ambiguity check for stereo atoms
#     in (large) rings
#     Default: Use strict criteria (as in v. 1.05 and previous)
# - Polymers
#     Experimental support of simple polymers, current mode
#     Default: Disabled
# - Polymers105 (new in v. 1.06)
#     Experimental support of simple polymers in legacy v. 1.05 mode
#     Default: Disabled
# - NoFrameShift (new in v. 1.06)
#     Disable polymer CRU frame shift
#     Default: Attempt CRU frame shift
# - FoldCRU (new in v. 1.06)
#     In polymer treatment, try to fold constitutional repeating units
#       which themselves contain repeats
#     Default: Disabled
# - NPZz (new in v. 1.06)
#     Allow non-polymer Zz pseudo element atoms
#     Default: Disabled
# - SAtZZ (new in v. 1.06)
#     Allow stereo at atoms connected to Zz
#     Default: Disabled
# - LargeMolecules
#     Experimental support of molecules up to 32767 atoms
#     Default: Disabled

  def test_polymer01
    sample_01 = File.read('./test/data/polystyrene.mol')

    rv = Inchi::ExtraInchiReturnValues.new;

    inchi06 = Inchi::molfileToInchi(sample_01, rv, "-Polymers");
    correct_inchi06 = "InChI=1B/C8H8Zz2/c9-6-8(10)7-4-2-1-3-5-7/h1-5,8H,6H2/z101-1-8(10-8,9-6)"
    assert_equal(inchi06, correct_inchi06)

    inchi05 = Inchi::molfileToInchi(sample_01, rv, "-Polymers105");
    correct_inchi05 = "InChI=1B/C8H8/c1-2-8-6-4-3-5-7-8/h2-7H,1H2/z101-1-8(1.2)"
    assert_equal(inchi05, correct_inchi05)
  end
end
