shader_type spatial;

uniform sampler2D noise;
uniform vec3 base_color = vec3(0.7, 0.7, 0.5);
uniform vec3 dark_color = vec3(0.6, 0.6, 0.42);

void fragment() {
	float r = texture(noise, UV*2.0).x;
	ALBEDO = mix(base_color, dark_color, r);
}