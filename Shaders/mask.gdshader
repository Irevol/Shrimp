shader_type canvas_item;

uniform sampler2D mask_texture;
uniform vec2 mask_texture_size;   // in pixels
uniform vec2 viewport_size;       // in pixels

void fragment() {
    vec4 content = texture(TEXTURE, UV);

    // Convert UV → pixel space of viewport
    vec2 pixel_pos = UV * viewport_size;

    // Convert pixel space → mask UV (no stretching)
    vec2 mask_uv = pixel_pos / mask_texture_size;

    // Outside mask bounds = fully masked
    if (mask_uv.x < 0.0 || mask_uv.y < 0.0 ||
        mask_uv.x > 1.0 || mask_uv.y > 1.0) {
        discard;
    }

    float mask_value = dot(texture(mask_texture, mask_uv).rgb, vec3(0.333));

    COLOR = vec4(content.rgb, content.a * mask_value);
}