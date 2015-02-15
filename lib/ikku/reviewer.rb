require "ikku/parser"
require "ikku/scanner"

module Ikku
  class Reviewer
    def initialize(rule: nil)
      @rule = rule
    end

    # Find one available haiku from given text.
    # @return [Array<Array>]
    def find(text)
      nodes = parser.parse(text)
      nodes.length.times.find do |index|
        if (phrases = Scanner.new(nodes[index..-1], rule: @rule).scan)
          break phrases
        end
      end
    end

    # Judge if given text is haiku or not.
    # @return [true, false]
    def judge(text)
      !Scanner.new(parser.parse(text), exactly: true, rule: @rule).scan.nil?
    end

    # Search all available haikus from given text.
    # @return [Array<Array>]
    def search(text)
      nodes = parser.parse(text)
      nodes.length.times.map do |index|
        Scanner.new(nodes[index..-1], rule: @rule).scan
      end.compact
    end

    private

    def parser
      @parser ||= Parser.new
    end
  end
end
