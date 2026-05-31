shader_type canvas_item;

uniform vec2 shadow_offset = vec2(5.0, 5.0); // Смещение тени
uniform vec4 shadow_color : source_color = vec4(0.0, 0.0, 0.0, 0.5); // Цвет
uniform float blur_amount : hint_range(0.0, 100.0) = 3.0; // Сила размытия (ТЕПЕРЬ МОЖНО РЕДАКТИРОВАТЬ)

void fragment() {
    vec4 texture_color = texture(TEXTURE, UV);
    vec2 uv_offset = shadow_offset * TEXTURE_PIXEL_SIZE;
    vec2 base_uv = UV - uv_offset;
    
    // Переменная для накопления прозрачности размытой тени
    float shadow_alpha = 0.0;
    float total_weight = 0.0;
    
    // Цикл размытия (пробегаем по соседним пикселям)
    if (blur_amount > 0.0) {
        for (float x = -2.0; x <= 2.0; x += 1.0) {
            for (float y = -2.0; y <= 2.0; y += 1.0) {
                vec2 blur_uv = base_uv + vec2(x, y) * blur_amount * TEXTURE_PIXEL_SIZE;
                // Проверяем, не вышли ли за границы текстуры
                if (blur_uv.x >= 0.0 && blur_uv.x <= 1.0 && blur_uv.y >= 0.0 && blur_uv.y <= 1.0) {
                    shadow_alpha += texture(TEXTURE, blur_uv).a;
                }
                total_weight += 1.0;
            }
        }
        shadow_alpha /= total_weight; // Усредняем результат
    } else {
        shadow_alpha = texture(TEXTURE, base_uv).a;
    }
    
    vec4 final_shadow = vec4(shadow_color.rgb, shadow_alpha * shadow_color.a);
    COLOR = mix(final_shadow, texture_color, texture_color.a);
}
