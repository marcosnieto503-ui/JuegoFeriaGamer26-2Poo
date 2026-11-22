shader_type canvas_item;

uniform sampler2D screen_tex : hint_screen_texture, filter_linear_mipmap;
// 0 = normal, 1 = protanopia, 2 = deuteranopia, 3 = tritanopia
uniform int modo : hint_range(0, 3) = 0;
uniform float intensidad : hint_range(0.0, 1.0) = 1.0;

// Las filas de cada matriz se escriben como "columnas" del constructor
// para poder usar: color * matriz
const mat3 PROTAN = mat3(
	vec3(0.152286, 1.052583, -0.204868),
	vec3(0.114503, 0.786281, 0.099216),
	vec3(-0.003882, -0.048116, 1.051998)
);
const mat3 DEUTAN = mat3(
	vec3(0.367322, 0.860646, -0.227968),
	vec3(0.280085, 0.672501, 0.047413),
	vec3(-0.011820, 0.042940, 0.968881)
);
const mat3 TRITAN = mat3(
	vec3(1.255528, -0.076749, -0.178779),
	vec3(-0.078411, 0.930809, 0.147602),
	vec3(0.004733, 0.691367, 0.303900)
);

void fragment() {
	vec3 original = texture(screen_tex, SCREEN_UV).rgb;
	vec3 resultado = original;

	if (modo == 1) resultado = original * PROTAN;
	else if (modo == 2) resultado = original * DEUTAN;
	else if (modo == 3) resultado = original * TRITAN;

	COLOR = vec4(mix(original, clamp(resultado, 0.0, 1.0), intensidad), 1.0);
}