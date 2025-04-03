shader_type canvas_item;

void fragment() {
	vec4 tex_colour = texture(TEXTURE, UV);
	float grey = tex_colour.r * 0.299 + tex_colour.g * 0.587 + tex_colour.b * 0.114;
	COLOR = vec4(vec3(grey), tex_colour.a);
}

