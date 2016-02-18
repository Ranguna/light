#define PI 3.14

//uniform values
extern Image u_texture;
extern vec2 resolution;

//alpha threshold for our occlusion map
const number THRESHOLD = 0.75;

vec4 effect( vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords ) {
	float distance = 1.0;
	float distanceDS = 1.0;
	bool collided = false;

	for (float y=0.0; y<resolution.y; y+=1.0) {
		//rectangular to polar filter
		vec2 norm = vec2(texture_coords.s, y/resolution.y) * 2.0 - 1.0;
		float theta = PI*1.5 + norm.x * PI; 
		float r = (1.0 + norm.y) * 0.5;

		//coord which we will sample from occlude map
		vec2 coord = vec2(-r * sin(theta), (-r * cos(theta)))/2.0 + 0.5;

		//sample the occlusion map
		vec4 data = Texel(u_texture, coord);

		//the current distance is how far from the top we've come
		float dst = y/resolution.y;

		//if we've hit an opaque fragment (occluder), then get new distance
		//if the new distance is below the current, then we'll use that for our ray
		float caster = data.a;
		if (caster > THRESHOLD && collided == false) {
		    distance = dst;
		    collided = true;
		    //NOTE: we could probably use "break" or "return" here
		} else if (caster < THRESHOLD && collided == true) {
			distanceDS = dst;
			break;
		}
	}
	return vec4(vec3(distance,distanceDS,0.0), 1.0);
}