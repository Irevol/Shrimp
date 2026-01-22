shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, filter_linear_mipmap;
uniform float max_ca_offset = 4.0;
uniform float max_blur = 2.0;
uniform float exponent = 3.0;

void fragment() {
    float dist = distance(SCREEN_UV, vec2(0.5));
    float strength = 1.0;
    vec2 ca_shift = SCREEN_PIXEL_SIZE * max_ca_offset * strength;
    float blur_level = strength * max_blur;
    float r = textureLod(screen_texture, SCREEN_UV + ca_shift, blur_level).r;
    float g = textureLod(screen_texture, SCREEN_UV, blur_level).g;
    float b = textureLod(screen_texture, SCREEN_UV - ca_shift, blur_level).b;
    COLOR = vec4(r, g, b, 1.0);
}