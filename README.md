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
Judge if given text is valid song or not.

```rb
reviewer.judge("古池や蛙飛び込む水の音") #=> true
reviewer.judge("ああ古池や蛙飛び込む水の音ああ") #=> false
```

### Ikku::Reviewer#find
Find one valid song from given text.

```rb
reviewer.find("ああ古池や蛙飛び込む水の音ああ")
#=> #<Ikku::Song>
```

### Ikku::Reviewer#search
Search all valid songs from given text.

```rb
reviewer.search("ああ古池や蛙飛び込む水の音ああ天秤や京江戸かけて千代の春ああ")
#=> [
#     #<Ikku::Song>,
#     #<Ikku::Song>,
#   ]
```

### Ikku::Song#phrases
Return an Array of phrases of `Ikku::Node`.

```rb
song.phrases #=> [["古池", "や"], ["蛙", "飛び込む"], ["水", "の", "音"]]
```

### Rule option
Pass `:rule` option to change the measure rule (default: `[5, 7, 5]`).

```rb
reviewer = Ikku::Reviewer.new(rule: [4, 3, 5])
reviewer.judge("古池や蛙飛び込む水の音") #=> false
reviewer.judge("すもももももももものうち") #=> true
```
