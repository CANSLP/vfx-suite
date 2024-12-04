shader_type spatial;
render_mode unshaded;
uniform float scale = 0.5;
uniform vec3 color;

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

void vertex() {
	float t = COLOR.x;
	//float curve = 1.0-pow(2.0*pow(1.0-(t/2.0),10.0)-1.0,2.0);
	//float curve = pow(t,0.125)-t;
	float curve = 4.0*(sqrt(t)-t);
	float size = scale*curve*2.0;
	mat4 modified_model_view = VIEW_MATRIX * mat4(
        INV_VIEW_MATRIX[0]*size,
        INV_VIEW_MATRIX[1]*size,
        INV_VIEW_MATRIX[2]*size,
        MODEL_MATRIX[3]
    );
    MODELVIEW_MATRIX = modified_model_view;
}

void fragment() {
	float t = COLOR.x;
	float curve = 0.5+4.0*pow(t-0.5,3.0);
	vec2 ruv = UV-vec2(0.5,0.5);
	float d = sqrt(ruv.x*ruv.x+ruv.y*ruv.y);
	//if(d>0.5){
	//	discard;
	//}

	vec3 f_camvec = transform(INV_VIEW_MATRIX,VERTEX);
	vec3 f_pos = CAMERA_POSITION_WORLD+f_camvec;
	float n = noise(f_pos*5.0)*0.5;

	if((d*4.0)+(n-1.0)+t > 0.0){
		discard;
	}

	//if(d<pow(t,4.0)){
	//	discard;
	//}
	ALBEDO = color*(vec3(1.0)-curve*2.0)*5.0*(1.5-curve);
}
