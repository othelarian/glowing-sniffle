#import getId from './utils.coffee' # TODO
import * as U from './utils.coffee'

export default GSAdd =
  act: (action) ->
    switch action
      when 'back' then GS.show 'main'
      when 'create' then GS.show 'create'
      when 'valid' then console.log 'not ready!' # TODO
  prepare: ->
    [n, y] =
      if GS.list.length is 0 then ['block', 'none']
      else
        #
        # TODO
        #
        ['none', 'block']
    U.setDisplay 'gs-add-nothing', n
    U.setDisplay 'gs-add-list', y

