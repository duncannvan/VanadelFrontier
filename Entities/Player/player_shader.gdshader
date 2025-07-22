shader_type canvas_item;

uniform bool flash = false;
uniform bool transparent = false;
uniform vec4 flash_color: source_color = vec4(1.0, 1.0, 1.0, 1.0);

void fragment() {
	vec4 texture_color = texture(TEXTURE, UV);
	
	if (flash) {
		COLOR = vec4(flash_color.rgb, texture_color.a);
	}
	if (transparent && !flash) {
		COLOR = vec4(texture_color.rgb, texture_color.a * 0.5);
	}
	//COLOR = output_color;
}

