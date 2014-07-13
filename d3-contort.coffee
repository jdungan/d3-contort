
#   increment: (newValue) =>
#       if typeof newValue is "number"
#           inner.x += newValue
#           inner.y += newValue
#       else
#         inner.x += newValue.x  if newValue.x?
#         inner.y += newValue.y  if newValue.y?


order = ["translate","scale","rotate"]

class xyValue
  constructor: (@x,@y) ->
    @x?=0
    @y?=0
  value: (newValue) ->
    switch (typeof newValue)
      when 'number'
        @x = newValue
        @y = newValue
      when 'object'
        @x = newValue.x ?= newValue.x
        @y = newValue.y ?= newValue.x
      when 'undefined'
        {x:@x,y:@y}
  toString: -> @x + "," + @y
  # increment: (newValue) =>
  #   switch (typeof newValue)
  #     when 'number'
  #       @x += newValue
  #       @y += newValue
  #     when 'object'
  #       @x += newValue.x?
  #       @y += newValue.y?
  
  
class numValue
  constructor: (@number)->
    @number?=0
  value: (newValue)->
    return @number if newValue is 'undefined'
    @number = Math.round((newValue % 360 + ((if newValue >= 0 then 0 else 360))))  unless @number is newValue
  toString: -> @number


class Transform
  constructor: (order)->
     @translate ?= new xyValue 0,0
     @scale ?= new xyValue 1,1
     @rotate ?= new numValue

Transform::toString = ->
    order.map(
      (name) -> name + "(" + @[name].toString() + ")"
    , @).join " "
          
for name in order
  do (name) ->
    d3.selection::[name] = (value) ->
      for e,i in @[0]
        do (e)->
          e.__transform__  ?= new Transform
          switch (typeof value)
            when 'number'
              e.__transform__[name].value value
            when 'function'
              e.__transform__[name].value value(e.__data__,i)
      @

d3.selection::contort = ->
  for e in @[0]
    do (e)->
      e.__transform__  ?= new Transform
  @
  
d3.selection::render = ->
  for e in @[0]
    do (e)->
      e.__transform__  ?= new Transform
      d3.select(e).attr "transform", e.__transform__.toString()
  @       

d3.selection::animate = (options) ->
  options ?=  {}
  duration = options.duration ?= 500
  ease = options.ease ?= "ease"
  opacity = options.opacity ?= "1"
  for e in @[0]
    do (e)->
      e.__transform__ ?= new Transform        
      d3.select(e).transition()
        .duration(duration)
        .ease(d3.ease(ease))
        .attr({transform: e.__transform__.toString(),"opacity": opacity})
  @       
  
  

