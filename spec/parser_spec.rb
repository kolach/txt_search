require 'spec_helper'

describe TxtSearch::Parser do

  subject { TxtSearch::Parser.new }

  it 'parses single tokens' do
    expect(subject.parse('apple')).not_to be_nil
    expect(subject.parse('apple ')).not_to be_nil
    expect(subject.parse(' apple ')).not_to be_nil
  end

  it 'parses tokens joined with AND' do
    expect(subject.parse('apple AND bananas')).not_to be_nil
    expect(subject.parse('apple     AND          bananas')).not_to be_nil
    expect(subject.parse('apple AND bananas AND milk')).not_to be_nil
  end

  it 'parses tokens joined with OR' do
    expect(subject.parse('apple OR bananas')).not_to be_nil
    expect(subject.parse('   apple     OR    bananas')).not_to be_nil
    expect(subject.parse('apple OR bananas OR milk')).not_to be_nil
  end

  it 'parses tokens joined with OR and AND' do
    expect(subject.parse('apple AND bananas OR milk')).not_to be_nil
  end

  it 'parses parenthesized expressions' do
    expect(subject.parse('(bananas)')).not_to be_nil
    expect(subject.parse('(bananas AND kiwi)')).not_to be_nil
    expect(subject.parse('((bananas AND kiwi))')).not_to be_nil
  end

  it 'parses complex expressions' do
    expect(subject.parse('(milk OR (bananas AND kiwi)) AND apple')).not_to be_nil
    expect(subject.parse('((milk AND bread) OR (bananas AND kiwi)) AND apple')).not_to be_nil
    expect(subject.parse('(apple AND bananas) OR milk')).not_to be_nil
    expect(subject.parse('((apple AND bananas) OR milk) AND flowers')).not_to be_nil
    expect(subject.parse('((apple AND "bananas with milk") OR milk*) AND flowers')).not_to be_nil
  end

  it 'parses sentenses' do
    expect(subject.parse('"good morning"')).not_to be_nil
    expect(subject.parse('"good morning" AND bananas')).not_to be_nil
  end

  it 'parces whildcards' do
    expect(subject.parse('cat*')).not_to be_nil
  end

  it 'parces negate tokens' do
    expect(subject.parse('-cat')).not_to be_nil
  end

  it 'raises exception on incorrect query' do
    expect{subject.parse('bananas AND apples)')}.to raise_error(TxtSearch::ParseError, 'Query parse error at offset: 18')
  end

end
