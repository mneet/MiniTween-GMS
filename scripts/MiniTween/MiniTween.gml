/*
	MiniTween is a system used to create simple visual animations!
	
	-- How its useful? --
	When you need a simple and quick way to create basic animations,
	a Tweening system can handle it without needing to create your
	own animations functions, variables and everything else
	
	-- Example --
	My character was hit! I want it to scale down using an easing curve
	and then scale up again with a bounce! 
	You can do all that with Tweens using only a few lines! 
	
	-- Set Up -- 
	You just need to instantiate the manager obj_mini_tweener and all done!
	Make sure it stays always active!
	
	-- Heads Up --
	You only need to create the tween one time! Multiple tweens doing the same
	thing will just waste performance.
	
	Be careful when creating tweens for the same attribute at the same time, 
	only the last tween processed will be applied to the object/transform
	
	-- Credits -- 
	
	MiniTween and MiniTransform is a system created by M.Neet,
	you can check my stuff at https://github.com/mneet/ or https://lioneet.itch.io/ ;D
	
	Version 0.1.0.0
*/

#region MINI TWEEN SYSTEM

global.tween_manager = {};
with(global.tween_manager)
{
	manager_object = noone;				
}

enum TWEEN_TYPE
{
	MINI_TRANSFORM,
	OBJECT
}

#macro TWEEN_ATTRIBUTE_X "x"
#macro TWEEN_ATTRIBUTE_Y "y"
#macro TWEEN_ATTRIBUTE_XSCALE "image_xscale"
#macro TWEEN_ATTRIBUTE_YSCALE "image_yscale"
#macro TWEEN_ATTRIBUTE_ALPHA "image_alpha"
#macro TWEEN_ATTRIBUTE_ROTATION "image_angle"
#macro TWEEN_ATTRIBUTE_SUB_IMG "image_index"

#endregion

#region STRUCTS

