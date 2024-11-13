shader_type spatial;
render_mode cull_disabled, unshaded;
uniform vec3 color;
uniform sampler2D mask;
uniform float brightness = 5.0;
uniform float time = 0.5;

void fragment() {
	vec2 ruv = UV-vec2(0.5,0.5);
	float d = sqrt(ruv.x*ruv.x+ruv.y*ruv.y);
	float m = texture(mask,UV).x;
	ALBEDO = color*(1.0+brightness);
	if(m > pow(1.0-(time*0.5),5.0)-(d*0.1)){
		discard;
	}
}
