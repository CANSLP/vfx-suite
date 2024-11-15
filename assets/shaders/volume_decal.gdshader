shader_type spatial;
render_mode depth_test_disabled, unshaded,cull_front;
uniform sampler2D depth_tex : hint_depth_texture;

vec3 transform(mat4 m,vec3 v){
	vec4 vv = m * vec4(v,0.0);
	return vec3(vv.x,vv.y,vv.z);
}

void fragment() {
	float s_z = texture(depth_tex,SCREEN_UV).x;
	//s_z *= s_z;
	//s_z = sqrt(s_z);
	
	vec3 f_camvec = transform(INV_VIEW_MATRIX,VERTEX);
	vec3 f_pos = CAMERA_POSITION_WORLD+f_camvec;
	vec3 o_pos = f_pos-NODE_POSITION_WORLD;
	float back_z = -PROJECTION_MATRIX[3][2] / (VERTEX.z+PROJECTION_MATRIX[2][2]);
	float center = -PROJECTION_MATRIX[3][2] / (NODE_POSITION_VIEW.z+PROJECTION_MATRIX[2][2]);
	float front_z = center-(back_z-center);
	//float f_z = clamp(transform(VIEW_MATRIX,f_pos),0.0,1.0).z;
	if(s_z<FRAGCOORD.z){
		discard;
	}
	if(s_z>front_z){
		//discard;
	}

	vec3 screen_pos = vec3(VERTEX.xy,s_z);
	//ALBEDO = clamp(o_pos*0.1,0.0,1.0);
	//ALBEDO = vec3(5,0,0)*s_z;
	
	//if(SCREEN_UV.y>0.5){
	if(s_z<front_z){
		//ALBEDO = vec3(0,0,5)*front_z;
		//ALBEDO = vec3(1.0)*center;
		//ALBEDO = vec3(1.0)*back_z;
	}
	//ALBEDO = clamp(o_pos*0.1,0.0,1.0);
	//ALBEDO = vec3(1)*s_z;
	ALBEDO = CAMERA_POSITION_WORLD+transform(INV_VIEW_MATRIX,vec3(VERTEX.xy,s_z));
	//ALBEDO = CAMERA_POSITION_WORLD+transform(INV_VIEW_MATRIX,VERTEX);
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
