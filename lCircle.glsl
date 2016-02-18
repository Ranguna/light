#define PI 3.14159

vec4 effect( vec4 vColor, Image texture, vec2 vTexCoord0, vec2 screen_coords ) {
	//rectangular to polar
	vec2 norm = vTexCoord0.st * 2.0 - 1.0;
	number theta = atan(norm.y, norm.x);
	number r = length(norm); 
	number coord = (theta + PI) / (2.0*PI);

	return vec4(vColor.rgb, smoothstep(1.0, 0.0, r));
}
