#define PI 3.14

//uniform values
extern Image u_texture;
//extern vec2 resolution;

//sample from the 1D distance map
number sample(vec2 coord, number r) {
    return step(r, Texel(u_texture, coord).r);
}

vec4 effect( vec4 vColor, Image texture, vec2 vTexCoord0, vec2 screen_coords ) {
    //rectangular to polar
    vec2 norm = vTexCoord0.st * 2.0 - 1.0;
    number theta = atan(norm.y, norm.x);
    number r = length(norm); 
    number coord = (theta + PI) / (2.0*PI);

    //the tex coord to sample our 1D lookup texture 
    //always 0.0 on y axis
    vec2 tc = vec2(coord, 0.0);

    //the center tex coord, which gives us hard shadows
    number center = sample(tc, r);

    //return Texel(texture,vTexCoord0).rgba;
    //return vec4(center,center,center,1.);
    return vec4(Texel(texture,vec2(vTexCoord0.x,1-vTexCoord0.y)).rgb,center * smoothstep(1.0, 0.0, r));
}