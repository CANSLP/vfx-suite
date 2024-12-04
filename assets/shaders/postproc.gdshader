shader_type canvas_item;
uniform sampler2D screen : hint_screen_texture,filter_nearest,repeat_disable;
uniform float pixel_size = 4.0;
void fragment() {
	vec2 res = 1.0/SCREEN_PIXEL_SIZE/pixel_size;
	vec2 _uv = round(UV*res)/res;
	vec3 color = texture(screen,_uv).xyz;
	COLOR.xyz = round(color*16.0)/16.0;
}
