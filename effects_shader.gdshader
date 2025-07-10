shader_type canvas_item;

uniform bool flash_enabled = false;
uniform bool transparent_enabled = false;
uniform vec4 flash_color: source_color = vec4(1.0, 1.0, 1.0, 1.0);

void fragment() {
	vec4 texture_color = texture(TEXTURE, UV);
	
	if (flash_enabled) {
		COLOR = vec4(flash_color.rgb, texture_color.a);
	}
	if (transparent_enabled) {
		COLOR = vec4(texture_color.rgb, texture_color.a * 0.5);
	}
	//COLOR = output_color;
}

