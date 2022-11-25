import getId, * as U from './utils.coffee'

export GSAddRep =
  act: (action) ->
    #
    # TODO
    #
    console.log 'not ready'
    #
  prepare: ->
    #
    # TODO
    #
    console.log 'not ready'
    #

export GSAddTime =
  act: (action) ->
    #
    # TODO
    #
    console.log 'not ready'
    #
  prepare: ->
    #
    # TODO
    #
    console.log 'not ready'
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
    #
    # TODO
    #
    id = "gs-main-ln-#{i}"
    #
    nl = U.createElt 'div', [['class', 'line-c']]
    #
    #
    #
    #
    getId('gs-main-list').append nl
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
