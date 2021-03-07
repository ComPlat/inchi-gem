require 'test/unit'

require 'inchi-gem'
include InChIGem

class InChIGemTest < Test::Unit::TestCase
  def test_esterification
    sample_01 = File.read('./test/data/sample_01.mol')

    rv = Inchi::ExtraInchiReturnValues.new;
    inchi = Inchi::molfileToInchi(sample_01, rv);

    correct_inchi = "InChI=1S/C5H8O/c1-2-4-6-5-3-1/h1-2H,3-5H2"

    assert_equal(inchi, correct_inchi)
  end
end
