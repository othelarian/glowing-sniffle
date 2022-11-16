export date2text = (dt) ->
  y = dt.getFullYear() - 2000
  d = dt.getDate()
  d = if d < 10 then "0#{d}" else d
  m = dt.getMonth() + 1
  m = if m < 10 then "0#{m}" else m
  "#{m}#{d}#{y}"

export default getId = (id) -> document.getElementById id

export setDisplay = (id, chx) ->
  elt = getId id
  elt.style.display = chx

export text2slash = (txt) -> txt.replace /(\d{2})(\d{2})(\d{2})/, '$2/$1/$3'

export text2tiret = (txt) -> txt.replace /(\d{2})(\d{2})(\d{2})/, '$1-$2-$3'

export turnBtn = (id, out) ->
  cl = getId(id).classList
  if out then cl.add 'btn-inactive' else cl.remove 'btn-inactive'

