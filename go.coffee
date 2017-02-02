fs = require 'fs'
execSync = require('child_process').execSync

getDehornoy = (braid) ->
  fs.writeFileSync('wordin', braid + ' 0')
  execSync './a.out'
  (fs.readFileSync 'wordout', 'utf8').replace(/\s*$/, '')

fullTwist = (n) -> ([1..n-1].join(' ') for [1..n]).join(' ')
negFullTwist = (n) -> ([1-n..-1].join(' ') for [1..n]).join(' ')

#files = ("braids#{x}" for x in '10 11 12a 12b 12c 12d'.split ' ')
files = ['enum_4_7', 'enum_4_8']

for file in files

  braids = []

  [knots..., empty] = (fs.readFileSync "#{file}.data", 'utf8').split '\n'

  for knot in knots
    #[name, index, notation] = knot.split '\t'
    [name, notation] = knot.split '\t'
    #notation = notation.replace(/[{}]/g, '').replace(/,/g, ' ')
    #if index >= 4
    if true
      #braids.push { name: name, index: index, notation: notation }
      braids.push { name: name, notation: notation }

  for braid in braids
    braid.dehornoy = getDehornoy braid.notation
    #braid.dehornoy2 = getDehornoy "#{negFullTwist(braid.index)} #{braid.notation}"
    #braid.dehornoy2 = getDehornoy "#{negFullTwist(4)} #{braid.notation}"

  fs.writeFileSync "#{file}.js", "exports.braids = #{JSON.stringify(braids, null, 2)};"
