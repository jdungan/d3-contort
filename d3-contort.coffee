# Some helper classses
class xyValue
  constructor: (@x=0,@y=0) ->
  setValue: (newValue,increment) ->
    switch (typeof newValue)
      when 'number'
        if increment
          @x += newValue  
          @y += newValue
        else
          @x = newValue
          @y = newValue
      when 'object'
        if increment
          @x += newValue.x ?= newValue.x
          @y += newValue.y ?= newValue.x
        else
          @x = newValue.x ?= newValue.x
          @y = newValue.y ?= newValue.x
  toString: -> @x + "," + @y
   
class degreeValue
  constructor: (@number=0)->
  setValue: (newValue,increment)->
    if increment then newValue += @number
    @number = Math.round((newValue % 360 + ((if newValue >= 0 then 0 else 360))))  unless @number is newValue
  toString: -> @number

# The transform object
class Transform 
  constructor: ()->
     @translate ?= new xyValue 0,0
     @scale ?= new xyValue 1,1
     @rotate ?= new degreeValue
     @skewX ?= new degreeValue
     @skewY ?= new degreeValue
     
Transform::order = -> ["translate","scale","rotate","skewX","skewY"]

Transform::toString = ->
    @order().map(
      (name) -> name + "(" + @[name].toString() + ")"
    , @).join " "

# Start contorting d3.selection           
for name in Transform::order()
  do (name) ->
    d3.selection::[name] = (value,increment=false) ->
      for e,i in @[0]
        do (e)->
          e.__transform__  ?= new Transform
          switch (typeof value)
            when 'number','object'
              e.__transform__[name].setValue value,increment
            when 'function'
              e.__transform__[name].setValue value(e.__data__,i),increment
      @
  
d3.selection::render = ->
  for e in @[0]
    do (e)->
      e.__transform__  ?= new Transform
      d3.select(e).attr "transform", e.__transform__.toString()
  @       

d3.selection::animate = (options={}) ->
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
  
d3.selection::sequence = (options={}) ->
  duration = options.duration ?= 500
  ease = options.ease ?= "ease"
  opacity = options.opacity ?= "1"
  transition = d3.select(e).transition()
  for e in @[0]
    do (e)->
      e.__transform__ ?= new Transform        
      transition.transition()
        .duration(duration)
        .ease(d3.ease(ease))
        .attr({transform: e.__transform__.toString(),"opacity": opacity})
  @
  

