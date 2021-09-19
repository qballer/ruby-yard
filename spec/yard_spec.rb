require_relative '../lib/yard'

describe Yard do
  it 'should support addition' do
    expect(Yard.resolve('1+2')).to eq(3)
  end

  it 'should support substraction' do
    expect(Yard.resolve('1-2')).to eq(-1)
  end

  it 'should support multiplication' do
    expect(Yard.resolve('1+2 * 3 -4')).to eq(3)
  end

  it 'should support division' do
    expect(Yard.resolve('10/2')).to eq(5)
  end

  it 'some other test case' do
    expect(Yard.resolve('1 * -1')).to eq(-1)
  end
end
