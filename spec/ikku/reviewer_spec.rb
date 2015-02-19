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

    context "with song starting with no pronounciation length node" do
      let(:text) do
        "「#{super()}"
      end

      it { is_expected.to be false }
    end

    context "with song ending with 連用タ接続 (撮っ)" do
      let(:text) do
        "新宿の桜と庭の写真撮っ"
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
