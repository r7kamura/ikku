require "csv"
require "natto"
require "ikku/version"

module Ikku
  class Reviewer
    # Find one available haiku from given text.
    # @return [Array<Array>]
    def find(text, rule: nil)
      nodes = parser.parse(text)
      nodes.length.times.find do |index|
        if (phrases = Scanner.new(nodes[index..-1], rule: rule).scan)
          break phrases
        end
      end
    end

    # Judge if given text is haiku or not.
    # @return [true, false]
    def judge(text, rule: nil)
      !Scanner.new(parser.parse(text), exactly: true, rule: rule).scan.nil?
    end

    # Search all available haikus from given text.
    # @return [Array<Array>]
    def search(text, rule: nil)
      nodes = parser.parse(text)
      nodes.length.times.map do |index|
        Scanner.new(nodes[index..-1], rule: rule).scan
      end.compact
    end

    private

    def parser
      @parser ||= Parser.new
    end
  end

  # Find one haiku that starts from the 1st node of given nodes.
  class Scanner
    DEFAULT_RULE = [5, 7, 5]

    attr_writer :count

    def initialize(nodes, exactly: false, rule: nil)
      @exactly = exactly
      @nodes = nodes
      @rule = rule
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
      when first_of_phrase? && !node.first_of_phrase?
        false
      else
        phrases[phrase_index] ||= []
        phrases[phrase_index] << node
        self.count += node.pronounciation_length
        true
      end
    end

    # @note Pronounciation count
    def count
      @count ||= 0
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

  class Node
    STAT_ID_FOR_NORMAL = 0
    STAT_ID_FOR_UNKNOWN = 1
    STAT_ID_FOR_BOS = 2
    STAT_ID_FOR_EOS = 3

    # @param node [Natto::MeCabNode]
    def initialize(node)
      @node = node
    end

    def analyzable?
      !bos? && !eos?
    end

    def auxiliary_verb?
      type == "助動詞"
    end

    def bos?
      stat == STAT_ID_FOR_BOS
    end

    def dependent?
      subtype1 == "非自立"
    end

    def element_of_ikku?
      normal?
    end

    def last_of_ikku?
      case
      when type == "連体詞"
        false
      when ["名詞接続", "格助詞", "係助詞", "連体化", "接続助詞", "並立助詞", "副詞化", "数接続"].include?(type)
        false
      when auxiliary_verb? && root_form == "だ"
        false
      else
        true
      end
    end

    def eos?
      stat == STAT_ID_FOR_EOS
    end

    def feature
      @feature ||= CSV.parse(@node.feature)[0]
    end

    def filler?
      type == "フィラー"
    end

    def first_of_ikku?
      case
      when !first_of_phrase?
        false
      # when filler?
      #   false
      when ["、", "・", " ", "　"].include?(surface)
        false
      else
        true
      end
    end

    def first_of_phrase?
      case
      when particle?
        false
      when auxiliary_verb?
        false
      when independent?
        false
      when postfix?
        false
      when dependent? && ["する", "できる"].include?(root_form)
        false
      else
        true
      end
    end

    def independent?
      subtype1 == "自立"
    end

    def inspect
      to_s.inspect
    end

    def normal?
      stat == STAT_ID_FOR_NORMAL
    end

    def particle?
      type == "助詞"
    end

    def postfix?
      subtype1 == "接尾"
    end

    def pronounciation
      feature[8]
    end

    def pronounciation_length
      @pronounciation_length ||= begin
        if pronounciation
          pronounciation_mora.length
        else
          0
        end
      end
    end

    def pronounciation_mora
      if pronounciation
        pronounciation.tr("ぁ-ゔ","ァ-ヴ").gsub(/[^アイウエオカ-モヤユヨラ-ロワヲンヴー]/, "")
      end
    end

    def root_form
      feature[6]
    end

    def stat
      @node.stat
    end

    def subtype1
      feature[1]
    end

    def subtype2
      feature[2]
    end

    def subtype3
      feature[3]
    end

    def surface
      @node.surface
    end

    def symbol?
      type == "記号"
    end

    def to_s
      surface
    end

    def type
      feature[0]
    end
  end
end
