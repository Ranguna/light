--libiliz
--...
-- profit
light = require('light')

function love.load()
	--[[light = {}
	light.canvas = {}
	light.canvas.FBO = {}
	light.canvas.UDS = {}
	table.insert(light,{90,90,410,color = {255,0,0}})
	light.canvas.FBO[820] = {using = 1,love.graphics.newCanvas(820,820),love.graphics.newCanvas(820,820)}
	light.canvas.UDS[410] = {using = 1,love.graphics.newCanvas(410,1),love.graphics.newCanvas(410,1)}
	light.shader = {}
	light.shader.UDShadow = love.graphics.newShader('1DShadow.glsl')
	light.shader.shadow = love.graphics.newShader('shadow.glsl')]]
	light.load(800,600)
	light.addLight({x=90,y=90,rad=410,color={255,0,0}})

	scene = love.graphics.newCanvas()
	shadowScene = love.graphics.newCanvas()

	lwjglImage = love.graphics.newImage('shadow.png')

	love.filesystem.setIdentity('lwjdlS')
	saved = false

	window = {0,0}
end

function love.update(dt)
	love.window.setTitle(love.timer.getFPS())
	local x,y = love.mouse.getPosition()
	--light[1][1],light[1][2] = x-window[1],y-window[2]
	light.changeLight(1,{x=x,y=y})
	--[[--best when not used
	if love.keyboard.isDown('w') then
		window[2] = window[2] -100*dt
	end
	if love.keyboard.isDown('s') then
		window[2] = window[2] +100*dt
	end
	if love.keyboard.isDown('d') then
		window[1] = window[1] +100*dt
	end
	if love.keyboard.isDown('a') then
		window[1] = window[1] -100*dt
	end]]
end



function love.draw()
	--draws scene
	love.graphics.setCanvas(scene)
		love.graphics.clear()
		--love.graphics.rectangle('fill', 100, 100, 50, 100)
		love.graphics.translate(window[1], window[2])

		love.graphics.draw(lwjglImage)
	
		love.graphics.origin()
	love.graphics.setCanvas()


	--[[--reset shadowScene
	love.graphics.setCanvas(shadowScene)
		love.graphics.clear()
		love.graphics.setColor(0, 0, 0, 255)
		love.graphics.rectangle('fill', 0, 0, shadowScene:getWidth(), shadowScene:getHeight())
	love.graphics.setCanvas()

	--updates lights
	for i,v in ipairs(light) do
		local px,py = v[1]+window[1],v[2]+window[2]
		love.graphics.setCanvas(light.canvas.FBO[v[3]*2][1])
			love.graphics.clear()
			love.graphics.draw(scene,-(px-v[3]),-(py-v[3]))
		love.graphics.setCanvas()

		--generate 1D shadow map lookup
		love.graphics.setCanvas(light.canvas.UDS[v[3] ][1])
			love.graphics.clear()
			love.graphics.setShader(light.shader.UDShadow)
			light.shader.UDShadow:send('resolution',{v[3],v[3]})
			light.shader.UDShadow:send('u_texture',light.canvas.FBO[v[3]*2][1])
			love.graphics.draw(light.canvas.UDS[v[3] ][2])
			love.graphics.setShader()
		love.graphics.setCanvas()

		--generate shadow
		love.graphics.setCanvas(light.canvas.FBO[v[3]*2][2])
			love.graphics.clear()
			love.graphics.setShader(light.shader.shadow)
			love.graphics.setColor(v.color)
			--light.shader.shadow:send('resolution',{v[3],v[3]})
			light.shader.shadow:send('u_texture',light.canvas.UDS[v[3] ][1])
			love.graphics.draw(light.canvas.FBO[v[3]*2][1])
			love.graphics.setShader()
		love.graphics.setCanvas()

		--inverts shadow canvas in the y axis
		love.graphics.setCanvas(light.canvas.FBO[v[3]*2][1])
			love.graphics.clear()
			love.graphics.setColor(255, 255, 255)
			love.graphics.draw(light.canvas.FBO[v[3]*2][2], 0, 0, 0, 1, -1, 0, light.canvas.FBO[v[3]*2][2]:getHeight())
		love.graphics.setCanvas()


		--blend shadow into scene
		love.graphics.setCanvas(shadowScene)
			love.graphics.setColor(255, 255, 255, 255)
			love.graphics.setBlendMode('add')
			love.graphics.draw(light.canvas.FBO[v[3]*2][1], (px-v[3]),(py-v[3]))
		love.graphics.setCanvas()
		love.graphics.setBlendMode('alpha')





	end]]


	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.origin()
	--love.graphics.draw(light.generateShadows(scene)) --shadow scene
	love.graphics.draw(light.canvas.UDS[light.light[1].rad][1]) --1D lookup
	--love.graphics.draw(light.canvas.FBO[light.light[1].rad*2][1]) --shadow
	--love.graphics.draw(scene)
	love.graphics.draw(light.generateLight(scene)) --light scene
	--love.graphics.draw(light.generateScene(scene)) --scene scene
	--love.graphics.draw(light.generateLightCircle()) --scene scene

	love.graphics.print('#: '.. #light.getLight())
end

function love.keypressed(k)
	if k == 'down' then
		--[[if light.canvas.FBO[light[1][3]*2].using -1 == 0 then
			light.canvas.FBO[light[1][3]*2] = nil
		end
		if light.canvas.UDS[light[1][3] ].using -1 == 0 then
			light.canvas.UDS[light[1][3] ] = nil
		end
		light[1][3] = light[1][3] -10 >= 10 and light[1][3] -10 or 10
		light.canvas.FBO[light[1][3]*2] = {using = 1,love.graphics.newCanvas(light[1][3]*2,light[1][3]*2),love.graphics.newCanvas(light[1][3]*2,light[1][3]*2)}
		light.canvas.UDS[light[1][3] ] = {using = 1,love.graphics.newCanvas(light[1][3],1),love.graphics.newCanvas(light[1][3],1)}]]
		light.changeLight(1,{rad=light.getLight(1)[3]-10})
	elseif k == 'up' then
		--[[if light.canvas.FBO[light[1][3]*2].using -1 == 0 then
			light.canvas.FBO[light[1][3]*2] = nil
		end
		if light.canvas.UDS[light[1][3] ].using -1 == 0 then
			light.canvas.UDS[light[1][3] ] = nil
		end
	    light[1][3] = light[1][3] +10
	    light.canvas.FBO[light[1][3]*2] = {using = 1,love.graphics.newCanvas(light[1][3]*2,light[1][3]*2),love.graphics.newCanvas(light[1][3]*2,light[1][3]*2)}
		light.canvas.UDS[light[1][3] ] = {using = 1,love.graphics.newCanvas(light[1][3],1),love.graphics.newCanvas(light[1][3],1)}]]
		light.changeLight(1,{rad=light.getLight(1)[3]+10})
	elseif k == 'escape' then
		window = {0,0}
	end
end

function love.mousepressed(x,y,k)
	if k == 3 then
		light.addLight({x=x,y=y,rad=light.getLight(1).rad,color={love.graphics.goldenColor(#light.getLight())}})
	end
end

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