{ braids } = require './braids12d.js'
{ getFloor, exp } = require './dehornoy.js'

isSigmaPos = (dehornoy) ->
  minGen = 999
  isPos = true
  for gen in dehornoy.split ' '
    if Math.abs(gen) < minGen
      minGen = Math.abs(gen)
      isPos = (gen > 0)
  isPos

for braid in braids

  # algebraic length of braid word
  braid.algLen = braid.notation.split(' ').length - 2 * braid.notation.replace(/[0-9 ]/g, '').length

  # self-linking number
  braid.sl = braid.algLen - braid.index

  # sigma-positive or sigma-negative?
  for gen in braid.dehornoy.split ' '
    if 1 * gen is 1
      braid.positive = true
      break
    else if 1 * gen is -1
      braid.positive = false
      break

  # is floor == 0?
  #braid.isFloorZero = (braid.positive and not isSigmaPos(braid.dehornoy2))

  braid.floor = if braid.positive then getFloor(braid.dehornoy, braid.index) else -1

  braid.N = braid.index * (braid.index - 1) + 1
  braid.twist = getFloor(exp(braid.dehornoy, braid.N))

  # does the flip automorphism work?
  braid.doesFlipWork = "yes"
  sign = ''
  for gen in braid.dehornoy.split ' '
    if (1 * gen) is (braid.index - 1)
      braid.doesFlipWork = "no"
      break

  if braid.positive and braid.floor is 0 and braid.doesFlipWork is "no" and braid.twist isnt 0
    #console.log exp(braid.dehornoy, braid.N)
    console.log "#{braid.name}\t#{braid.twist}\t#{braid.N}"
