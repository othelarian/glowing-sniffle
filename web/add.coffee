import getId, * as U from './utils.coffee'

export GSCreate =
  act: (action) ->
    switch action
      when 'back' then GS.swift 'create', 'add'
      when 'update' then GS.create.update()
      when 'create' then GS.create.valid()
  errdup: false
  ok: false
  prepare: ->
    getId('gs-create-name').value = GS.create.tmp
    GS.create.update()
  tmp: ''
  update: ->
    inpv = getId('gs-create-name').value
    GS.create.tmp = inpv
    if inpv.length < 3
      GS.create.ok = false
      GS.create.errdup = false
    else
      GS.create.errdup = GS.list_names.includes inpv
      GS.create.ok = not GS.create.errdup
    U.setDisplay 'gs-create-errdup', (if GS.create.errdup then 'block' else 'none')
    U.turnBtn 'gs-create-valid', not GS.create.ok
  valid: ->
    rep = getId 'gs-create-type-rep'
    GS.list.push [GS.create.tmp, rep.checked, 0]
    GS.list_names.push GS.create.tmp
    GS.update 'list'
    GS.create.ok = false
    GS.create.tmp = ''
    rep.checked = true
    GS.swift 'create', 'add'

export GSAdd =
  act: (action) ->
    switch action
      when 'back' then GS.show 'main'
      when 'create' then GS.swift 'add', 'create'
      when 'valid' then console.log 'not ready!' # TODO
  line: (ex) ->
    #
    # TODO
    #
    nl = U.createElt 'div', [['class', 'line']]
    hd = U.createElt 'div', [], null, if ex[1] then '&#xf698;' else '&#xfa1a;'
    nl.append hd
    cp = U.createElt 'div', [], ex[0]
    nl.append cp
    #
    #
    #
    getId('gs-add-list').append nl
    #
    console.log 'generate a line'
    #
  ok: false
  prepare: ->
    #
    # TODO: limitation du nombre d'exercices
    #
    gsd = getId 'gs-add-date'
    gsd.innerText = U.text2slash GS.current
    [n, y] =
      if GS.list.length is 0 then ['block', 'none']
      else
        getId('gs-add-list').replaceChildren()
        GS.add.line ex for ex in GS.list
        ['none', 'block']
    U.setDisplay 'gs-add-nothing', n
    U.setDisplay 'gs-add-list', y
    #
    # TODO: prise en compte du cache
    #
    U.turnBtn 'gs-add-valid', not GS.add.ok
  reset: ->
    #
    # TODO: appelé lors du changement de jour, pour vider le cache
    #
    console.log 'not ready yet'
    #
    GS.add.ok = false
    #

