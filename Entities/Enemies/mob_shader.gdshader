shader_type canvas_item;

uniform bool flash = false;
uniform bool gray_scale = false;
uniform vec4 flash_color: source_color = vec4(1.0, 1.0, 1.0, 1.0);
void fragment() {
	vec4 original_color = texture(TEXTURE, UV);

	if (flash) {
		COLOR = vec4(flash_color.rgb, original_color.a);
	}
	if (gray_scale && !flash) {
		float grayscale = (original_color.r + original_color.g + original_color.b) / 3.0;
		COLOR.rgb = vec3(grayscale);
	}
}