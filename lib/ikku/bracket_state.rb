module Ikku
  class BracketState
    BRACKETS_TABLE = {
      "‘" => "’",
      "“" => "”",
      "（" => "）",
      "(" => ")",
      "［" => "］",
      "[" => "]",
      "{" => "}",
      "｛" => "｝",
      "〈" => "〉",
      "《" => "》",
      "「" => "」",
      "『" => "』",
      "【" => "】",
      "〔" => "〕",
      "<" => ">",
      "＜" => "＞",
    }

    class << self
      def brackets_index
        @brackets_index ||= BRACKETS_TABLE.to_a.flatten.inject({}) do |hash, bracket|
          hash.merge(bracket => true)
        end
      end

      def inverted_brackets_table
        @inverted_brackets_table ||= BRACKETS_TABLE.invert
      end
    end

    def consume_all(surfaces)
      surfaces.each do |surface|
        consume(surface)
      end
      self
    end

    def odd?
      !even?
    end

    private

    def consume(surface)
      case
      when !stack.last.nil? && self.class.inverted_brackets_table[surface] == stack.last
        stack.pop
      when self.class.brackets_index.include?(surface)
        stack.push(surface)
      end
    end

    def even?
      stack.empty?
    end

    def stack
      @stack ||= []
    end
  end
end
