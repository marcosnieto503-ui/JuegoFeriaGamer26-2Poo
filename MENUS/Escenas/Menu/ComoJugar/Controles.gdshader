shader_type canvas_item;

uniform vec2 centro = vec2(0.5, 0.5);   // posición del foco (0 a 1)
uniform float radio = 0.15;             // tamaño de la zona clara
uniform float suavidad = 0.05;          // qué tan difuso es el borde
uniform float oscuridad = 0.8;          // 0 = nada oscuro, 1 = negro total
uniform float aspecto = 1.7778;         // 1920 / 1080, para que sea círculo y no óvalo

void fragment() {
	vec2 d = UV - centro;
	d.x *= aspecto;
	float dist = length(d);
	float a = smoothstep(radio, radio + suavidad, dist) * oscuridad;
	COLOR = vec4(0.0, 0.0, 0.0, a);
}
