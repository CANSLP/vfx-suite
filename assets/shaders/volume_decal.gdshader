shader_type spatial;
render_mode depth_test_disabled, unshaded,cull_front;
uniform sampler2D depth_tex : hint_depth_texture;

vec3 transform(mat4 m,vec3 v){
	vec4 vv = m * vec4(v,0.0);
	return vec3(vv.x,vv.y,vv.z);
}

void fragment() {
	float s_z = texture(depth_tex,SCREEN_UV).x;
	
	vec3 f_camvec = transform(INV_VIEW_MATRIX,VERTEX);
	vec3 f_pos = CAMERA_POSITION_WORLD+f_camvec;
	
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
