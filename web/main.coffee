import getId, * as U from './utils.coffee'

export GSCount =
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
    #
    # TODO: la liste est construite ici
    #
    list = getId 'gs-main-list'
    if GS.values.hasOwnProperty GS.current
      #
      # TODO: il est temps d'afficher le score actuel
      #
      console.log 'not ready yet'
      #
      list.innerText = 'not ready'
      #
    else
      list.innerHTML = '<div class="nothing">Vous n\'avez aucune activité enregistrée</div>'
  update: ->
    now = U.date2text new Date()
    [r_active, a_active] = if GS.current is now then [false, true] else [true, false]
    l_active = GS.current isnt GS.first
    GS.main.add_active = a_active
    GS.main.left_active = l_active
    GS.main.right_active = r_active
    U.turnBtn 'gs-main-add', not a_active
    U.turnBtn 'gs-main-left', not l_active
    U.turnBtn 'gs-main-right', not r_active
    getId('gs-main-date').innerText = U.text2slash GS.current

