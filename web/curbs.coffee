#import getId, * as U from './utils.coffee' # TODO: vraiment utile ici ?

export default GSCurbs = {
  act: (action) ->
    switch action
      when 'main' then GS.show 'main'
      when 'prefs' then GS.show 'prefs'
  prepare: -> {}
}

