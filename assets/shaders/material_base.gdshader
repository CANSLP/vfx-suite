shader_type spatial;

uniform vec3 albedo : source_color = vec3(1);
uniform sampler2D albedo_tex : source_color;

uniform float roughness = 1.0;
uniform float metallic = 1.0;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	ALBEDO = texture(albedo_tex,UV).xyz*albedo;
	ROUGHNESS = roughness;
	METALLIC = metallic;
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
