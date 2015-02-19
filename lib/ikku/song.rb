require "ikku/bracket_state"
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
      when has_odd_parentheses?
        false
      else
        true
      end
    end

    private

    def has_odd_parentheses?
      bracket_state.odd?
    end

    def nodes
      phrases.flatten
    end

    def rule
      @rule || DEFAULT_RULE
    end

    def scan
      Scanner.new(exactly: @exactly, nodes: @nodes, rule: rule).scan
    end

    def bracket_state
      @bracket_state ||= BracketState.new.tap do |state|
        state.consume_all(surfaces)
      end
    end

    def surfaces
      nodes.map(&:surface)
    end
  end
end
