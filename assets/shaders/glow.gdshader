shader_type spatial;
render_mode unshaded;
uniform vec3 color : source_color = vec3(1);
uniform float brightness = 5.0;

void fragment() {
	ALBEDO = color*brightness;
}
