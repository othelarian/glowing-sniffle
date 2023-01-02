export createElt = (tag, attrs, txt, html) ->
  elt = document.createElement tag
  afn = ([k, v]) -> elt.setAttribute(k, v)
  afn(attr) for attr in attrs
  if txt? then elt.innerText = txt
  else if html? then elt.innerHTML = html
  elt

export date2text = (dt) ->
  y = dt.getFullYear() - 2000
  d = dt.getDate()
  d = if d < 10 then "0#{d}" else d
  m = dt.getMonth() + 1
  m = if m < 10 then "0#{m}" else m
  "#{m}#{d}#{y}"

export getIcon = (v) -> if v then '&#xf698;' else '&#xfa1a;'

export getIconElt = (v) -> createElt 'i', [['class', 'icon']], null, getIcon v

export default getId = (id) -> document.getElementById id

export LS =
  check: ->
    tryit = 'try_lstest'
    try
      localStorage.setItem tryit, tryit
      localStorage.getItem tryit
      localStorage.removeItem tryit
      true
    catch
      false
  del: (key) -> localStorage.removeItem "gs-#{key}"
  get: (key) -> localStorage.getItem "gs-#{key}"
  prop: (prop) -> localStorage.hasOwnProperty "gs-#{prop}"
  set: (key, value) -> localStorage.setItem "gs-#{key}", value

export nb2time = (nb) ->
  corr = (nb) -> if nb < 10 then "0#{nb}" else nb
  minsec = (nb, toc) ->
    f = (nb - (nb % 60)) / 60
    "#{if toc then corr f else f}:#{corr(nb % 60)}"
  if nb > 3600 then "#{(nb - (nb % 3600)) / 3600}:" + (minsec (nb % 3600), true)
  else minsec nb, false

export setDisplay = (id, chx) ->
  elt = getId id
  elt.style.display = chx

export text2slash = (txt) -> txt.replace /(\d{2})(\d{2})(\d{2})/, '$2/$1/$3'

export text2tiret = (txt) -> txt.replace /(\d{2})(\d{2})(\d{2})/, '$1-$2-$3'

export turnBtn = (id, out) ->
  cl = getId(id).classList
  if out then cl.add 'btn-inactive' else cl.remove 'btn-inactive'

