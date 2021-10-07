shader_type canvas_item;

uniform float pos: hint_range(0, 1.5);

void fragment()
{
	vec4 c = texture(TEXTURE, UV);
	float angle = UV.y / 7.0;
	float px = pos - angle;
	
	if (UV.x > px)
	{
		if (UV.x < 1.0 - angle)
		{
			vec4 px_color = texture(TEXTURE, vec2(px, UV.y));
			float m = 1.0 - ((UV.x - px) / 0.25);
			COLOR = vec4(px_color.rgb, px_color.a * clamp(m, 0.5, 1.0));
		}
		else
		{
			COLOR = vec4(0.0);
		}
	}
	else
	{
		COLOR = c;
	}
}