#define PI 3.14

//uniform values
extern Image u_texture;
//extern vec2 resolution;

vec4 effect( vec4 vColor, Image texture, vec2 vTexCoord0, vec2 screen_coords ) {
    //rectangular to polar
    vec2 norm = vTexCoord0.st * 2.0 - 1.0;
    number theta = atan(norm.y, norm.x);
    number r = length(norm); 
    number coord = (theta + PI) / (2.0*PI);

    if (r > Texel(u_texture, vec2(coord,0.)).r && r < Texel(u_texture, vec2(coord,0.)).g) {
    	return vec4(vColor.rgb,smoothstep(1.0, 0.0, r));
    }
    return vec4(vColor.rgb,0.);
}