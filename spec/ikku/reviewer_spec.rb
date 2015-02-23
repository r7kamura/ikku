require "spec_helper"

RSpec.describe Ikku::Reviewer do
  let(:instance) do
    described_class.new(rule: rule)
  end

  let(:rule) do
    nil
  end

  let(:text) do
    "古池や蛙飛び込む水の音"
  end

  describe "#find" do
    subject do
      instance.find(text)
    end

    context "with invalid song" do
      let(:text) do
        "test"
      end

      it { is_expected.to be_nil }
    end

    context "with valid song" do
      it { is_expected.to be_a Ikku::Song }
    end

    context "with text including song" do
      let(:text) do
        "ああ#{super()}ああ"
      end

      it { is_expected.to be_a Ikku::Song }
    end

    context "with text including song ending with 連用タ接続" do
      let(:text) do
        "リビングでコーヒー飲んでだめになってる"
      end

      it { is_expected.to be_nil }
    end

    context "with song ending with 仮定形" do
      let(:text) do
        "その人に金をあげたい人がいれば"
      end

      it { is_expected.to be_nil }
    end
  end

  describe "#judge" do
    subject do
      instance.judge(text)
    end

    context "with valid song" do
      it { is_expected.to be true }
    end

    context "with invalid song" do
      let(:text) do
        "#{super()}ああ"
      end

      it { is_expected.to be false }
    end

    context "with rule option and valid song" do
      let(:rule) do
        [4, 3, 5]
      end

      let(:text) do
        "すもももももももものうち"
      end

      it { is_expected.to be true }
    end

    context "with rule option and invalid song" do
      let(:rule) do
        [4, 3, 5]
      end

      it { is_expected.to be false }
    end

    context "with phrase starting with independent verb (歩く)" do
      let(:text) do
        "なぜ鳩は頭を振って歩くのか"
      end

      it { is_expected.to be true }
    end

    context "with phrase including English" do
      let(:text) do
        "Apple#{super()}"
      end

      it { is_expected.to be false }
    end

    context "with phrase ending with 接頭詞" do
      let(:text) do
        "レバーのお汁飲んだので元気出た"
      end

      it { is_expected.to be false }
    end

    context "with song starting with symbol" do
      let(:text) do
        "、#{super()}"
      end

      it { is_expected.to be false }
    end

    context "with song ending with 連用タ接続 (撮っ)" do
      let(:text) do
        "新宿の桜と庭の写真撮っ"
      end

      it { is_expected.to be false }
    end

    context "with song including even parentheses" do
      let(:text) do
        "古池や「蛙＜飛び込む＞」水の音"
      end

      it { is_expected.to be true }
    end

    context "with song including odd parentheses" do
      let(:text) do
        "古池や「蛙＜飛び込む」＞水の音"
      end

      it { is_expected.to be false }
    end

    context "with song starting with parenthesis" do
      let(:text) do
        "（#{super()}）"
      end

      it { is_expected.to be true }
    end

    context "with song ending with サ変・スル in 連用形 (-し)" do
      let(:text) do
        "炊きつけて画面眺めて満足し"
      end

      it { is_expected.to be false }
    end
  end

  describe "#search" do
    subject do
      instance.search(text)
    end

    context "without song" do
      let(:text) do
        "test"
      end

      it { is_expected.to be_a Array }
    end

    context "with valid song" do
      it { is_expected.to be_a Array }
    end

    context "with text including song" do
      let(:text) do
        "ああ#{super()}ああ"
      end

      it { is_expected.to be_a Array }
    end
  end
end
