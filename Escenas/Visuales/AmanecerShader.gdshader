shader_type canvas_item;

uniform sampler2D screen_tex : hint_screen_texture, filter_linear_mipmap;

uniform vec4 color_top : source_color = vec4(0.25, 0.15, 0.40, 1.0);
uniform vec4 color_mid : source_color = vec4(0.95, 0.35, 0.25, 1.0);
uniform vec4 color_horizon : source_color = vec4(1.0, 0.75, 0.30, 1.0);

// Rango de matiz del cielo (0.5 = cian, 0.66 = azul puro)
uniform float hue_min : hint_range(0.0, 1.0) = 0.5;
uniform float hue_max : hint_range(0.0, 1.0) = 0.72;
// Saturación mínima: bájala para captar azules muy claros
uniform float sat_min : hint_range(0.0, 0.5) = 0.04;
uniform float softness : hint_range(0.01, 0.3) = 0.08;
uniform float intensity : hint_range(0.0, 1.0) = 1.0;

vec3 rgb2hsv(vec3 c) {
    vec4 K = vec4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
    vec4 p = mix(vec4(c.bg, K.wz), vec4(c.gb, K.xy), step(c.b, c.g));
    vec4 q = mix(vec4(p.xyw, c.r), vec4(c.r, p.yzx), step(p.x, c.r));
    float d = q.x - min(q.w, q.y);
    float e = 1.0e-10;
    return vec3(abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
}

void fragment() {
    vec4 tex = texture(screen_tex, SCREEN_UV);
    vec3 hsv = rgb2hsv(tex.rgb);

    // Máscara por matiz (con bordes suaves) y saturación baja
    float hue_mask = smoothstep(hue_min - softness, hue_min, hsv.x)
                   * (1.0 - smoothstep(hue_max, hue_max + softness, hsv.x));
    float sat_mask = smoothstep(sat_min, sat_min + softness, hsv.y);
    float mask = hue_mask * sat_mask * intensity;

    vec3 grad = UV.y < 0.5
        ? mix(color_top.rgb, color_mid.rgb, UV.y * 2.0)
        : mix(color_mid.rgb, color_horizon.rgb, (UV.y - 0.5) * 2.0);

    // Los azules claros son muy luminosos: normalizamos para no quemar el color
    float lum = dot(tex.rgb, vec3(0.299, 0.587, 0.114));
    vec3 sunset = grad * (0.6 + 0.5 * lum);

    COLOR = vec4(mix(tex.rgb, sunset, mask), 1.0);
}