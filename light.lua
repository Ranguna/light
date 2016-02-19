local light = {}

light.canvas = {}
light.shader = {}
light.shader.UDShadow = love.graphics.newShader('1DShadow.glsl')
light.shader.shadow = love.graphics.newShader('shadow.glsl')
light.shader.light = love.graphics.newShader('light.glsl')
light.shader.merge = love.graphics.newShader('merge.glsl')
light.shader.lCircle = love.graphics.newShader('lCircle.glsl')
light.shader.draw = love.graphics.newShader('draw.glsl')

function light.load(w,h)
	light.light = {}
	light.canvas.FBO = {}
	light.canvas.UDS = {}
	light.shadowScene = love.graphics.newCanvas(w,h)
	light.lightScene = love.graphics.newCanvas(w,h)
	light.mergeScene = {love.graphics.newCanvas(w,h),love.graphics.newCanvas(w,h)}
	light.lightCScene = {love.graphics.newCanvas(w,h),love.graphics.newCanvas(w,h),love.graphics.newCanvas(w,h)}
	light.w,light.h = w,h
	light.m = math.max(light.w,light.h)
end

function light.generateScene(scene)
	local lscene = light.generateLight(scene)
	--lscene:newImageData():encode('png','lscene.png')
	love.graphics.setCanvas(light.mergeScene[1])
		love.graphics.clear()
		love.graphics.setShader(light.shader.merge)
		light.shader.merge:send('u_texture',lscene)
		light.shader.merge:send('background',{0,0,0,0})
		--light.shader.merge:send('uAlpha',true)

		love.graphics.draw(scene)
		love.graphics.setShader()
	love.graphics.setCanvas()
	return light.mergeScene[1]
end

function light.generateLight(scene)
	love.graphics.setCanvas(light.lightScene)
		love.graphics.clear()
	love.graphics.setCanvas()

	--love.graphics.setBlendMode('replace','premultiplied')
	for i,v in ipairs(light.light) do
		love.graphics.setCanvas(light.canvas.FBO[v.rad *2][1])
			love.graphics.clear()
			love.graphics.draw(scene,-(v.x-v.rad),-(v.y-v.rad))
		love.graphics.setCanvas()

		--generate 1D shadow map lookup
		love.graphics.setCanvas(light.canvas.UDS[v.rad ][1])
			love.graphics.clear()
			love.graphics.setShader(light.shader.UDShadow)
			light.shader.UDShadow:send('resolution',{v.rad,v.rad})
			light.shader.UDShadow:send('u_texture',light.canvas.FBO[v.rad*2][1])
			love.graphics.draw(light.canvas.UDS[v.rad ][2])
			love.graphics.setShader()
		love.graphics.setCanvas()

		--generate shadow
		love.graphics.setCanvas(light.canvas.FBO[v.rad*2][2])
			love.graphics.clear()
			love.graphics.setShader(light.shader.light)
			love.graphics.setColor(v.color)
			--light.shader.shadow:send('resolution',{v.rad,v.rad})
			light.shader.light:send('u_texture',light.canvas.UDS[v.rad ][1])
			love.graphics.draw(light.canvas.FBO[v.rad*2][1])
			love.graphics.setShader()
		love.graphics.setCanvas()

		--inverts shadow canvas in the y axis
		love.graphics.setCanvas(light.canvas.FBO[v.rad*2][1])
			love.graphics.clear()
			love.graphics.setColor(255, 255, 255)
			love.graphics.draw(light.canvas.FBO[v.rad*2][2], 0, 0, 0, 1, -1, 0, light.canvas.FBO[v.rad*2][2]:getHeight())
		love.graphics.setCanvas()


		--blend shadow into scene
		love.graphics.setCanvas(light.lightScene)
			love.graphics.setColor(255, 255, 255, 255)
			love.graphics.setBlendMode('alpha','alphamultiply')
			love.graphics.draw(light.canvas.FBO[v.rad*2][1], (v.x-v.rad),(v.y-v.rad))
		love.graphics.setCanvas()
		love.graphics.setBlendMode('alpha')
	end
	
	love.graphics.setColor(255, 255, 255, 255)
	return light.lightScene
end

