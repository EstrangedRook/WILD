shader_type canvas_item;

uniform vec2 sin_speed = vec2(0.5,0.5);
uniform vec2 sin_scale = vec2(0.4,0.25);
uniform vec2 sin_repeat = vec2(10,10);
uniform bool scale_over_height;

const float PI = 3.14159265358979323846;
uniform vec4 outline_color : hint_color;
uniform float width = 1;

void fragment(){
    vec2 pix = floor(UV/TEXTURE_PIXEL_SIZE) * TEXTURE_PIXEL_SIZE;
    vec2 sin_vec = sin((pix*sin_repeat*2.0*PI) + (TIME*2.0*PI*sin_speed)) * (sin_scale * TEXTURE_PIXEL_SIZE);
    if(scale_over_height){
        sin_vec *= clamp((1.0-pix.y) - TEXTURE_PIXEL_SIZE.y,0.0,1.0);
    }
    sin_vec = vec2(sin_vec.y,sin_vec.x);
    //COLOR = texture(TEXTURE, pix + sin_vec);
	
	vec2 size = TEXTURE_PIXEL_SIZE;
	vec4 sprite_color = texture(TEXTURE, pix + sin_vec);
	float alpha = -8.0 * sprite_color.a;
	alpha += texture(TEXTURE, pix + sin_vec + vec2(size.x, 0.0)).a;
	alpha += texture(TEXTURE, pix + sin_vec + vec2(-size.x, 0.0)).a;
	alpha += texture(TEXTURE, pix + sin_vec + vec2(0.0, size.y)).a;
	alpha += texture(TEXTURE, pix + sin_vec + vec2(0.0, -size.y)).a;
	alpha += texture(TEXTURE, pix + sin_vec + vec2(size.x, size.y)).a;
	alpha += texture(TEXTURE, pix + sin_vec + vec2(-size.x, size.y)).a;
	alpha += texture(TEXTURE, pix + sin_vec + vec2(-size.x, -size.y)).a;
	alpha += texture(TEXTURE, pix + sin_vec + vec2(size.x, -size.y)).a;	
	vec4 final_color = mix(sprite_color, outline_color, clamp(alpha, 0.0, 1.0));
	COLOR = vec4(final_color.rgb, clamp(abs(alpha) + sprite_color.a, 0.0, 1.0));
}