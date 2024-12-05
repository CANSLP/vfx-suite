shader_type spatial;
uniform vec3 color : source_color;
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
void vertex() {
	vec3 wpos = VERTEX + NODE_POSITION_WORLD;
	vec3 n = vec3(noise(0.25*wpos+vec3(0.0,TIME,0.0)),noise(0.25*wpos+vec3(PI,TIME,0.0)),noise(0.25*wpos+vec3(0.0,TIME,PI)));
	VERTEX += (n-0.5)*0.1;
}

void fragment() {
	ALBEDO = color;
	ROUGHNESS = 0.0;round(noise(VERTEX*vec3(1.0,1.0,0.0))*4.0)/4.0;
	SPECULAR = 0.0;
	NORMAL = transform(VIEW_MATRIX,vec3(0,1,0));
}

void light()
{
	vec3 lightColor = LIGHT_COLOR / PI;
	DIFFUSE_LIGHT += (clamp(dot(NORMAL, LIGHT), 0.0, 1.0) * ATTENUATION * (1.0-0.5*ROUGHNESS) * lightColor);
}
