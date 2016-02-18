extern Image u_texture;

vec4 effect( vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords ) {
	//get u_texture's pixel and blend it
	//alpha blend:
	//return vec4(Texel(texture,texture_coords).rgb*(1 - Texel(u_texture,texture_coords).a) + Texel(u_texture,texture_coords).rgb*Texel(u_texture,texture_coords).a,max(Texel(u_texture,texture_coords).a,Texel(texture,texture_coords).a));
	//return vec4(1.,0.,0.,1.);
	if (Texel(u_texture,texture_coords).a > 0.) {
		//return vec4(Texel(texture,texture_coords).rgb*(1 - Texel(u_texture,texture_coords).a) + Texel(u_texture,texture_coords).rgb*Texel(u_texture,texture_coords).a,max(Texel(u_texture,texture_coords).a,Texel(texture,texture_coords).a));
		return vec4(1,0,0,1);
	}

	return Texel(u_texture,texture_coords).rgba;
}