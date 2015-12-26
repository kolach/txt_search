require "treetop"


module TxtSearch

  class ParseError < StandardError
    attr_reader :query
    attr_reader :offset
    def initialize(query, offset)
      @query = query
      @offset = offset
    end
  end

  class Parser

    Treetop.load(File.join(File.expand_path(File.dirname(__FILE__)), 'query_parser.treetop'))

    def initialize
      @parser = QueryParser.new
    end

    def parse query
      tree = @parser.parse(query)
      if tree.nil?
        raise ParseError.new(query, @parser.index), "Query parse error at offset: #{@parser.index}"
      end
      clean_tree(tree)
      return tree
    end

  private
    def clean_tree root_node
      return if root_node.elements.nil?
      root_node.elements.delete_if{|node| node.class.name == 'Treetop::Runtime::SyntaxNode'}
      root_node.elements.each {|node| clean_tree(node)}
    end

  end

end
