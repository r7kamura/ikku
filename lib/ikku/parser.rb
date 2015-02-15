require "natto"
require "ikku/node"

module Ikku
  class Parser
    def parse(text)
      mecab.enum_parse(text).map do |mecab_node|
        Node.new(mecab_node)
      end.select(&:analyzable?)
    end

    private

    def mecab
      @mecab ||= Natto::MeCab.new
    end
  end
end
