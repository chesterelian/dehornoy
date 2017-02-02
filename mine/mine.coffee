class Word
  constructor: (@word) ->

  getMinGen: ->
    minGen = Math.abs @word[0]
    for gen in @word
      minGen = Math.abs(gen) if Math.abs(gen) < minGen
    minGen

  freeReduction: ->
    i = 0
    while i < @word.length
      if @word[i] is -@word[i + 1]
        console.log "Free reduction: #{@word}"
        @word.splice i, 2
        i -= 1
      else
        i += 1
    console.log "Free reduction: #{@word}"

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
    console.log "finding #{gen}-handle in [#{start}, #{end}]"
    return { gen: 0 } if start is end
    l = @findGen(gen, start, end)
    console.log "l is #{l}"
    return { gen: 0 } if l in [-1, end]
    console.log "l is legit (not -1 or #{end})"
    r = @findGen(gen, l + 1, end)
    console.log "r is #{r}"
    while r isnt -1
      if @word[l] isnt @word[r]
        console.log "found handle; returning"
        return { gen: gen, left: l, right: r }
      l = r
      console.log "l is now #{l}; end is #{end}"
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
    Array::splice.apply @word, [handle.left, handle.right - handle.left + 1].concat(newHandle)
    console.log "called handleTransform: #{@word}"
    @freeReduction()

  handleReduction: (handle) ->
    loop
      console.log "finding subhandle in"
      console.log handle
      subhandle = @findHandle(handle.gen + 1, handle.left + 1, handle.right - 1)
      console.log "subhandle is"
      console.log subhandle
      if subhandle.gen is 0
        console.log "transforming handle..."
        console.log "before: #{@word}"
        before = @word.length
        @handleTransform handle
        after = @word.length
        console.log "after: #{@word}"
        return after - before
      else
        handle.right += @handleReduction subhandle

  reduce: ->
    @freeReduction()
    gen = @getMinGen()
    console.log "minGen is #{gen}"
    h = @findHandle(gen, 0, @word.length - 1)
    if h.gen isnt 0
      console.log "found handle:"
      console.log h
      console.log "calling handleReduction"
      @handleReduction h
      console.log "finished calling handleReduction"
    else
      return
    @reduce()

  print: ->
    console.log @word

#braid = new Word [1,2,3,2,-1,-2,-1,-2,-3,-2,-1]
braid = new Word [-1,2,1,-3,-1,-3,1]
braid.reduce()
braid.print()
