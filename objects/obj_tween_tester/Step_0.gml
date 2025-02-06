/// @description Inserir descrição aqui
// Você pode escrever seu código neste editor


if (keyboard_check_pressed(ord("A")))
{
	mini_tween(id, 2)
		.set_ease(EASING_CURVES.ELASTIC_IN_OUT)
		.tween_position(x + 300, y)
		.set_on_complete(function() 
		{
			mini_tween(id, 2)
				.set_ease(EASING_CURVES.ELASTIC_IN_OUT)
				.tween_position(x, y + 300)
				.set_on_complete(function() 
				{
					mini_tween(id, 2)
						.set_ease(EASING_CURVES.ELASTIC_IN_OUT)
						.tween_position(x - 300, y)
						.set_on_complete(function() 
					{
						mini_tween(id, 2)
							.set_ease(EASING_CURVES.ELASTIC_IN_OUT)
							.tween_position(x, y - 300)
							
					});
				});
		});
		
		mini_tween(id, 2)
			.set_ease(EASING_CURVES.ELASTIC_IN_OUT)
			.tween_rotation(90)
			.set_on_complete(function() 
		{
			mini_tween(id, 2)
				.set_ease(EASING_CURVES.ELASTIC_IN_OUT)
				.tween_rotation(180)
				.set_on_complete(function() 
				{
					mini_tween(id, 2)
						.set_ease(EASING_CURVES.ELASTIC_IN_OUT)
						.tween_rotation(270)
						.set_on_complete(function() 
					{
						mini_tween(id, 2)
							.set_ease(EASING_CURVES.ELASTIC_IN_OUT)
							.tween_rotation(360)
							
					});
				});
		});
}
