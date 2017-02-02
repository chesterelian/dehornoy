n = 4
minLen = 7
maxLen = 7

getWords = (len, firstNot) ->
  if len is 1
    ([x] for x in [-n+1..n-1].filter((x) -> x isnt 0 and x isnt firstNot))
  else
    res = []
    for gen in getWords(1, firstNot)
      res = res.concat(gen.concat(thing) for thing in getWords(len - 1, -gen[0]))
    res

words = []
for len in [minLen..maxLen]
  words = words.concat(getWords(len,0))

for word, i in words
  console.log "#{i+1}\t#{word.join ' '}"
