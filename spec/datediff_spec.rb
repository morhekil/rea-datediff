require 'lib/datediff'

describe Datediff do

  describe 'calculation of date differences' do

    {
      '05 06 2011, 20 06 2011' => '05 06 2011, 20 06 2011, 15',
      '05 06 2011, 20 12 2011' => '05 06 2011, 20 12 2011, 198',
      '30 05 1993, 20 12 2011' => '30 05 1993, 20 12 2011, 6778'
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

end
