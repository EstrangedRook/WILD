shader_type canvas_item;

const float PI = 3.14159265358979323846;

uniform sampler2D NOISE_PATTERN;
uniform float intensity = 10.0f;
uniform float speed = 1.0f;
uniform float global_position;
uniform float impulse = 0.0f;
varying vec2 noiseValue;

varying vec2 vert;

void vertex()
{
	float temp_impulse = impulse * -0.01f;
	float temp_time = (TIME + global_position) * (speed/10.0f);
	vec2 uv = UV;
	uv.x *= TEXTURE_PIXEL_SIZE.x;
	uv.y *= TEXTURE_PIXEL_SIZE.y;
	uv.x = floor(uv.x);
	uv.y = floor(uv.y);
	uv.x /= TEXTURE_PIXEL_SIZE.x;
	uv.y /= TEXTURE_PIXEL_SIZE.y;
	uv = vec2((uv.x) + temp_time, uv.y);
	float noise = 0.0f;
	noise = texture(NOISE_PATTERN, uv).x + temp_impulse;
	vert.x = (((noise - 0.5) * intensity) * (1.0f-uv.y));
	vert.y = -(abs(impulse)*0.01f);
}

void fragment()
{
    vec2 pix = floor(UV/TEXTURE_PIXEL_SIZE) * TEXTURE_PIXEL_SIZE;
    vec2 offset_vec = vert;
    offset_vec *= clamp((1.0-pix.y) - TEXTURE_PIXEL_SIZE.y,0.0,1.0);
    COLOR = texture(TEXTURE, pix + offset_vec);
}
