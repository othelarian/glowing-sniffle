import getId, * as U from './utils.coffee'
import {GSAdd, GSCreate, GSModex} from './add.coffee'
import GSCurbs from './curbs.coffee'
import {GSCount, GSMain} from './main.coffee'
import GSPrefs from './prefs.coffee'

LS = U.LS

GS =
  # attributes
  block: ''
  config: [false]
  curr: {e: [], nb: 0}
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
  modex: GSModex
  prefs: GSPrefs
  # methods
  check: ->
    LS.prop('first') and LS.prop('list') and LS.prop('values') and LS.prop('curr')
  currinit: ->
    GS.curr.d = GS.current
    GS.curr.e = []
    m = GS.list.length + 1
    GS.curr.e.push false while m -= 1
    GS.update 'curr'
  get: ->
    GS.current = U.date2text new Date()
    GS.first = LS.get 'first'
    GS.list = JSON.parse LS.get 'list'
    GS.list_names = (e[0] for e in GS.list)
    GS.values = JSON.parse LS.get 'values'
    GS.curr = JSON.parse LS.get 'curr'
    if GS.curr.d isnt GS.current then GS.currinit()
    else GS.curr.nb = GS.curr.e.filter((e) => e).length
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
    GS.current = U.date2text new Date()
    GS.currinit()
    if ['add', 'main'].includes GS.last then GS[GS.last].prepare()
    GS.add.reset()
  reach: ->
    lsp = LS.get 'prefs'
    if lsp? then GS.config = JSON.parse lsp
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
  testa: (v) ->
    U.nb2time v
  #

initGlow = ->
  if navigator.serviceWorker?
    navigator.serviceWorker.register 'sw.js', {scope: '/glowing-sniffle/'}
  if LS.check()
    if GS.check() then GS.get() else GS.init()
    GS.reach()
  else
    U.setDisplay 'gs-nols', 'block'

window.GS = GS
window.initGlow = initGlow

