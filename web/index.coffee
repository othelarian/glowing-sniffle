import getId, * as U from './utils.coffee'
import GSAdd from './add.coffee'
import GSCreate from './create.coffee'
import GSCurbs from './curbs.coffee'
import GSMain from './main.coffee'
import GSPrefs from './prefs.coffee'

LS =
  check: ->
    tryit = 'try_lstest'
    try
      localStorage.setItem tryit, tryit
      localStorage.getItem tryit
      localStorage.removeItem tryit
      true
    catch
      false
  get: (key) -> localStorage.getItem key
  prop: (prop) -> localStorage.hasOwnProperty prop
  set: (key, value) -> localStorage.setItem key, value

GS =
  # attributes
  block: ''
  current: ''
  first: ''
  list: []
  values: {}
  routes: ['add', 'create', 'curbs', 'main', 'prefs']
  # submodules
  add: GSAdd,
  create: GSCreate,
  curbs: GSCurbs,
  main: GSMain,
  prefs: GSPrefs,
  # methods
  check: -> LS.prop('gs-first') and LS.prop('gs-list') and LS.prop('gs-values')
  get: ->
    GS.current = U.date2text new Date()
    GS.first = LS.get 'gs-first'
    GS.list = JSON.parse LS.get 'gs-list'
    GS.values = JSON.parse LS.get 'gs-values'
  init: ->
    i = U.date2text new Date()
    LS.set 'gs-first', i
    LS.set 'gs-list', '[]'
    LS.set 'gs-values', '{}'
    GS.current = i
    GS.first = i
  reach: ->
    GS.block =
      if location.hash is '' then 'main'
      else
        hsh = location.hash.substring 1
        if GS.routes.includes hsh then hsh
        else
          location.hash = ''
          'main'
    GS.show GS.block
    window.addEventListener 'hashchange', => GS.reach()
  show: (block) ->
    toHide = (bl) -> U.setDisplay 'gs-'+bl, 'none'
    toHide bl for bl in GS.routes
    GS.block = block
    GS[block].prepare()
    location.hash = block
    U.setDisplay 'gs-'+block, 'flex'
  update: ->
    #
    # TODO
    #
    #
    console.log 'update the ls with new info'
    #

initGlow = ->
  if LS.check()
    if GS.check() then GS.get() else GS.init()
    GS.reach()
  else
    U.setDisplay 'gs-nols', 'block'

window.GS = GS
window.initGlow = initGlow

