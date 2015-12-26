module TxtSearch

  class Search

    attr_reader :tester

    def initialize opts = {}
      query   = opts[:query] || ''
      parser  = Parser.new
      @tester = parser.parse(query)
    end

    def test input
      return @tester.test(input)
    end

  end

end