function MiniTween(_tween_target, _timer = 0) constructor
{
	// Curve
	tween_channel = noone;
	tween_curve = EASING_CURVES.LINEAR;
	
	// Timers
	tween_timer_total = _timer;
	tween_timer = 0;
	
	tween_delay_total = 0;
	tween_delay_timer = 0;
	
	// Tween Control
	tween_attribute = "";
	tween_target = _tween_target;
	tween_is_struct = false;
	tween_target_weak_ref = noone;
	// Function
	on_complete_func = noone;
	on_complete_func_param = tween_target;
	
	// Attributes
	tween_to_value = 0;
	tween_start_value = 0;
	tween_diff_value = 0;
	
	tween_first_start_value = "";
	tween_first_to_value = "";
	
	custom_attribute_name = "";
		
	// Tweening Control
	tween_progress = 0;
	tween_delayed = false;		
	tween_basic = true;	
	tween_started = false;
	destroy_flag = false;
	tween_reverse = false;
		
	tween_with_curve = false;
	tween_vec2 = false;
	tween_vec2_values = new Vector2(false, false);
	
	// LOOPING
	tween_loops = 1;
	tween_ping_pong = false;
	tween_ping_pong_flag = true;
		
	#region TWEEN BUILDER
	
	///@function		set_on_complete(_function)
	///@description		Set a function to run at the end of the Tween
	static set_on_complete = function(_function)
	{
		on_complete_func = _function;
		return self;
	}
	
	///@function		set_delay(_delay)
	///@description		Set a delay to start the Tween
	static set_delay = function(_delay)
	{
		tween_delay_total = _delay;
		return self;
	}
	
	///@function		set_ease(_easing_curve)
	///@description		Set a easing curve to be used on the tweening process
	static set_ease = function(_easing_curve)
	{
		tween_curve = _easing_curve;
		return self;
	}
	
	///@function		tween_position(_position)
	///@description		Tween a node to an given position	
	static tween_position = function(_x, _y)
	{
		tween_attribute = new Vector2(TWEEN_ATTRIBUTE_X, TWEEN_ATTRIBUTE_Y);
		tween_to_value = new Vector2(_x ,_y);
		
		tween_vec2 = true;
		tween_vec2_values.x = _x != noone;
		tween_vec2_values.y = _y != noone;
		
		return self;
	}
	
	///@function		tween_scale(_x, _y)
	///@description		Tween a node to an given scale	
	static tween_scale = function(_x, _y)
	{
		tween_attribute = new Vector2(TWEEN_ATTRIBUTE_XSCALE, TWEEN_ATTRIBUTE_YSCALE);
		tween_to_value = new Vector2(_x, _y);
		
		tween_vec2 = true;
		tween_vec2_values.x = _x != 0;
		tween_vec2_values.y = _y != 0;

		return self;
	}
	
	///@function		tween_alpha(_alpha)
	///@description		Tween a node to an given alpha	
	static tween_alpha = function(_alpha)
	{
		tween_attribute = TWEEN_ATTRIBUTE_ALPHA;
		tween_to_value = _alpha;
		
		return self;
	}
	
	///@function		tween_rotation(_rotation)
	///@description		Tween a node to an given rotation	
	static tween_rotation = function(_rotation)
	{
		tween_attribute = TWEEN_ATTRIBUTE_ROTATION;
		tween_to_value = _rotation;
		
		return self;
	}
	
	///@function		tween_subimg(_)
	///@description		Tween a node to an given rotation	
	static tween_subimg = function(_reverse = false)
	{
		tween_attribute = TWEEN_ATTRIBUTE_SUB_IMG;
		tween_basic = false;
		
		tween_reverse = true;
		
		return self;
	}
	
	///@function		tween_custom(_)
	///@description		Tween a custom variable on a struct or instance	
	static tween_custom = function(_variable_name, _value)
	{
		tween_attribute = _variable_name;
		tween_to_value = _value;
		return self;
	}
	
	///@function		tween_custom_curve(_)
	///@description		Tween using a custom animation curve
	static tween_custom_curve = function(_animcurve, _channel)
	{
		tween_channel = animcurve_get_channel(_animcurve, _channel);
		tween_with_curve = true;
		return self;
	}
	
	///@function				tween_loop(_)
	///@description				Amount of times the tween will repeat
	///@param {real} _amount	Integer amount of times. -1 Will loop untill the tween is stopped or the target is destroyed
	static tween_loop = function(_amount)
	{
		tween_loops = _amount;	
		return self;
	}
	
	///@function		tween_stop(_)
	///@description		Force stop the tween, it doesnt return the target attribute to the original value
	static tween_stop = function()
	{
		destroy_flag = true;
		return self;
	}
	
	#endregion
	
	#region INTERNAL SYSTEM
	
	#region TWEEN CONFIGURATION
	
	///@function		__execute_on_complete(_)
	///@description		Execute on complete function
	__execute_on_complete = function()
	{
		if (on_complete_func != noone)
		{
			on_complete_func(on_complete_func_param, self);
		}
	}
	
	static __tween_get_attribute = function(_attribute)
	{
		var _value = 0;
		if (tween_is_struct)
		{
			if (is_instanceof(tween_target, MiniTransform))
			{
				_value = tween_target.transform_convert_and_get_att(_attribute);
			}
			else
			{
				_value = variable_struct_get(tween_target, _attribute);
			}
		}
		else
		{
			_value = variable_instance_get(tween_target, _attribute);
		}
		return _value;
	}	
	
	static __tween_set_attribute = function(_attribute, _value)
	{
		if (tween_is_struct)
		{
			if (is_instanceof(tween_target, MiniTransform))
			{
				 tween_target.transform_convert_and_set_att(_attribute, _value);
			}
			else
			{
				variable_struct_set(tween_target, _attribute, _value);
			}
		}
		else
		{
			variable_instance_set(tween_target, _attribute, _value);
		}
	}
		
	///@function		__tween_calculate_diff(_)
	///@description		Calculate values when start the tweening process
	static __tween_calculate_diff = function()
	{
		if (tween_vec2)
		{
			tween_start_value = new Vector2(__tween_get_attribute(tween_attribute.x), __tween_get_attribute(tween_attribute.y));		
			tween_diff_value = new Vector2(-(tween_start_value.x - tween_to_value.x), -(tween_start_value.y - tween_to_value.y));
		}
		else
		{
			tween_start_value =  __tween_get_attribute(tween_attribute);
			tween_diff_value = -(tween_start_value - tween_to_value);
		}
		
		if (is_string(tween_first_start_value))
		{
			tween_first_start_value = variable_clone(tween_start_value);
			tween_first_to_value = variable_clone(tween_to_value);
		}
	}
	
	static __tween_configure = function()
	{
		if (is_struct(tween_target))
		{
			tween_target_weak_ref = weak_ref_create(tween_target);	
			tween_is_struct = true;
		}
		else if (!instance_exists(tween_target))
		{
			destroy_flag = true;	
		}
	}
	
	#endregion
	
	#region STEP FUNCTIONS
	
	///@function		__tween_basic_attributes()
	///@description		Tween basic attributes like scale, position, etc
	__tween_basic_attributes = function()
	{	
		// State flag
		var _tween_ended = false;
		
		// Increment timer using delta time
		tween_timer += delta_time_seconds();
		tween_progress = __tween_basic_progress();
		
		// Apply curve
		if (tween_vec2)
		{
			__tween_set_attribute(tween_attribute.x,  tween_progress.x);
			__tween_set_attribute(tween_attribute.y,  tween_progress.y);

		}
		else
		{
			__tween_set_attribute(tween_attribute,  tween_progress);		
		}
		
		// Call target update function
		if (tween_is_struct && struct_exists(tween_target, "update_children"))
		{
			tween_target.update_children();
		}
		
		// Check if ended
		_tween_ended = tween_timer > tween_timer_total ? true : false;
		
		return _tween_ended;		
	}
	
	///@function		__tween_basic_progress()
	///@description		Apply the Easing Functions or animation curves
	__tween_basic_progress = function()
	{
		var _progress = 0;
		if (tween_with_curve)
		{
			_progress = animcurve_channel_evaluate(tween_channel, tween_timer / tween_timer_total);	
		}
		else
		{
			if (tween_vec2)
			{
				_progress = new Vector2();
				_progress.x = global.easing_functions[tween_curve](tween_timer, tween_start_value.x, tween_diff_value.x, tween_timer_total);	
				_progress.y = global.easing_functions[tween_curve](tween_timer, tween_start_value.y, tween_diff_value.y, tween_timer_total);	
			}
			else
			{
				_progress = global.easing_functions[tween_curve](tween_timer, tween_start_value, tween_diff_value, tween_timer_total);
			}
		}	
		
		return _progress;
	}
	
	///@function		__tween_specific_attributes()
	///@description		Tween more complex/specific attributes, like sub-image
	static __tween_specific_attributes = function()
	{
		_tween_ended = false;
		switch (tween_attribute)
		{
			case TWEEN_ATTRIBUTE_SUB_IMG:
				_tween_ended = __tween_sub_img();
				break;
		}
		return _tween_ended;
	}
	
	///@function		__tween_sub_img()
	///@description		Tween sub-image or sprite_index
	static __tween_sub_img = function()
	{
		var _tween_ended = false;
		tween_target.sub_img += sprite_get_speed(tween_target.sprite) / game_get_speed(gamespeed_fps);	
		if (tween_target.sub_img > sprite_get_number(tween_target.sprite) - 1)
		{
			_tween_ended = true;
		}
		return _tween_ended;
	}
	
	///@function		__tween_process()
	///@description		Handle the tweening process
	static __tween_process = function()
	{	
		if (tween_is_struct && !weak_ref_alive(tween_target_weak_ref))
		{
			destroy_flag = true;
			return;			
		}
		else if (!instance_exists(tween_target))
		{
			destroy_flag = true;
			return;			
		}
		else if (destroy_flag)
		{
			return;	
		}
			
		if (!tween_delayed)
		{		
			tween_delay_timer += delta_time_seconds();
			if (tween_delay_timer >= tween_delay_total)
			{			
				tween_delayed = true;
			}
		}
						
		if (tween_delayed && !destroy_flag)
		{	
			if (!tween_started)
			{

				tween_started = true;
				if (tween_basic) __tween_calculate_diff();
			}
		
			var _tween_ended = false;
			if (tween_basic)
			{
				_tween_ended = __tween_basic_attributes();	
			}
			else
			{
				_tween_ended = __tween_specific_attributes();
			}
			
			if (_tween_ended)
			{
				__execute_on_complete();
				tween_loops--;
				if (tween_loops == 0)
				{
					destroy_flag = true;
				}
				else
				{
					if (tween_ping_pong_flag)
					{
						tween_to_value = variable_clone(tween_first_start_value);
					}
					else
					{
						tween_to_value = variable_clone(tween_first_to_value);
					}
					tween_ping_pong_flag = !tween_ping_pong_flag;
					
					tween_started  = false;
					tween_timer = 0;
				}
			}
		}	
	}
	
	#endregion
	
	#endregion
}

#endregion

#region SYSTEM MANAGER

function __mini_tween_start_sys()
{
	var _started = false;
	var _manager = global.tween_manager.manager_object;
	
	if (!instance_exists(_manager))
	{
		global.tween_manager.manager_object = instance_create_depth(-100, -100, 0, obj_mini_tweener);
		
		
		_started = true;
	}
	else _started = true;
	
	return _started;
}

function __mini_tween_get_manager()
{
	if (global.tween_manager.manager_object == noone)
	{
		__mini_tween_start_sys();	
	}
	return global.tween_manager.manager_object;
}

#endregion

#region UTILITY FUNCTIONS

///@function									mini_tween(_tween_target, _curve, _channel, _timer)
///@description									Function used to create a Tween for a MiniTransform struct
///@param {struct, id} _tween_target			Struct or instance to be tweened
///@param {real} _timer							Timer the tweening will last in seconds
function mini_tween(_tween_target, _timer)
{
	var _manager = __mini_tween_get_manager(),
		_tween_struct = noone;
		
	var _tween = new MiniTween(_tween_target, _timer);
	_tween_struct = _manager.add_tween(_tween);
	_tween_struct.__tween_configure();
	
	return _tween_struct;
}

#endregion