shader_type spatial;
render_mode unshaded;
uniform float scale = 0.5;
uniform vec3 color;

void vertex() {
	float t = COLOR.x;
	float curve = 1.0-pow(2.0*pow(1.0-(t/2.0),10.0)-1.0,2.0);
	float size = scale*curve;
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
	if(d>0.5){
		discard;
	}
	ALBEDO = color*(vec3(1.0)-curve*2.0)*5.0*(1.0-curve);
}
