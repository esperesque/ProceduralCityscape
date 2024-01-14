shader_type canvas_item;

// Simple shader used to highlight buttons

uniform float HIGHLIGHT = 0.0;

void fragment() {
	COLOR.rgb += HIGHLIGHT;
}