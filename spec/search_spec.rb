require 'spec_helper'

describe TxtSearch::Search do

  def tester query
    TxtSearch::Search.new(query: query)
  end

  def test query
    tester(query).test(input)
  end

  let(:input) { 'I really like bananas, apples not so much' }

  it 'should pass Nomnom test' do
    expect(test('bananas AND apples')).to eq(true)
    expect(test('bana*')).to eq(true)
    expect(test('"not so much"')).to eq(true)
    expect(test('bananas -apples')).to eq(false)
    expect(test('bananas OR mangos')).to eq(true)
    expect(test('(bananas OR mangos) AND much')).to eq(true)
    expect(test('(bananas OR mangos) AND frozen')).to eq(false)
  end

  it 'returns false if query is nil' do
    expect(test(nil)).to eq(false)
  end

  it 'returns false if query is empty' do
    expect(test('')).to eq(false)
    expect(test('  ')).to eq(false)
  end

  it 'tests token is present' do
    expect(test('bananas')).to eq(true)
    expect(test('banan')).to eq(false)
  end

  it 'tests phrase is present' do
    expect(test('"like bananas"')).to eq(true)
    expect(test('"like banana"')).to eq(false)
  end


  it 'tests wildcard is present' do
    expect(test('bana*')).to eq(true)
    expect(test('bananas*')).to eq(true)
    expect(test('bona*')).to eq(false)
    expect(test('ananas*')).to eq(false)
  end

  it 'tests tokens joined with AND' do
    expect(test('bananas AND apples')).to eq(true)
    expect(test('apples AND bananas')).to eq(true)
    expect(test('apples AND bread')).to eq(false)
    expect(test('(apples AND bread) OR bananas')).to eq(true)
  end

  it 'tests tokens joined with OR' do
    expect(test('bananas OR apples')).to eq(true)
    expect(test('platanas OR apples')).to eq(true)
  end

  it 'allows to group tokens' do
    expect(test('(bananas AND apples)')).to eq(true)
  end

  context 'multiline strings' do

    let(:input) {
      %{
        As a Brazilian myself, I prepare Caipirinha in a slightly different way:
        the ingredients are still the same (although you can substitute the cachaça for dark rum -
        it will then be called "Caipirissima"). You should crush the sliced lime (unpeeled, please!)
        and the sugar in a glass, mix in the cachaça (or rum) and a few ice cubes.%
        As for the comments on using either limes or lemons,
        I can assure you that what is sold in the US as lime is exactly what Brazilians call "limão Tahiti".
        So, go with the lime!
      }
    }

    it 'tests multiline strings' do
      expect(test('"As a Brazilian" AND lime')).to eq(true)
      expect(test('"As a Russian" OR lime')).to eq(true)
      expect(test('"As a Russian" AND lime')).to eq(false)
      expect(test('("As a Russian" AND lime) OR "cachaça"')).to eq(true)
    end

  end

  context 'multiple queries tests agains BEEF STEW recipe' do
    let(:input) {
      %{
        CORNED BEEF STEW
        1 (12 oz.) can corned beef
        1/2 c. chopped onion
        1/4 c. chopped celery
        1/4 c. chopped green pepper
        1 Tbsp. oil
        2 c. water
        4 potatoes, cubed
        1 (16 oz.) can tomatoes
        1 Tbsp. catsup
        1 Tbsp. Worcestershire sauce
        1 tsp. instant beef bouillon granules
      }
    }

    let (:queries) {{
      'pepper AND green AND red' => false,
      'pepper green red'         => false,
      'pepper AND toma'          => false,
      'pepper AND toma*'         => true,
      'pepper green -red'        => true,
      'pepper green AND (-red)'  => true,
      '"4 potatoes"'             => true,
      ' can    AND green    '    => true,
    }}

    it "should not pass" do
      queries.each do |query, expected_result|
        expect(test(query)).to eq(expected_result)
      end
    end
  end

  context 'yet another BEEF STEW recipe' do
    let(:input) {
      %{
      2 Tbsp. oil
      2 lb. beef stew meat
      2 (8 oz.) cans tomato sauce
      2 tsp. chili powder
      2 tsp. paprika
      1/4 c. sugar
      1/4 c. vinegar
      1/2 c. molasses
      1 tsp. salt
      2 c. carrots, sliced
      2 c. onions, diced
      1 green pepper, diced

      Heat the oil and cubed stew meat and brown. Add tomato sauce, chili powder, paprika, sugar, vinegar, molasses and salt plus 1 cup water, and simmer for 1 1/2 hours. Add more water, if needed. Add the carrots, onions and green pepper and cook another 30 minutes. Can be made in a crock-pot. Brown meat first and then add all the other ingredients. Cook on low for 8 hours or on high for 6 hours.
      }
    }

    let (:queries) {{
      'cul*' => false,
    }}

    it "should not pass" do
      queries.each do |query, expected_result|
        expect(test(query)).to eq(expected_result)
      end
    end
  end

end
