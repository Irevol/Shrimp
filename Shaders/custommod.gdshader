shader_type canvas_item;

uniform vec4 target_color : source_color = vec4(1.0);

void fragment() {
    vec4 tex_color = texture(TEXTURE, UV);
    if (tex_color.rgb != vec3(1.0)) {
        tex_color.rgb *= target_color.rgb;
    }
    
    COLOR = tex_color;
}
