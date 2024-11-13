shader_type spatial;
render_mode unshaded, cull_disabled;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	float t = COLOR.x;
	if(t<0.01){
		discard;
	}
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
