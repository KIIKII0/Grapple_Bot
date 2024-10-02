shader_type spatial;


uniform sampler2D water_noise;
uniform float uv_scale: hint_range(0.0, 200.0, 0.25) = 100;
uniform float normal: hint_range(0.0, 10.0, 0.25) = 0.5;
uniform float roughnes: hint_range(0.0, 10.0, 0.25) = 0.2;
uniform vec3 water_color: source_color;
uniform float time_scale: hint_range(0.0, 10.0, 0.25) = 1.0;
uniform sampler2D screen_texture: hint_screen_texture, repeat_disable;
uniform sampler2D sun_highlights;


vec3 soft_light(vec3 base, vec3 blend){
	vec3 limit = step(0.5, blend);
	return mix(2.0 * base * blend * base * base * (1.0 - 2.0 * blend),
	sqrt(base) * (2.0 * blend - 1.0) + (2.0 * base) * (1.0 - blend), limit);
}
void fragment() {
	vec2 _uv = UV * uv_scale;
	vec2 _suv = SCREEN_UV;
	
	_uv.x += sin(TIME * time_scale + (_suv.x + _suv.y) * 25.0) * 0.01;
	_uv.y += cos(TIME * time_scale + (_suv.x - _suv.y) * 25.0) * 0.01;
	
	_suv.x += sin(TIME * time_scale + (_suv.x + _suv.y) * 25.0) * 0.01;
	_suv.y += cos(TIME * time_scale + (_suv.x - _suv.y) * 25.0) * 0.01;
	
	ALBEDO = texture(screen_texture, SCREEN_UV).rgb;
	NORMAL_MAP = texture(water_noise,_uv).rgb;
	NORMAL *= normal;
	ROUGHNESS = roughnes;
	ALPHA = 0.9;
	// Called for every pixel the material is visible on.
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
