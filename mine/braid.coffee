class Word
  constructor: (@word) ->
    @history = []

  getMinGen: -> Math.min.apply null, (Math.abs(gen) for gen in @word)
  getMaxGen: -> Math.max.apply null, (Math.abs(gen) for gen in @word)
  getStrands: -> @getMaxGen() + 1

  isSigmaPos: -> @word.indexOf(@getMinGen()) isnt -1

  append: (braid) -> @word.concat braid
  prepend: (braid) -> braid.concat @word
  inv: -> (-gen for gen in [].concat(@word).reverse())
  exp: (p) ->
    if p is 0
      []
    else if p > 0
      temp = []
      temp = temp.concat(@word) for [1..p]
      temp
    else
      thing = (-gen for gen in [].concat(@word).reverse())
      temp = []
      temp = temp.concat(thing) for [1..-p]
      temp

  fullTwist: (p) ->
    return [] if p is 0
    n = @getStrands()
    ft = []
    Array::push.apply(ft, [1..n-1]) for [1..n]
    # ft is now one full twist
    ft = new Word ft
    ft.exp(p)

  getFloor: ->
    @reduce()
    floor = if @isSigmaPos() then 0 else -1
    while floor >= 0
      console.log "floor so far: #{floor}"
      #temp = new Word(@prepend(@fullTwist(- floor - 1)))
      newWord = @fullTwist(- floor - 1).concat @word
      console.log "newWord is #{newWord.join ' '}"
      temp = new Word newWord
      #temp.print()
      temp.reduce()
      console.log "reduced is #{temp.word.join ' '}"
      if temp.isSigmaPos()
        floor += 1
      else
        return floor
    while floor <= -1
      console.log "floor so far: #{floor}"
      temp = new Word(@prepend @fullTwist(- floor + 1))
      temp.reduce()
      if not temp.isSigmaPos()
        floor -= 1
      else
        return 1 - floor

  getFdtc: =>
    @reduce()
    n = @getStrands()
    console.log "strands is #{n}"
    m = n * (n - 1) + 1
    temp = new Word(@exp(m))
    temp.print()
    temp.getFloor()

  freeReduction: ->
    i = 0
    while i < @word.length
      if @word[i] is -@word[i + 1]
        @history.push { word: [].concat(@word), start: i, end: i + 1 }
        @word.splice i, 2
        i -= 1
      else
        i += 1

  # returns index of first occurence of gen in the range
  #   word[start] <= ? <= word[end]
  # returns -1 if not found
  findGen: (gen, start, end) ->
    for i in [start..end]
      return i if Math.abs(@word[i]) is gen
    -1

  # find a gen-handle in the range [start, end]
  # returns handle object which has 3 properties: gen, left, right
  # if no handle found, gen is 0, left and right are whatever
  findHandle: (gen, start, end) ->
    return { gen: 0 } if start >= end
    l = @findGen(gen, start, end)
    return { gen: 0 } if l in [-1, end]
    r = @findGen(gen, l + 1, end)
    while r isnt -1
      if @word[l] isnt @word[r]
        return { gen: gen, left: l, right: r }
      l = r
      r = if l + 1 >= end then -1 else @findGen(gen, l + 1, end)
    { gen: 0 }

  handleTransform: (handle) ->
    e = if @word[handle.left] > 0 then 1 else -1
    newHandle = []
    for i in [handle.left + 1..handle.right - 1]
      if Math.abs(@word[i]) isnt handle.gen + 1
        newHandle.push @word[i]
      else
        newHandle.push(
          -e * (handle.gen + 1),
          (if @word[i] > 0 then 1 else -1) * handle.gen,
          e * (handle.gen + 1)
        )
    @history.push { word: [].concat(@word), start: handle.left, end: handle.right }
    Array::splice.apply @word, [handle.left, handle.right - handle.left + 1].concat(newHandle)
    @freeReduction()

  handleReduction: (handle) ->
    loop
      subhandle = @findHandle(handle.gen + 1, handle.left + 1, handle.right - 1)
      if subhandle.gen is 0
        before = @word.length
        @handleTransform handle
        after = @word.length
        return after - before
      else
        handle.right += @handleReduction subhandle

  reduce: ->
    @freeReduction()
    gen = @getMinGen()
    h = @findHandle(gen, 0, @word.length - 1)
    if h.gen isnt 0
      @handleReduction h
    else
      return
    @reduce()

  print: ->
    console.log @word.join ' '

  printHistory: ->
    for entry in @history
      console.log entry
      temp = [].concat entry.word
      temp.splice entry.start, 0, '['
      temp.splice entry.end + 2, 0, ']'
      console.log temp.join ' '

#braid = new Word [1,2,3,2,-1,-2,-1,-2,-3,-2,-1]
#braid = new Word [-1,2,1,-3,-1,-3,1]
#braid = new Word [3,3,-2,3,2,1,1,2,-1]
#braid = new Word [3,3,-2,3,2,-1,2,1,1]
#braid = new Word [3,2,1,-3,-4,-2,-3,1,2,2,1,3,4,4]
braid = new Word [
  -4,-3,-2,-1,-4,-3,-2,-1,-4,-3,-2,-1,-4,-3,-2,-1,-4,-3,-2,-1,
  3,2,1,-3,-4,-2,-3,1,2,2,1,3,4,4,
  3,2,1,-3,-4,-2,-3,1,2,2,1,3,4,4,
  3,2,1,-3,-4,-2,-3,1,2,2,1,3,4,4,
  3,2,1,-3,-4,-2,-3,1,2,2,1,3,4,4,
  3,2,1,-3,-4,-2,-3,1,2,2,1,3,4,4,
  3,2,1,-3,-4,-2,-3,1,2,2,1,3,4,4,
  3,2,1,-3,-4,-2,-3,1,2,2,1,3,4,4,
  3,2,1,-3,-4,-2,-3,1,2,2,1,3,4,4,
  3,2,1,-3,-4,-2,-3,1,2,2,1,3,4,4,
  3,2,1,-3,-4,-2,-3,1,2,2,1,3,4,4,
  3,2,1,-3,-4,-2,-3,1,2,2,1,3,4,4,
  3,2,1,-3,-4,-2,-3,1,2,2,1,3,4,4,
  3,2,1,-3,-4,-2,-3,1,2,2,1,3,4,4,
  3,2,1,-3,-4,-2,-3,1,2,2,1,3,4,4,
  3,2,1,-3,-4,-2,-3,1,2,2,1,3,4,4,
  3,2,1,-3,-4,-2,-3,1,2,2,1,3,4,4,
  3,2,1,-3,-4,-2,-3,1,2,2,1,3,4,4,
  3,2,1,-3,-4,-2,-3,1,2,2,1,3,4,4,
  3,2,1,-3,-4,-2,-3,1,2,2,1,3,4,4,
  3,2,1,-3,-4,-2,-3,1,2,2,1,3,4,4,
  3,2,1,-3,-4,-2,-3,1,2,2,1,3,4,4
]
#braid.print()
braid.reduce()
braid.printHistory()
braid.print()
#console.log braid.getFdtc()
#console.log braid.fullTwist(-2).join ' '
