shader_type canvas_item;
render_mode blend_mix;

uniform sampler2D clut_texture : hint_default_transparent, filter_nearest;

void fragment() {
	vec2 uv = COLOR.rg;
	uv *= vec2(255, 255);
	uv /= vec2(textureSize(clut_texture, 0));
	COLOR.rgb = texture(clut_texture, uv).rgb;
}
