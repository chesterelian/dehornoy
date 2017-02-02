fs = require 'fs'
execSync = require('child_process').execSync

inv = (braid) -> (-1 * gen for gen in braid.split ' ').reverse().join(' ')

exp = (braid, n) ->
  if n is 0
    ''
  else if n > 0
    (braid for [1..n]).join(' ')
  else
    exp(inv(braid), -n)

fullTwist = (n) -> ([1..n-1].join(' ') for [1..n]).join(' ')
negFullTwist = (n) -> ([1-n..-1].join(' ') for [1..n]).join(' ')

# assume input is dehornoy
isSigmaPos = (dehornoy) ->
  minGen = 999
  isPos = true
  for gen in dehornoy.split ' '
    if Math.abs(gen) < minGen
      minGen = Math.abs(gen)
      isPos = (gen > 0)
  isPos

getDehornoy = (braid) ->
  fs.writeFileSync('wordin', "#{braid} 0")
  execSync './a.out'
  (fs.readFileSync 'wordout', 'utf8').replace(/\s*$/, '')

isLt = (b1, b2) -> isSigmaPos getDehornoy "#{inv b1} #{b2}"

# assume braid is sigma-positive
getFloor = (braid, n) ->
  floor = 0
  while isLt(exp(fullTwist(n), floor + 1), braid)
    floor += 1
  floor

module.exports =
  exp: exp
  getDehornoy: getDehornoy
  getFloor: getFloor

getDehornoy2 = (word) ->

  getMinGen = ->
    minGen = Math.abs word[0]
    for gen in word
      minGen = Math.abs(gen) if Math.abs(gen) < minGen
    minGen

  dumbRed = ->
    l = -1
    w = 0
    for r in [0...word.length]
      if w is -1 * word[r]
        word[l] = word[r] = 0
        l -= 1
        w = if l < 0 then 0 else word[l]
      else
        l += 1
        if l isnt r
          word[l] = word[r]
          word[r] = 0
        w = word[l]

  findGen = (gen, start, end) ->
    for i in [start...end]
      return i if Math.abs(word[i]) is gen
    -1

  findHandle = (gen, start, end) ->
    handle = {}
    h1 = findGen(gen, start, end)
    if h1 in [-1, end - 1]
      handle.gen = 0
      return handle
    h2 = findGen(gen, h1 + 1, end)
    while h2 isnt -1
      if word[h1] is word[h2]
        h1 = h2
      else
        handle = { gen: gen, p1: h1, p2: h2 }
        return handle
    handle.gen = 0
    return handle

  handleTransform = (handle) ->
    1+1
