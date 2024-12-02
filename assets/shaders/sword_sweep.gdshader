shader_type spatial;
render_mode unshaded, cull_disabled;
uniform sampler2D mask;
uniform float power = 0.5;
uniform vec3 color;
uniform float brightness = 5.0;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	float m = texture(mask,UV).x;
	if(m < 1.1-power){
		discard;
	}
	float c = (m-(1.1-power));
	c *= c;
	ALBEDO = (color+vec3(c))*brightness;
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
