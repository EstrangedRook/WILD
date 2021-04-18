shader_type canvas_item;

uniform sampler2D NOISE_PATTERN;
uniform float intensity = 10.0f;
uniform float speed = 1.0f;
uniform float global_position;
varying vec2 noiseValue;

void vertex()
{
	float temp_time = (TIME + global_position) * (speed/10.0f);
	vec2 uv = vec2((UV.x + global_position) + temp_time, UV.y);
	float noise = texture(NOISE_PATTERN, uv).x;	
	VERTEX.x += ((noise - 0.5) * intensity) * (1.0f-UV.y);
}