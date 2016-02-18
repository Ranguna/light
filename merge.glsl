#define PI 3.14

//uniform values
extern Image u_texture;
extern bool uAlpha;
//extern vec2 resolution;

vec4 effect( vec4 vColor, Image texture, vec2 texture_coords, vec2 screen_coords ) {
	if (Texel(texture,texture_coords).rgb != vec3(0.,0.,0.) && Texel(u_texture,texture_coords).rgb !=  vec3(0.,0.,0.)){
		if (uAlpha == false) {
			return Texel(texture,texture_coords).rgba;
		}
		return vec4(Texel(texture,texture_coords).rgb,Texel(u_texture,texture_coords).a);
		//return vec4(1.,0.,0.,1.);
	}
	return vec4(0.);
}