function light.generateShadows(scene)
	love.graphics.setCanvas(light.shadowScene)
		love.graphics.clear()
		love.graphics.setColor(0, 0, 0, 255)
		love.graphics.rectangle('fill', 0, 0, light.w, light.h)
	love.graphics.setCanvas()

	for i,v in ipairs(light.light) do
		love.graphics.setCanvas(light.canvas.FBO[v.rad *2][1])
			love.graphics.clear()
			love.graphics.draw(scene,-(v.x-v.rad),-(v.y-v.rad))
		love.graphics.setCanvas()

		--generate 1D shadow map lookup
		love.graphics.setCanvas(light.canvas.UDS[v.rad ][1])
			love.graphics.clear()
			love.graphics.setShader(light.shader.UDShadow)
			light.shader.UDShadow:send('resolution',{v.rad,v.rad})
			light.shader.UDShadow:send('u_texture',light.canvas.FBO[v.rad*2][1])
			love.graphics.draw(light.canvas.UDS[v.rad ][2])
			love.graphics.setShader()
		love.graphics.setCanvas()

		--generate shadow
		love.graphics.setCanvas(light.canvas.FBO[v.rad*2][2])
			love.graphics.clear()
			love.graphics.setShader(light.shader.shadow)
			love.graphics.setColor(v.color)
			--light.shader.shadow:send('resolution',{v.rad,v.rad})
			light.shader.shadow:send('u_texture',light.canvas.UDS[v.rad ][1])
			love.graphics.draw(light.canvas.FBO[v.rad*2][1])
			love.graphics.setShader()
		love.graphics.setCanvas()

		--inverts shadow canvas in the y axis
		love.graphics.setCanvas(light.canvas.FBO[v.rad*2][1])
			love.graphics.clear()
			love.graphics.setColor(255, 255, 255)
			love.graphics.draw(light.canvas.FBO[v.rad*2][2], 0, 0, 0, 1, -1, 0, light.canvas.FBO[v.rad*2][2]:getHeight())
		love.graphics.setCanvas()


		--blend shadow into scene
		love.graphics.setCanvas(light.shadowScene)
			love.graphics.setColor(255, 255, 255, 255)
			love.graphics.setBlendMode('add')
			love.graphics.draw(light.canvas.FBO[v.rad*2][1], (v.x-v.rad),(v.y-v.rad))
		love.graphics.setCanvas()
		love.graphics.setBlendMode('alpha')
	end
	
	love.graphics.setColor(255, 255, 255, 255)
	
	return light.shadowScene
end

function light.getLight(i)
	if i then
		return {x=light.light[i].x,y=light.light[i].y,rad=light.light[i].rad,color = light.light[i].color}
	else
		return light.light
	end
end

function light.changeLight(i,args)
	--if args.rad then print('changing',args.x,args.y,args.rad,args.color) end
	if args.rad then
		args.rad = args.rad > 50 and args.rad or 50
		if light.canvas.FBO[light.light[i].rad *2].using -1 > 0 then
			light.canvas.FBO[light.light[i].rad *2].using = light.canvas.FBO[light.light[i].rad *2].using -1
			light.canvas.UDS[light.light[i].rad ].using = light.canvas.UDS[light.light[i].rad ].using -1
		else
			light.canvas.FBO[light.light[i].rad *2] = nil
			light.canvas.UDS[light.light[i].rad ] = nil
		end
		if light.canvas.FBO[args.rad*2] then
			light.canvas.FBO[args.rad*2].using = light.canvas.FBO[args.rad*2].using +1
			light.canvas.UDS[args.rad].using = light.canvas.UDS[args.rad].using +1
		else
			light.canvas.FBO[args.rad*2] = {using = 1,love.graphics.newCanvas(args.rad*2,args.rad*2),love.graphics.newCanvas(args.rad*2,args.rad*2)}
			light.canvas.UDS[args.rad] = {using = 1,love.graphics.newCanvas(args.rad,1),love.graphics.newCanvas(args.rad,1)}
		end
	end
	args.x = args.x or light.light[i].x
	args.y = args.y or light.light[i].y
	args.rad = args.rad or light.light[i].rad
	args.color = args.color or light.light[i].color
	--if args.rad then print('changing2',args.x,args.y,args.rad,args.color) end
	light.light[i] = args
end

function light.addLight(...)
	for i,v in ipairs({...}) do
		table.insert(light.light,v)
		print('adding',v.x,v.y,v.rad,v.color)
		if light.canvas.FBO[v.rad*2] then
			light.canvas.FBO[v.rad*2].using = light.canvas.FBO[v.rad*2].using +1
			light.canvas.UDS[v.rad].using = light.canvas.UDS[v.rad].using +1
		else
			light.canvas.FBO[v.rad*2] = {using = 1,love.graphics.newCanvas(v.rad*2,v.rad*2),love.graphics.newCanvas(v.rad*2,v.rad*2)}
			light.canvas.UDS[v.rad] = {using = 1,love.graphics.newCanvas(v.rad,1),love.graphics.newCanvas(v.rad,1)}
		end
		return #light.light
	end
end

function light.removeLight(i)
	if light.canvas.FBO[light.light[i].rad *2].using -1 > 0 then
		light.canvas.FBO[light.light[i].rad *2].using = light.canvas.FBO[light.light[i].rad *2].using -1
		light.canvas.UDS[light.light[i].rad ].using = light.canvas.UDS[light.light[i].rad ].using -1
	else
		light.canvas.FBO[light.light[i].rad *2] = nil
		light.canvas.UDS[light.light[i].rad ] = nil
	end
	table.remove(ligth.light, i)
end

return light
