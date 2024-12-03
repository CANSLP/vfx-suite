shader_type spatial;
render_mode blend_mix;
uniform float glow = 1.0;
uniform vec3 color = vec3(1);
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_nearest,repeat_disable;
uniform sampler2D depth_texture : hint_depth_texture, filter_nearest,repeat_disable;
vec3 transform(mat4 m,vec3 v){
	vec4 vv = m * vec4(v,0.0);
	return vec3(vv.x,vv.y,vv.z);
}
void fragment() {
	vec3 v = VERTEX-NODE_POSITION_VIEW;
	float r = length(v);
	float edge = 1.0-pow((r-0.5)*3.5,2.0);
	vec3 sc;
	sc = texture(SCREEN_TEXTURE,SCREEN_UV+(NORMAL.xy*0.05)).xyz;
	METALLIC = 1.0;
	ROUGHNESS = 0.0;
	ALBEDO = vec3(0);
	EMISSION = sc*sc*edge*0.25;
	EMISSION += (color+vec3((edge+0.5)))*pow(glow,8.0);
	
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
