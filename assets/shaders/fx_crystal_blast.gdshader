shader_type spatial;
render_mode unshaded;//, cull_disabled;
uniform vec3 color;
uniform float power;

float remap(float value,float low1,float high1,float low2,float high2){
	return low2 + (value - low1) * (high2 - low2) / (high1 - low1);
}

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

void fragment() {
	float n = noise(vec3(UV*vec2(50.0,15.0)+vec2(0.0,-25.0*TIME),0.0));
	if(n < power*power){
		discard;
	}
	ALBEDO = color+vec3(remap(clamp(power*1.1,0.0,1.0),0.0,1.0,1.0,-1.0));
	ALBEDO *= (2.0-power);
}
