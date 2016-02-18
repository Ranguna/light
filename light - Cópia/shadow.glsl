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

    /* Remove this and add resolution variable if you want blured shadows
    //we multiply the blur amount by our distance from center
    //this leads to more blurriness as the shadow "fades away"
    number blur = (1./resolution.x) * 0.000000001;//smoothstep(0., 1., r); 

    //now we use a simple gaussian blur
    number sum = 0.0;

    sum += sample(vec2(tc.x - 4.0*blur, tc.y), r) * 0.05;
    sum += sample(vec2(tc.x - 3.0*blur, tc.y), r) * 0.09;
    sum += sample(vec2(tc.x - 2.0*blur, tc.y), r) * 0.12;
    sum += sample(vec2(tc.x - 1.0*blur, tc.y), r) * 0.15;

    sum += center * 0.16;

    sum += sample(vec2(tc.x + 1.0*blur, tc.y), r) * 0.15;
    sum += sample(vec2(tc.x + 2.0*blur, tc.y), r) * 0.12;
    sum += sample(vec2(tc.x + 3.0*blur, tc.y), r) * 0.09;
    sum += sample(vec2(tc.x + 4.0*blur, tc.y), r) * 0.05;

    //sum of 1.0 -> in light, 0.0 -> in shadow
    */

    //multiply the summed amount by our distance, which gives us a radial falloff
    //then multiply by vertex (light) color  
    return vColor * vec4(vec3(1.0), center * smoothstep(1.0, 0.0, r));
}