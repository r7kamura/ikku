require "csv"

module Ikku
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

    def bos?
      stat == STAT_ID_FOR_BOS
    end

    def conjugation1
      feature[4]
    end

    def conjugation2
      feature[5]
    end

    def eos?
      stat == STAT_ID_FOR_EOS
    end

    def element_of_ikku?
      normal?
    end

    def feature
      @feature ||= CSV.parse(@node.feature)[0]
    end

    def first_of_ikku?
      case
      when !first_of_phrase?
        false
      when type == "記号" && !["括弧開", "括弧閉"].include?(subtype1)
        false
      else
        true
      end
    end

    def first_of_phrase?
      case
      when ["助詞", "助動詞"].include?(type)
        false
      when ["非自立", "接尾"].include?(subtype1)
        false
      when subtype1 == "自立" && ["する", "できる"].include?(root_form)
        false
      else
        true
      end
    end

    def inspect
      to_s.inspect
    end

    def last_of_ikku?
      case
      when ["名詞接続", "格助詞", "係助詞", "連体化", "接続助詞", "並立助詞", "副詞化", "数接続", "連体詞"].include?(type)
        false
      when conjugation2 == "連用タ接続"
        false
      when conjugation1 == "サ変・スル" && conjugation2 == "連用形"
        false
      when type == "動詞" && ["仮定形", "未然形"].include?(conjugation2)
        false
      when type == "名詞" && subtype1 == "非自立" && pronunciation == "ン"
        false
      else
        true
      end
    end

    def last_of_phrase?
      type != "接頭詞"
    end

    def normal?
      stat == STAT_ID_FOR_NORMAL
    end

    def pronunciation
      feature[8]
    end

    def pronunciation_length
      @pronunciation_length ||= begin
        if pronunciation
          pronunciation_mora.length
        else
          0
        end
      end
    end

    def pronunciation_mora
      if pronunciation
        pronunciation.tr("ぁ-ゔ","ァ-ヴ").gsub(/[^アイウエオカ-モヤユヨラ-ロワヲンヴー]/, "")
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

    def to_s
      surface
    end

    def type
      feature[0]
    end
  end
end
