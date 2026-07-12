shader_type canvas_item;

// Настройки в инспекторе (крутите как в Figma)
uniform float blur_amount : hint_range(0.0, 5.0) = 2.0;    // Сила размытия (Blur)
uniform float shadow_alpha : hint_range(0.0, 1.0) = 0.5;   // Прозрачность тени
uniform vec3 shadow_color : source_color = vec3(0.0);       // Цвет тени (по умолчанию черный)

void fragment() {
    vec4 text_color = texture(TEXTURE, UV);
    
    vec4 blur_color = textureLod(TEXTURE, UV, blur_amount);
    
    blur_color.rgb = shadow_color;
    blur_color.a *= shadow_alpha;
    
    COLOR = mix(blur_color, text_color, text_color.a);
}
