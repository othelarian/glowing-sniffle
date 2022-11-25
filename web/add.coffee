import getId, * as U from './utils.coffee'

LS = U.LS

export GSAdd =
  act: (action) ->
    switch action
      when 'back' then GS.show 'main'
      when 'create' then GS.swift 'add', 'create'
  line: (ex, i) ->
    id = "gs-add-ln-#{i}"
    nl = U.createElt 'div', [['class', 'line-c']]
    if GS.config[0]
      mod = U.createElt 'button', [['onclick', "GS.add.mod(#{i})"]]
      it = U.createElt 'i', [], null, '&#xf448;'
      mod.append it
      nl.append mod
    hd = U.createElt 'i', [['class', 'icon']], null, if ex[1] then '&#xf698;' else '&#xfa1a;'
    nl.append hd
    cp = U.createElt 'label', [['for', id], ['class', 'lab-switch']], ex[0]
    nl.append cp
    sl = U.createElt 'label', [['class', 'switch']]
    #
    # TODO: si l'exercice a déjà des répétition enregistrée, alors il l'empêcher d'être
    # sélectionnable
    #
    insl_tab = [['type', 'checkbox'], ['id', id], ['onchange', "GS.add.select(#{i})"]]
    if GS.curr.e[i] then insl_tab.push ['checked', 'checked']
    insl = U.createElt 'input', insl_tab
    sl.append insl
    sl.append U.createElt('span', [])
    nl.append sl
    getId('gs-add-list').append nl
  mod: (id) ->
    GS.modex.id = id
    GS.modex.base = GS.list[id]
    GS.swift 'add', 'modex'
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
        GS.add.line ex, id for ex, id in GS.list
        ['none', 'block']
    U.setDisplay 'gs-add-nothing', n
    U.setDisplay 'gs-add-list', y
  reset: ->
    deactivate = (elt) -> elt.checked = false
    deactivate elt for elt in document.querySelectorAll '#gs-add-list .line-c input'
  select: (id) ->
    v = getId("gs-add-ln-#{id}").checked
    GS.curr.e[id] = v
    GS.curr.nb = GS.curr.nb + (if v then 1 else -1)
    GS.update 'curr'

export GSCreate =
  act: (action) ->
    switch action
      when 'back' then GS.swift 'create', 'add'
      when 'update' then GS.create.update()
      when 'valid' then GS.create.valid()
  prepare: ->
    getId('gs-create-name').value = GS.create.tmp
    GS.create.update()
  tmp: ''
  update: ->
    inpv = getId('gs-create-name').value
    GS.create.tmp = inpv
    [errdup, ok] =
      if inpv.length < 3 then [false, false]
      else
        errdup = GS.list_names.includes inpv
        [errdup, not errdup]
    U.setDisplay 'gs-create-errdup', (if errdup then 'block' else 'none')
    U.turnBtn 'gs-create-valid', not ok
  valid: ->
    rep = getId 'gs-create-type-rep'
    GS.list.push [GS.create.tmp, rep.checked, 0]
    GS.list_names.push GS.create.tmp
    GS.update 'list'
    GS.create.tmp = ''
    rep.checked = true
    GS.curr.e.push false
    GS.update 'curr'
    GS.swift 'create', 'add'

export GSModex =
  act: (action) ->
    switch action
      when 'back' then GS.modex.quit()
      when 'type' then GS.modex.switchType()
      when 'update' then GS.modex.update()
      when 'valid' then GS.modex.valid()
  base: null
  check: ->
    ok = not GS.modex.errdup and (GS.modex.txtchg or GS.modex.typechg)
    if GS.modex.ok isnt ok
      U.turnBtn 'gs-modex-valid', not ok
      GS.modex.ok = ok
  errdup: false
  id: -1
  ok: false
  prepare: ->
    getId('gs-modex-name').value = GS.modex.base[0]
    tosel = if GS.modex.base[1] then 'rep' else 'time'
    getId("gs-modex-type-#{tosel}").checked = true
    GS.modex.errdup = false
    GS.modex.txtchg = false
    GS.modex.typechg = false
    GS.modex.ok = false
    U.setDisplay 'gs-modex-errdup', 'none'
    U.turnBtn 'gs-modex-valid', true
    getId('gs-modex-seltype').innerHTML = (if GS.modex.base[1] then '&#xf698;' else '&#xfa1a;')
    getId('gs-modex-oldname').innerText = GS.modex.base[0]
    U.setDisplay 'gs-modex-radios', (if GS.modex.base[2] > 0 then 'none' else 'block')
    GS.modex.check()
  quit: ->
    GS.modex.base = null
    GS.modex.id = -1
    GS.swift 'modex', 'add'
  switchType: ->
    GS.modex.typechg = getId('gs-modex-type-rep').checked isnt GS.modex.base[1]
    GS.modex.check()
  txtchg: false
  typechg: false
  update: ->
    inpv = getId('gs-modex-name').value
    [errdup, chg] =
      if inpv.length < 3 or inpv is GS.modex.base[0] then [false, false]
      else [GS.list_names.includes(inpv), true]
    if GS.modex.errdup isnt errdup
      U.setDisplay 'gs-modex-errdup', (if errdup then 'block' else 'none')
      GS.modex.errdup = errdup
    GS.modex.txtchg = chg
    GS.modex.check()
  valid: ->
    name = getId('gs-modex-name').value
    seltype = getId('gs-modex-type-rep').checked
    nbase = [name, seltype, GS.modex.base[2]]
    GS.list_names[GS.modex.id] = name
    GS.list[GS.modex.id] = nbase
    GS.update 'list'
    GS.modex.quit()
