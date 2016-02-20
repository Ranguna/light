#define PI 3.14

//uniform values
extern Image u_texture;
extern vec4 background;
//extern bool uAlpha;
//extern vec2 resolution;

vec4 effect( vec4 vColor, Image texture, vec2 texture_coords, vec2 screen_coords ) {
	if (Texel(texture,texture_coords).rgb != vec3(0.,0.,0.) && Texel(u_texture,texture_coords).rgb !=  vec3(0.,0.,0.)){
		vec4 u_color = Texel(u_texture,texture_coords);
		vec4 color = Texel(texture,texture_coords);
		return vec4(color.rgb,u_color.a);
		//return vec4(background.rgb*(1 - u_color.a) + color.rgb*u_color.a,background.a*(1-u_color.a)+u_color.a);
		
	}
	return vec4(background.rgba/255.);
}