import getId, * as U from './utils.coffee'

export GSCount =
  act: (action) ->
    switch action
      when 'back' then GS.swift 'count', 'main'
      when 'inprep' then GS.count.inprep()
      when 'repless' then GS.count.moverep -1
      when 'repmore' then GS.count.moverep 1
      when 'repupdown' then GS.count.keyrep()
      when 'valid'
        if GS.count.oldinp isnt '' and GS.count.oldinp isnt '0' then GS.count.valid()
  checkValid: ->
    U.turnBtn 'gs-count-valid', GS.count.oldinp is '' or GS.count.oldinp is '0'
  id: 0
  inpreg: /^[\-]{0,1}[0-9]{0,3}$/
  inprep: ->
    inp = getId 'gs-count-rep-inp'
    if GS.count.inpreg.test inp.value then GS.count.oldinp = inp.value
    else inp.value = GS.count.oldinp
    GS.count.updateRepBtns()
  keyrep: ->
    moving = (dir) ->
      v = parseInt GS.count.oldinp
      if -1000 < (v + dir) < 1000
        GS.count.oldinp = (v + dir).toString()
        getId('gs-count-rep-inp').value = GS.count.oldinp
        GS.count.updateRepBtns()
    if event.keyCode is 38 then moving 1
    else if event.keyCode is 40 then moving -1
  moverep: (dir) ->
    v = parseInt GS.count.oldinp
    if -1000 < (v + dir) < 1000
      GS.count.oldinp = (v + dir).toString()
      getId('gs-count-rep-inp').value = GS.count.oldinp
      GS.count.updateRepBtns()
  oldinp: '0'
  prepare: ->
    handleSight = (t) ->
      U.setDisplay 'gs-count-title-rep', if t then 'inline' else 'none'
      U.setDisplay 'gs-count-title-time', if not t then 'inline' else 'none'
      U.setDisplay 'gs-count-rep', if t then 'block' else 'none'
      U.setDisplay 'gs-count-time', if not t then 'block' else 'none'
    getId('gs-count-date').innerText = U.text2tiret GS.current
    ex = getId 'gs-count-exo'
    ex.replaceChildren()
    ex.append U.getIconElt GS.count.tomod[1]
    ex.append U.createElt 'label', [[]], GS.count.tomod[0]
    if GS.count.tomod[1]
      handleSight true
      getId('gs-count-rep-inp').value = 0
      GS.count.updateRepBtns()
    else
      handleSight false
      #
      # TODO: et si c'est un temps ?
      #
      #
    GS.count.oldinp = '0'
    U.turnBtn 'gs-count-valid', true
  tomod: null
  updateRepBtns: ->
    U.turnBtn 'gs-count-rep-more', GS.count.oldinp is '999'
    U.turnBtn 'gs-count-rep-less', GS.count.oldinp is '-999'
    GS.count.checkValid()
  valid: ->
    #
    # TODO: si c'est une valeur négative, demander une seconde vérification
    #
    console.log 'valid (to do)'
    #
    #v = parseInt GS.count.
    #
    #

export GSMain =
  add_active: false,
  left_active: false,
  right_active: false,
  act: (action) ->
    switch action
      when 'add' then if GS.main.add_active then GS.swift 'main', 'add'
      when 'curbs' then GS.show 'curbs'
      when 'left' then if GS.main.left_active then GS.main.move 'left'
      when 'prefs' then GS.show 'prefs'
      when 'right' then if GS.main.right_active then GS.main.move 'right'
  line: (i) ->
    id = "gs-main-ln-#{i}-mod"
    v = GS.list[i]
    nl = U.createElt 'div', [['class', 'line-c']]
    nl.append U.getIconElt v[1]
    nl.append U.createElt 'label', [['class', 'lab-switch'], ['for', id]], v[0]
    rep = if v[1] then v[2] else U.nb2time v[2]
    btn_attrs = [['class', 'value'], ['id', id], ['onclick', "GS.main.mod(#{i})"]]
    nl.append U.createElt 'button', btn_attrs, rep
    getId('gs-main-list').append nl
  mod: (i) ->
    GS.count.id = i
    GS.count.tomod = GS.list[i]
    GS.swift 'main', 'count'
  move: (sens) ->
    curr_date = new Date U.text2tiret GS.current
    curr_date.setDate(curr_date.getDate() + (if sens is 'left' then -1 else 1))
    GS.current = U.date2text curr_date
    GS.main.update()
    GS.main.set()
  prepare: ->
    GS.main.update()
    GS.main.set()
  set: ->
    list = getId 'gs-main-list'
    list.replaceChildren()
    if GS.values.hasOwnProperty(GS.current) or (GS.curr.d is GS.current and GS.curr.nb > 0)
      if GS.curr.d is GS.current
        ((v, i) -> if v then GS.main.line(i)) v, i for v, i in GS.curr.e
      else
        GS.main.line i for i in Object.keys GS.values[GS.current]
    else
      list.innerHTML = '<div class="nothing">Vous n\'avez aucune activité enregistrée</div>'
  update: ->
    now = U.date2text new Date()
    r_active = if GS.current is now then false else true
    l_active = GS.current isnt GS.first
    GS.main.add_active = not r_active
    GS.main.left_active = l_active
    GS.main.right_active = r_active
    U.turnBtn 'gs-main-add', r_active
    U.turnBtn 'gs-main-left', not l_active
    U.turnBtn 'gs-main-right', not r_active
    getId('gs-main-date').innerText = U.text2slash GS.current
