shader_type spatial;
render_mode depth_test_disabled, unshaded,cull_front;
uniform sampler2D depth_tex : hint_depth_texture;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	float s_z = texture(depth_tex,SCREEN_UV).x;
	if(s_z<FRAGCOORD.z){
		discard;
	}
	if(s_z > FRAGCOORD.z){
		//discard;
	}
	vec3 screen_pos = vec3(SCREEN_UV,s_z);
	ALBEDO = screen_pos;
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
