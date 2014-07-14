
# d3-contort.js

Extends d3's selection functions to allow you to make css transforms on a group of elements. It allows you to chain transformations together in the same way d3 allows you to chain attributes.  It also lets you forget about the sting manipulation needed for the transform attribute.

##Examples

###Simple move

  d3.select('circle').translate(50).render()

###Chained transforms

  d3.select('rect').rotate(45).scale(1.5).render()

###Chained transition

  d3.select('circle').rotate(45).scale(1.5).animate({duration:2000,opacity:'.5',ease:'cubic'})

##Property Functions

**selection.translate(value,[increment])**

  Accepts either a function, number or object.  If _value_ is a function is will be passed the element's datum and index.  This function must return a number or object with x and y properties. Passing a number will change both x and y to that number. Passing an object with x and y propoerties (e.g. {x:10,y:25}) will change the corresponding x and y value of the property.  Objects passed with one x or y, or neither will not change the value of the missing property.

**selection.scale(value,[increment])**

  Accepts either a function, number or object.  If _value_ is a function is will be passed the element's datum and index.  This function must return a number or object with x and y properties. Passing a number will change both x and y to that number. Passing an object with x and y propoerties (e.g. {x:10,y:25}) will change the corresponding x and y value of the property.  Objects passed with one x or y, or neither will not change the value of the missing property.

**selection.rotate(value,[increment])**

  Accepts a function or a number.  If _value_ is a function is will be passed the elements datum and index.  This function must return a number. 
  
  The number is converted to an integer between -360 and 360.

###[increment]
Setting the _increment_ argument to true will add the value to the property rather than replacing it.


##Display functions

You have to end a chain of property functions with .render() or .animate() in order to see your changes.

**selection.render()**

Immediately displays changes.  Equivalent to d3.selection.attr('transform','translate(20) ...')
  
**selection.animate([options])**

Performs a d3 transition using the elements current Transform values.  The transition is applied to each element in the selection.

###Animate [options]
-Passing an object with the following properties will be applied to the d3 transition.

**duration:** defaults to 500ms 

**ease:** defaults to "ease"

**opacity:** defaults to "1"
  
**Notes on the opacity option:** 
1.Opacitiy is not a d3 transition option but is passed as a d3 attr along with the transform. 
2.In order to see a transition you need to pass a string with the opacity number (e.g. '.8' or '0').  
  

##The Transform object
  d3-contort works by storing an instance of a Transform object to a property called \_\_transform\_\_ of a selected element.  The main reason for this object is to store the current transform state.  For the most part this object works behind the scenes and you don't have to mess with it.  Just in case...
  
###Transform.toString()
    Returns a string suitable for the d3.transform attr.  The string contains all transform properties (e.g. 'translate(10,10) scale(1,1) rotations(45)')
  
###Transform.order
    This is an array that sets the order of the d3 attr transform string.  This is very important to the outcome of combined changes such as translation and rotation.
    
  
  
  
  
