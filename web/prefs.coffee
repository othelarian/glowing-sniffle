export default GSPrefs = {
  act: (action) ->
    switch action
      when 'main' then GS.show 'main'
      when 'curbs' then GS.show 'curbs'
  prepare: -> {}
}

