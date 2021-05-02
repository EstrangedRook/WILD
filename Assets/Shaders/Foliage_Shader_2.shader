shader_type canvas_item;

uniform sampler2D NOISE_PATTERN;
uniform float intensity = 10.0f;
uniform float speed = 1.0f;
uniform float global_position;
uniform vec2 impulse = vec2(0,0);
varying vec2 noiseValue;

void vertex()
{
	vec2 temp_impulse = impulse * 0.005f;
	float temp_time = (TIME + global_position) * (speed/10.0f);
	vec2 uv = UV;
	uv = vec2((uv.x) + temp_time, uv.y);
	float noise = 0.0f;
	noise = texture(NOISE_PATTERN, uv).x + temp_impulse.x;
	VERTEX.x += (((noise - 0.5) * intensity) * (1.0f-uv.y));
}

void fragment() 
{
	//COLOR = texture(NOISE_PATTERN, UV);
}