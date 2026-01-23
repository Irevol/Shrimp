shader_type canvas_item;

uniform vec4 target_color : source_color = vec4(1.0);

void fragment() {
    vec4 tex_color = texture(TEXTURE, UV);
    if (tex_color.rgba != vec4(1.0)) {
        tex_color.rgba *= target_color.rgba;
    }
    
    COLOR = tex_color;
}
