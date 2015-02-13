# Ikku
Discover haiku from text.

## Requirements
- Ruby 2.0.0+
- MeCab with IPADIC (e.g. `brew install mecab mecab-ipadic`)

## Example
### Ikku::Reviewer
Ikku::Reviewer class is the main interface for this library.

```rb
require "ikku"
reviewer = Ikku::Reviewer.new
```

### Ikku::Reviewer#judge
Judge if given text is haiku or not.

```rb
reviewer.judge("古池や蛙飛び込む水の音") #=> true
reviewer.judge("ああ古池や蛙飛び込む水の音ああ") #=> false
```

### Ikku::Reviewer#find
Find one available haiku from given text.

```rb
reviewer.find("ああ古池や蛙飛び込む水の音ああ")
#=> [["古池", "や"], ["蛙", "飛び込む"], ["水", "の", "音"]]
```

### Ikku::Reviewer#search
Search searches all available haikus from given text.

```rb
reviewer.search("ああ古池や蛙飛び込む水の音ああ天秤や京江戸かけて千代の春ああ")
#=> [
#     [["古池", "や"], ["蛙", "飛び込む"], ["水", "の", "音"]],
#     [["天秤", "や"], ["京", "江戸", "かけ", "て"], ["千代", "の", "春"]]
#   ]
#
```

### rule option
Change the rule by `rule` option (default: `[5, 7, 5]`).

```rb
reviewer.judge("古池や蛙飛び込む水の音", rule: [4, 3, 5]) #=> false
reviewer.judge("すもももももももものうち", rule: [4, 3, 5]) #=> true
```
