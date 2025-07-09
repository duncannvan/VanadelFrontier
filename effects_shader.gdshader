shader_type canvas_item;

uniform bool flash_enabled = false;
uniform bool transparent_enabled = false;
uniform vec4 flash_color: source_color = vec4(1.0, 1.0, 1.0, 1.0);

void fragment() {
	vec4 texture_color = texture(TEXTURE, UV);
	vec4 output_color = texture_color;
	if (flash_enabled) {
		output_color = vec4(flash_color.rgb, texture_color.a);
	}
	if (transparent_enabled) {
		output_color = vec4(output_color.rgb, output_color.a * 0.5);
	}
	COLOR = output_color;
}

