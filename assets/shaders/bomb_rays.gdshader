shader_type spatial;
render_mode unshaded, cull_disabled;
uniform vec3 color;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	float t = COLOR.x;
	float y = (t+UV.y)-1.0;
	float x = (1.0-t)-abs(UV.x-0.5);
	float v = min(x-y,y);
	if(v<0.0){
		discard;
	}
	float brightness = (1.0+t)*1.5;
	ALBEDO = color*brightness;
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
