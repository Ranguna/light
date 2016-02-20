# light
This library allows you to add shadows to your 2D game with ease with it's simple API.

***

**Installing light:** 
* Put the 'light' folder wherever you want. (Ex: root of the working directory).
* Add it by running `require((path to light folder) ..'light')` to your code.
* The output will be the light system, Ex:

```lua
light = require("light")

function love.load()
  print(light) --table with the light API
end
```
* Lunch your game and start adding lights.

Usage:
======
`light` works by adding light to a single canvas this means that you need to load your whole map into a canvas and send it to `light`, this might not be very efficient but for now that's all I got to give you, I'm planning on adding three more types of rendering in the future which would allow you to render just a small part of your map.

The first thing you need to do after "requiring" `light` is to load it:
```lua
light = require("light")

function love.load()
  light.load(w,h)
end
```
Where `w` and `h` are respectivly the width and the height of the map canvas that you want to draw. Let's use LÖVE's default dimensions `800`x`600`.

`light` generates shadows with a single function, `.generateShadows(scene)` where `scene` is your map's canvas. The output of this function is a canvas with shadows, keep in mind that this canvas will only contain the shadows and not your map's assets so you'll need to draw both the shadow canvas and your map's canvas:
```lua
light = require("light")

function love.load()
  light.load(800,600)
  
  scene = love.graphics.newCanvas(800,600)
end

function love.draw()
  love.graphics.setCanvas(scene)
    local x,y = love.mouse.getPosition()
    if love.mouse.isDown(1) then
      love.graphics.setColor(0,0,255)
      love.graphics.circle('fill',x,y,20)
    elseif love.mouse.isDown(2) then
      love.graphics.setColor(0,0,255,0)
      love.graphics.circle('fill',x,y,20)
    end
  love.graphics.setCanvas()
  
  love.graphics.draw(light.generateShadows(scene))
  love.graphics.draw(scene)
end
```
This code draws circles on the screen if the left mouse button is pressed and it will erase them if the right button is down.
As you can see both the output from `.generateShadows` and the `scene` canvas were drawn to the screen, the order is very important, first you draw the shadows and then the `scene`.

But we can't see lights in the code, everything is black, that's because we haven't added lights yet, we do this using the `.addLight` function.

The `.addLight({x=x,y=y,rad=rad,color={r,g,b}},...)` accepts any number of arguments, the arguments need to be tables and they need to contain `x`, `y`, `rad` and `color` indexes where `color` is a table containing the`RGB` color code that you want you light to have, you can add more than one light at a time.

We'll add a red light to our code:
```lua
light = require("light")

function love.load()
  light.load(800,600)
  light.addLight({x=100,y=100,rad=410,color={255,0,0}})
  
  scene = love.graphics.newCanvas(800,600)
end

function love.draw()
  love.graphics.setCanvas(scene)
    local x,y = love.mouse.getPosition()
    if love.mouse.isDown(1) then
      love.graphics.setColor(0,0,255)
      love.graphics.circle('fill',x,y,20)
    elseif love.mouse.isDown(2) then
      love.graphics.setColor(0,0,255,0)
      love.graphics.circle('fill',x,y,20)
    end
  love.graphics.setCanvas()
  
  love.graphics.draw(light.generateShadows(scene))
  love.graphics.draw(scene)
end
```
Out red light has position (100,100) and has a radius of 410px. If you draw circles around the light you'll notice that shadows start to form, there you have it, shadows!

You can change all the light's properties by using the `.changeLight` function, this function accepts two arguments, the index of the light and a table containing the properties that you want to change, if you just want to change the `x` position of the light then you just need to pass that value to the table: `.changeLight(1,{x=200})` the other properties won't change. Let's try this out:
```lua
light = require("light")

function love.load()
  light.load(800,600)
  light.addLight({x=100,y=100,rad=410,color={255,0,0}})
  light.changeLight(1,{x=200})
  
  scene = love.graphics.newCanvas(800,600)
end

function love.draw()
  love.graphics.setCanvas(scene)
    local x,y = love.mouse.getPosition()
    if love.mouse.isDown(1) then
      love.graphics.setColor(0,0,255)
      love.graphics.circle('fill',x,y,20)
    elseif love.mouse.isDown(2) then
      love.graphics.setColor(0,0,255,0)
      love.graphics.circle('fill',x,y,20)
    end
  love.graphics.setCanvas()
  
  love.graphics.draw(light.generateShadows(scene))
  love.graphics.draw(scene)
end
```
As expected, the light changed position. Let's lock the light to our mouse:
```lua
light = require("light")

function love.load()
  light.load(800,600)
  light.addLight({x=100,y=100,rad=410,color={255,0,0}})
  
  scene = love.graphics.newCanvas(800,600)
end

function love.update(dt)
  local x,y = love.mouse.getPosition()
  light.changeLight(1,{x=x,y=y})
end

function love.draw()
  love.graphics.setCanvas(scene)
    local x,y = love.mouse.getPosition()
    if love.mouse.isDown(1) then
      love.graphics.setColor(0,0,255)
      love.graphics.circle('fill',x,y,20)
    elseif love.mouse.isDown(2) then
      love.graphics.setColor(0,0,255,0)
      love.graphics.circle('fill',x,y,20)
    end
  love.graphics.setCanvas()
  
  love.graphics.draw(light.generateShadows(scene))
  love.graphics.draw(scene)
end
```
Awesome !

You can also remove lights with `.removeLight`, this function accepts a single argument, the index of the light. Everytime you create a new light with `.addLight` you get the index of the light that you've just created, this way you can keep track of all your lights.

API:
======
#### .load(w,h)
###### Usage:
Starts the light system with the given `w`, `h` dimensions.
###### Accepts:
Two values, the width and the height of your scene.
###### Returns:
Nothing.
***
#### .addLight({x=x,y=y,rad=rad,color=color},...)
###### Usage:
Adds a light given it's position, radius and color.
###### Accepts:
Any number of arguments given that they are all tables containing `x`, `y`, `rad` and `color` indexes where `color` is a table containing the`RGB` color code that you want you light to have, you can add more than one light at a time.
###### Returns:
The index of the light that was just created.
***
#### .changeLight(i,{x=x,y=y,rad=rad,color=color})
###### Usage:
Changes the light properties of the light with index `i`. You can leave out any property that you don't want to change.
###### Accepts:
Two values, the index of the light and a table containing the properties that you want to change.
###### Return:
Nothing.
***
#### .removeLight(i)
###### Usage:
Remove the light with index i, this will mess up all the light indexes, I need to fix this.
###### Accepts:
One value, the index of the light that you want to change.
###### Returns:
Nothing.
