shader_type spatial;
render_mode unshaded, cull_disabled;
uniform vec3 color = vec3(0.5,1.0,1.0);
uniform float power = 1.0;

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
	ALBEDO = color;
	float _d = length(UV-0.5);
	float _a = atan((UV.y-0.5)/(UV.x-0.5));
	float _n = noise(vec3(_d*10.0-TIME*25.0,_a*15.0,0.0));
	//float _w = sin(_d*25.0+sin(TIME*25.0)-15.0);
	float ring = cos(_d*10.0+0.5*sin(TIME*10.0))*0.5+1.0;
	if(_n+power<ring+1.0){
	//if(0.5<ring){
		discard;
	}
}
