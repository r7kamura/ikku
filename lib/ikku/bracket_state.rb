module Ikku
  class BracketState
    TABLE = {
      "’" => "‘",
      "”" => "“",
      "）" => "（",
      ")" => "(",
      "］" => "［",
      "]" => "[",
      "}" => "{",
      "｝" => "｛",
      "〉" => "〈",
      "》" => "《",
      "」" => "「",
      "』" => "『",
      "】" => "【",
      "〕" => "〔",
      ">" => "<",
      "＞" => "＜",
    }

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
      when TABLE.values.include?(surface)
        stack.push(surface)
      when TABLE.include?(surface) && stack.last == TABLE[surface]
        stack.pop
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
