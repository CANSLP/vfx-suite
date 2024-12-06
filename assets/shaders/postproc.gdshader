shader_type canvas_item;
uniform sampler2D screen : hint_screen_texture,filter_nearest,repeat_disable;
uniform float pixel_size = 4.0;
uniform float haunt = 1.0;
uniform sampler2D distort : repeat_enable;
float random (vec2 uv) {
    return fract(sin(dot(uv.xy,
        vec2(12.9898,78.233))) * 43758.5453123);
}
void fragment() {
	//vec2 res = 1.0/SCREEN_PIXEL_SIZE/pixel_size;
	vec2 res = vec2(1920,1080)/pixel_size;
	vec2 _uv = round(UV*res)/res;
	vec2 _d = vec2(0.0);
	if(haunt > 0.5){
		_d = (texture(distort,_uv+vec2(TIME*0.25)).xy*texture(distort,1.5*_uv+vec2(-TIME*0.25)).xy)+vec2(-0.25);
	}
	
	if(haunt > 0.0){
		if(random(vec2(TIME,_uv.y))+0.0075<0.05*haunt*haunt){
			_uv.x += 1.0/res.x*(ceil((haunt*5.0)*random(vec2(_uv.y,TIME)))-(haunt*3.0));
		}
	}
	float dith = 0.5;
	if(mod((_uv.x*res.x)+(_uv.y*res.y),2.0)<1.0){
		dith = -dith;
	}
	
	vec3 color = texture(screen,_uv+_d*(haunt-0.5)*0.25).xyz;
	COLOR.xyz = round((color*16.0)+(dith/16.0))/16.0;
	
	
	if(haunt > 0.0){
		float r = length(_uv-0.5);
		//vec3 inv = vec3(1.0-COLOR.x,1.0-COLOR.y,1.0-COLOR.z);
		vec3 inv = vec3(COLOR.x+pow(random(_uv+TIME*2.0),2.0),COLOR.y+pow(random(_uv+TIME*3.0),2.0),COLOR.z+pow(random(_uv+TIME*4.0),2.0));
		COLOR.xyz = mix(COLOR.xyz,inv,haunt*3.0*vec3(random(_uv+TIME))*r*r*r*r);
	}
}
