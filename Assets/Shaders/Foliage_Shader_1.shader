shader_type canvas_item;

uniform sampler2D NOISE_PATTERN;
uniform float intensity = 10.0f;
uniform float speed = 1.0f;
uniform float global_position;
uniform float impulse = 0.0f;
varying vec2 noiseValue;

void vertex()
{
	float temp_impulse = impulse * 0.01f;
	float temp_time = (TIME + global_position) * (speed/10.0f);
	vec2 uv = UV;
	uv = vec2((uv.x) + temp_time, uv.y);
	float noise = 0.0f;
	noise = texture(NOISE_PATTERN, uv).x + temp_impulse;
	VERTEX.x += (((noise - 0.5) * intensity) * (1.0f-uv.y));
	VERTEX.y += (abs(impulse)*0.03f) * (1.0f-uv.y);
}