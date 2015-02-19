require "ikku/parser"
require "ikku/song"

module Ikku
  class Reviewer
    def initialize(rule: nil)
      @rule = rule
    end

    # Find one valid song from given text.
    # @return [Ikku::Song]
    def find(text)
      nodes = parser.parse(text)
      nodes.length.times.find do |index|
        if (song = Song.new(nodes[index..-1], rule: @rule)).valid?
          break song
        end
      end
    end

    # Judge if given text is valid song or not.
    # @return [true, false]
    def judge(text)
      Song.new(parser.parse(text), exactly: true, rule: @rule).valid?
    end

    # Search all valid songs from given text.
    # @return [Array<Array>]
    def search(text)
      nodes = parser.parse(text)
      nodes.length.times.map do |index|
        Song.new(nodes[index..-1], rule: @rule)
      end.select(&:valid?)
    end

    private

    def parser
      @parser ||= Parser.new
    end
  end
end
