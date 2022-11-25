import getId, * as U from './utils.coffee'

export default GSPrefs =
  act: (action) ->
    switch action
      when 'curbs' then GS.show 'curbs'
      when 'main' then GS.show 'main'
      when 'modex' then GS.prefs.modex()
      when 'reset' then GS.prefs.reset()
  modex: ->
    GS.config[0] = getId('gs-prefs-modex').checked
    U.LS.set 'prefs', JSON.stringify GS.config
  normal: ->
    U.setDisplay 'gs-prefs-valid', 'none'
    U.setDisplay 'gs-prefs-main', 'block'
    GS.prefs.request = ''
  prepare: ->
    getId('gs-prefs-modex').checked = GS.config[0]
    GS.prefs.normal()
  request: ''
  req_cancel: -> GS.prefs.normal()
  req_valid: ->
    switch (GS.prefs.request)
      when 'reset'
        localStorage.clear()
        GS.init()
    GS.prefs.normal()
  reset: ->
    U.setDisplay 'gs-prefs-valid', 'block'
    U.setDisplay 'gs-prefs-main', 'none'
    GS.prefs.request = 'reset'
  #
  #
  # TODO: reset partiel (jusqu'à une date)
  #
  # TODO: autorisé la modif des jours échus
  #
  # TODO: autorisé l'effacement d'exercice
  #

