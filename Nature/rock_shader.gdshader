shader_type canvas_item;

const float shake_strength = 1.0;
const float shake_speed = 15.0;

uniform bool shake = false;

void vertex() {
	vec2 output = vec2(0.0);

	if (shake && VERTEX.y < 0.0) {
		//output.x = sin(TIME * shake_speed) * shake_strength;
		output.y = sin(TIME * shake_speed) * shake_strength;
	}

	VERTEX.xy += output;
}
