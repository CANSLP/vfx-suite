shader_type spatial;
render_mode depth_test_disabled, unshaded,cull_front;
uniform sampler2D depth_texture : hint_depth_texture;
uniform sampler2D scene_color : hint_screen_texture;

uniform float power = 1.0;
uniform float radius = 2.0;

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
	float depth = textureLod(depth_texture, SCREEN_UV, 0.0).r;
	vec4 upos = INV_PROJECTION_MATRIX * vec4(SCREEN_UV * 2.0 - 1.0, depth, 1.0);
	vec3 pixel_position = upos.xyz / upos.w;

	vec3 wpos = CAMERA_POSITION_WORLD+transform(INV_VIEW_MATRIX,pixel_position);
	vec3 opos = wpos-NODE_POSITION_WORLD;

	float back = VERTEX.z;
	float middle = NODE_POSITION_VIEW.z;
	float front = 2.0*middle-back;

	if (pixel_position.z < back) { //cull pixels further than back
    	discard;
	}
	if(pixel_position.z > front){ //cull pixels nearer than front
		//discard;
	}
	if(length(opos)>radius){
		discard;
	}

	opos /= power;

	float _d = length(opos);
	float _n = noise(10.0*(opos/_d));
	vec4 c = texture(scene_color,SCREEN_UV);
	float sat = 1.5;
	if(c.r > sat || c.g > sat || c.g > sat){
		discard;
	}
	ALBEDO = c.xyz*clamp(pow(_d*0.5,2.0),0,1);
	if(_d>2.0-_n){
		discard;
	}

	//ALBEDO = pixel_position;

}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
