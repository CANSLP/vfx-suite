shader_type spatial;
render_mode depth_test_disabled, unshaded,cull_front;
uniform sampler2D depth_texture : hint_depth_texture;
uniform float radius = 1.0;
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
	ALBEDO = clamp(opos,0,1);
}