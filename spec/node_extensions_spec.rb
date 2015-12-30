require 'spec_helper'

describe Query::WildcardNode do


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
 
  it 'should find text by whildcard' do
    node = Query::WildcardNode.new(['cul*'], 0)
    test = node.test(input)
    expect(test).to eq(false)
  end


end
