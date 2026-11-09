shader_type canvas_item;

uniform vec4 outline_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform float outline_width : hint_range(0.0, 10.0) = 1.0;
uniform bool outline_enabled = true;

void fragment() {
	vec4 color = texture(TEXTURE, UV);
	
	if (outline_enabled) {
		vec2 texture_pixel_size = TEXTURE_PIXEL_SIZE * outline_width;
		
		// Si el pixel actual es transparente, revisamos si algún vecino es opaco
		if (color.a < 0.1) {
			float alpha_arriba = texture(TEXTURE, UV + vec2(0.0, -texture_pixel_size.y)).a;
			float alpha_abajo  = texture(TEXTURE, UV + vec2(0.0, texture_pixel_size.y)).a;
			float alpha_izq    = texture(TEXTURE, UV + vec2(-texture_pixel_size.x, 0.0)).a;
			float alpha_der    = texture(TEXTURE, UV + vec2(texture_pixel_size.x, 0.0)).a;
			
			float vecino_opaco = max(max(alpha_arriba, alpha_abajo), max(alpha_izq, alpha_der));
			
			if (vecino_opaco > 0.1) {
				color = outline_color;
				color.a = vecino_opaco;
			}
		}
	}
	
	COLOR = color;
}