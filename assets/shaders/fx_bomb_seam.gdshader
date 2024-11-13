shader_type spatial;
render_mode cull_disabled, unshaded;
uniform vec3 color;
uniform sampler2D mask;
uniform float power = 0.5;
uniform float brightness = 0.5;

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
vec3 transform(vec3 i,mat4 m){
	vec4 o = m * vec4(i.x,i.y,i.z,0);
	return vec3(o.x,o.y,o.z);
}
void fragment() {
	vec2 ruv = UV-vec2(0.5,0.5);
	float d = sqrt(ruv.x*ruv.x+ruv.y*ruv.y);
	float a = atan(ruv.y/ruv.x);
	//float m = texture(mask,UV).x;
	//m += 0.25*noise(10.0*vec3(UV.x,UV.y,TIME*0.25));
	d += 2.0;
	float m = noise(10.0*vec3(d*cos(a+TIME),-d*sin(a+TIME),0.0));
	m *= noise(10.0*vec3(d*cos(a-TIME),-d*sin(a-TIME),0.5));
	m = clamp(texture(mask,UV).x - m*0.5,0.0,1.0);
	if(m < 1.0-power){
		discard;
	}
	ALBEDO = color*(1.0+brightness);
}