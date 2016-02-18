light = require('light')

function love.load()
	light.load(800,600)
	light.addLight({x=100,y=100,rad=410,color={255,0,0}})

	image = love.graphics.newImage('shadow.png')
	scene = love.graphics.newCanvas(800,600)
end

function love.update(dt)
	love.window.setTitle(love.timer.getFPS())
	local x,y = love.mouse.getPosition()
	light.changeLight(1,{x=x,y=y})
end

function love.draw()
	love.graphics.setCanvas(scene)
		love.graphics.clear()

		love.graphics.draw(image)
	love.graphics.setCanvas()

	love.graphics.draw(light.generateShadows(scene))
	love.graphics.draw(light.generateScene(scene))
	love.graphics.print('#: '.. #light.getLight())
end

function love.keypressed(k)
	if k == 'up' then
		light.changeLight(1,{rad=light.getLight(1).rad+10})
	elseif k == 'down' then
		light.changeLight(1,{rad=light.getLight(1).rad-10})
	end
end

function love.mousepressed(x,y,k)
	if k == 3 then
		light.addLight({x=x,y=y,rad=light.getLight(1).rad,color={love.graphics.goldenColor(#light.getLight())}})
	end
end



--pretty colors code bellow
love.math.golden = (1+math.sqrt(5))/2
local offset = love.math.random()
function love.graphics.goldenColor(i)
	return love.math.HSVtoRGB(((offset + (love.math.golden * i) )% 1)*360,1,1)
end

love.math.HSVtoRGB = function(h, s, v)
	if s == 0 then
		return v,v,v
	end
	h = h/60
	i = math.floor( h )
	f = h - i
	p = v * ( 1 - s )
	q = v * ( 1 - s * f )
	t = v * ( 1 - s * ( 1 - f ) )
	if i == 0 then r, g, b = v, t, p
	elseif i == 1 then r, g, b = q, v, p
	elseif i == 2 then r, g, b = p, v, t
	elseif i == 3 then r, g, b = p, q, v
	elseif i == 4 then r, g, b = t, p, v
	elseif i == 5 then r, g, b = v, p, q
	end
	return r * 255, g * 255, b * 255
end