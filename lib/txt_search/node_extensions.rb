require "treetop"

module Query

  class QueryNode < Treetop::Runtime::SyntaxNode
    def test(text)
      return false if elements.empty?
      elements.all? {|node| node.test(text)}
    end
  end

  class CompoundExpressionNode < Treetop::Runtime::SyntaxNode
    def test(text)
      return false if elements.count < 3
      left     = elements[0]
      operator = elements[1].text_value
      right    = elements[2]
      case operator
      when 'AND' then return left.test(text) && right.test(text)
      when 'OR'  then return left.test(text) || right.test(text)
      else
        return false
      end
    end
  end


  class GroupNode < Treetop::Runtime::SyntaxNode
    def test(text)
      return false if elements.empty?
      return elements[0].test(text)
    end
  end

  class OperatorNode < Treetop::Runtime::SyntaxNode
  end

  class TokenNode < Treetop::Runtime::SyntaxNode
    def test(text)
      do_test(text, text_value)
    end

    protected
    def do_test(text, token_value)
      is_negative = token_value[0] == '-'
      token_value = token_value[1..-1] if is_negative
      token_found = !text.match(/\b#{token_value}\b/).nil?
      is_negative ^ token_found
    end
  end

  class TokenListNode < TokenNode

    def test(text)
      token_values = text_value.gsub(/\s+/m, ' ').strip.split(" ")
      return token_values.all? {|token_value| do_test(text, token_value)}
    end

  end

  class WildcardNode < Treetop::Runtime::SyntaxNode
    def test(text)
      token = text_value[0..-1]
      return !text.match(/\b#{token}/).nil?
    end
  end

  class SentenceNode < Treetop::Runtime::SyntaxNode
    def test(text)
      phrase = text_value[1..-2]
      !text.match(/\b#{phrase}\b/).nil?
    end
  end

end
