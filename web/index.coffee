import getId, * as U from './utils.coffee'
import {LS} from './utils.coffee'
import {GSAdd, GSCreate} from './add.coffee'
import GSCurbs from './curbs.coffee'
import {GSMain, GSCount} from './main.coffee'
import GSPrefs from './prefs.coffee'

GS =
  # attributes
  block: ''
  curr: {e: []}
  current: ''
  first: ''
  last: ''
  list: []
  list_names: []
  values: {}
  routes: ['curbs', 'main', 'prefs']
  # submodules
  add: GSAdd
  count: GSCount
  create: GSCreate
  curbs: GSCurbs
  main: GSMain
  prefs: GSPrefs
  # methods
  check: ->
    LS.prop('first') and LS.prop('list') and LS.prop('values') and LS.prop('curr')
  get: ->
    GS.current = U.date2text new Date()
    GS.first = LS.get 'first'
    GS.list = JSON.parse LS.get 'list'
    GS.list_names = (e[0] for e in GS.list)
    GS.values = JSON.parse LS.get 'values'
    GS.curr = JSON.parse LS.get 'curr'
    if GS.curr.d isnt GS.current
      GS.curr.d = GS.curent
      GS.curr.e = []
      GS.update 'curr'
  init: ->
    i = U.date2text new Date()
    LS.set 'first', i
    LS.set 'list', '[]'
    LS.set 'values', '{}'
    GS.curr.d = i
    LS.set 'curr', JSON.stringify GS.curr
    GS.current = i
    GS.first = i
  midnight: ->
    #
    # TODO
    #
    console.log 'reaching midnight'
    #
    GS.current = U.date2text new Date()
    GS.curr.d = GS.current
    GS.curr.e = []
    GS.update 'curr'
    if ['add', 'main'].includes GS.last then GS[GS.last].prepare()
    GS.add.reset()
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
    t = new Date()
    t.setHours 0
    t.setMinutes 0
    t.setSeconds 0
    t.setMilliseconds 0
    t.setDate t.getDate() + 1
    setTimeout GS.midnight, t - (new Date())
  show: (block) ->
    if GS.last isnt '' then U.setDisplay "gs-#{GS.last}", 'none'
    GS.block = block
    GS[block].prepare()
    location.hash = block
    GS.last = block
    U.setDisplay 'gs-'+block, 'flex'
  swift: (before, after) ->
    U.setDisplay 'gs-'+before, 'none'
    GS[after].prepare()
    GS.last = after
    U.setDisplay 'gs-'+after, 'flex'
  update: (to_up, json = true) ->
    LS.set to_up, (if json then JSON.stringify GS[to_up] else GS[to_up])
  #
  # TODO
  #
  #testa: ->
  #  U.createElt 'p', [['id', 'plop'], ['g', 'ggg']], null, 'plap'
  #

initGlow = ->
  if LS.check()
    if GS.check() then GS.get() else GS.init()
    GS.reach()
  else
    U.setDisplay 'gs-nols', 'block'

window.GS = GS
window.initGlow = initGlow

