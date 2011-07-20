require 'lib/datediff'

describe Datediff do

  describe 'calculation of date differences' do

    {
      '05 06 2011, 20 06 2011' => '05 06 2011, 20 06 2011, 15',
      '05 06 2011, 20 12 2011' => '05 06 2011, 20 12 2011, 198',
      '30 05 1993, 20 12 2011' => '30 05 1993, 20 12 2011, 6778',
      '20 12 2011, 30 05 1993' => '30 05 1993, 20 12 2011, 6778',
      '20 12 2011, 20 12 2011' => '20 12 2011, 20 12 2011, 0',
      '31 12 2001, 01 01 2002' => '31 12 2001, 01 01 2002, 1',
      '01 03 2001, 28 02 2001' => '28 02 2001, 01 03 2001, 1'
    }.each_pair do |input, output|
      it "should respond to '#{input}' with '#{output}" do
        inputs = input.split(', ')
        outputs = output.split(', ')
        Datediff.diff(*inputs).collect { |i| i.to_s}.should == outputs
      end
    end

  end

  describe 'date splitting' do
    it 'should split the date on spaces and convert the parts to integer values' do
      Datediff.send(:split_date, '05 06 2011').should == [2011, 6, 5]
    end
  end

  describe 'date validation' do
    [
      [2011, 05, 06],
      [1615, 12, 20],
      [2000, 02, 29],
      [2009, 02, 28]
    ].each do |date|
      it "should consider #{date.join('-')} to be valid" do
        Datediff.valid?(date).should be_true
      end
    end

    [
      [2011, 15, 06],
      [2011, 06, 31],
      [2000, 02, 30],
      [2001, 02, 29]
    ].each do |date|
      it "should consider #{date.join('-')} to be invalid" do
        Datediff.valid?(date).should be_false
      end
    end
  end

end
