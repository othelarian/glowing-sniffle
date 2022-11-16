import getId, * as U from './utils.coffee'

export default GSCreate =
  act: (action) ->
    switch action
      when 'back' then GS.show 'add'
      when 'update' then GS.create.update()
      when 'create' then GS.create.valid()
  errdup: false
  ok: false
  prepare: ->
    getId('gs-create-name').value = GS.create.tmp
    GS.create.update()
  tmp: ''
  update: ->
    #
    # TODO
    #
    console.log 'access update'
    #
    inpv = getId('gs-create-name').value
    GS.create.tmp = inpv
    if inpv.length < 2
      #
      #U.setDisplay
      #
      # TODO: handle errdup
      #
      console.log 'not ready'
      #
    else
      #
      #
      # TODO: handle errdup
      #
      console.log 'maybe'
      #
    #
    U.turnBtn 'gs-create-valid', GS.create.ok
    #
    #
    # TODO: vérifier qu'au moins un des 2 types est sélectionné
    #
  valid: ->
    #
    # TODO
    #
    console.log 'not ready'
    #
