#define PI 3.14

//uniform values
extern Image u_texture; //shadow canvas
extern Image v_texture; //light canvas
extern vec2 resolution;

//alpha threshold for our occlusion map
const number THRESHOLD = 0.75;

vec4 effect( vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords ) {
	float u_distance = 1.0;
	float u_distanceDS = 1.0;
	bool u_collided = false;
	bool collided = false;
	float v_distance = 1.0;
	float v_distanceDS = 1.0;
	bool v_collided = false;

	for (float y=0.0; y<resolution.y; y+=1.0) {
		//rectangular to polar filter
		vec2 norm = vec2(texture_coords.s, y/resolution.y) * 2.0 - 1.0;
		float theta = PI*1.5 + norm.x * PI; 
		float r = (1.0 + norm.y) * 0.5;

		//coord which we will sample from occlude map
		vec2 coord = vec2(-r * sin(theta), (-r * cos(theta)))/2.0 + 0.5;

		//sample the occlusion map
		vec4 u_data = Texel(u_texture, coord);
		vec4 v_data = Texel(v_texture, coord);

		//the current u_distance is how far from the top we've come
		float dst = y/resolution.y;

		//if we've hit an opaque fragment (occluder), then get new u_distance
		//if the new u_distance is below the current, then we'll use that for our ray
		float u_caster = u_data.a;
		float v_caster = v_data.a;
		if (u_caster > THRESHOLD && u_collided == false) {
		    u_distance = dst;
		    u_collided = true;
		} else if (u_caster < THRESHOLD && u_collided == true && collided == false) {
			u_distanceDS = dst;
			collided = true;
		} else if (v_caster > THRESHOLD && collided == true && v_collided == false) {
			v_distance = dst;
			v_collided = true;
		} else if (v_caster < THRESHOLD && v_collided == true) {
			v_distanceDS = dst;
			break;
		    //NOTE: we could probably use "break" or "return" here
		    //NOTE 2: We'll use break
		}
	}
	return vec4(u_distance,u_distanceDS,v_distance,v_distanceDS);
}