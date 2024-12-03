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
	vec2 _v = v.xy;
	float _r = 1.0-clamp(length(_v),0.0,1.0);
	float edge = clamp(pow((r-0.4)*7.5,2.0),0.0,1.0);
	vec3 sc;
	sc = texture(SCREEN_TEXTURE,SCREEN_UV+(NORMAL.xy*0.05)).xyz;
	METALLIC = 1.0;
	ROUGHNESS = 0.0;
	ALBEDO = vec3(0);
	EMISSION = sc*sc*edge*0.5;
	EMISSION += clamp((color-2.0+5.0*vec3(0.2*edge+_r+pow(glow,2.0)-1.0)),0.0,1.0)*glow;
	//EMISSION = vec3(edge);
	//EMISSION = vec3(_r);
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
