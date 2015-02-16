module Ikku
  # Find one haiku that starts from the 1st node of given nodes.
  class Scanner
    DEFAULT_RULE = [5, 7, 5]

    attr_writer :count

    def initialize(nodes, exactly: false, rule: nil)
      @exactly = exactly
      @nodes = nodes
      @rule = rule
    end

    # @note Pronounciation count
    def count
      @count ||= 0
    end

    def scan
      if has_valid_first_node? && has_valid_last_node?
        @nodes.each_with_index do |node, index|
          if consume(node)
            if has_full_count?
              return phrases unless @exactly
            end
          else
            return
          end
        end
        phrases if has_full_count?
      end
    end

    private

    def consume(node)
      case
      when node.pronounciation_length > max_consumable_length
        false
      when !node.element_of_ikku?
        false
      when first_of_phrase? && !node.first_of_phrase?
        false
      when node.pronounciation_length == max_consumable_length && !node.last_of_phrase?
        false
      else
        phrases[phrase_index] ||= []
        phrases[phrase_index] << node
        self.count += node.pronounciation_length
        true
      end
    end

    def first_of_phrase?
      rule.inject([]) do |array, length|
        array << array.last.to_i + length
      end.include?(count)
    end

    def has_full_count?
      count == rule.inject(0, :+)
    end

    def has_valid_first_node?
      @nodes.first.first_of_ikku?
    end

    def has_valid_last_node?
      @nodes.last.last_of_ikku?
    end

    def max_consumable_length
      rule[0..phrase_index].inject(0, :+) - count
    end

    def phrase_index
      rule.length.times.find do |index|
        count < rule[0..index].inject(0, :+)
      end || rule.length - 1
    end

    def phrases
      @phrases ||= []
    end

    def rule
      @rule || DEFAULT_RULE
    end
  end
end
