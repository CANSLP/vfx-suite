shader_type spatial;
render_mode depth_test_disabled, unshaded,cull_front;
uniform sampler2D depth_tex : hint_depth_texture;

uniform float power = 1.0;

float mod289_1(float x){return x - floor(x * (1.0 / 289.0)) * 289.0;}
vec4 mod289_4(vec4 x){return x - floor(x * (1.0 / 289.0)) * 289.0;}
vec4 perm(vec4 x){return mod289_4(((x * 34.0) + 1.0) * x);}
float noise(vec3 p){
    vec3 a = floor(p);
    vec3 d = p - a;
    d = d * d * (3.0 - 2.0 * d);

    vec4 b = a.xxyy + vec4(0.0, 1.0, 0.0, 1.0);
    vec4 k1 = perm(b.xyxy);
    vec4 k2 = perm(k1.xyxy + b.zzww);

    vec4 c = k2 + a.zzzz;
    vec4 k3 = perm(c);
    vec4 k4 = perm(c + 1.0);

    vec4 o1 = fract(k3 * (1.0 / 41.0));
    vec4 o2 = fract(k4 * (1.0 / 41.0));

    vec4 o3 = o2 * d.z + o1 * (1.0 - d.z);
    vec2 o4 = o3.yw * d.x + o3.xz * (1.0 - d.x);

    return o4.y * d.y + o4.x * (1.0 - d.y);
}
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
	
	float fz = -((PROJECTION_MATRIX[3][2]/s_z)+PROJECTION_MATRIX[2][2]);
	vec3 screen_pos = vec3(VERTEX.xy,fz);
	//float f_z = clamp(transform(VIEW_MATRIX,f_pos),0.0,1.0).z;
	if(s_z<FRAGCOORD.z){
		discard;
	}
	if(s_z>front_z){
		discard;
	}
	
	
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
	//ALBEDO = vec3(1)*-PROJECTION_MATRIX[3][2] / (VERTEX.z+PROJECTION_MATRIX[2][2]);
	vec3 wfrag = CAMERA_POSITION_WORLD+transform(INV_VIEW_MATRIX,screen_pos);
	vec3 ofrag = wfrag-NODE_POSITION_WORLD;
	//ALBEDO = ofrag;
	float _d = length(ofrag);
	float _n = noise(((0.1*wfrag)+15.0*(ofrag/_d)));
	ALBEDO = vec3(0);
	if(_d>2.0*power-_n){
		discard;
	}
	
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
