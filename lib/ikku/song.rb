require "ikku/scanner"

module Ikku
  class Song
    DEFAULT_RULE = [5, 7, 5]

    def initialize(nodes, exactly: false, rule: nil)
      @exactly = exactly
      @nodes = nodes
      @rule = rule
    end

    def phrases
      if instance_variable_defined?(:@phrases)
        @phrases
      else
        @phrases = scan
      end
    end

    def valid?
      case
      when phrases.nil?
        false
      else
        true
      end
    end

    private

    def rule
      @rule || DEFAULT_RULE
    end

    def scan
      Scanner.new(exactly: @exactly, nodes: @nodes, rule: rule).scan
    end
  end
end
