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
	
	easing_functions = [
	    EaseLinear,        // EASE_IN
	    EaseInSine,        // EASE_IN
	    EaseOutSine,       // EASE_OUT
	    EaseInOutSine,     // EASE_IN_OUT
	    EaseInCubic,       // CUBIC_IN
	    EaseOutCubic,      // CUBIC_OUT
	    EaseInOutCubic,    // CUBIC_IN_OUT
	    EaseInQuart,       // QUART_IN
	    EaseOutQuart,      // QUART_OUT
	    EaseInOutQuart,    // QUART_IN_OUT
	    EaseInExpo,        // EXPO_IN
	    EaseOutExpo,       // EXPO_OUT
	    EaseInOutExpo,     // EXPO_IN_OUT
	    EaseInCirc,        // CIRC_IN
	    EaseOutCirc,       // CIRC_OUT
	    EaseInOutCirc,     // CIRC_IN_OUT
	    EaseInBack,        // BACK_IN
	    EaseOutBack,       // BACK_OUT
	    EaseInOutBack,     // BACK_IN_OUT
	    EaseInElastic,     // ELASTIC_IN
	    EaseOutElastic,    // ELASTIC_OUT
	    EaseInOutElastic,  // ELASTIC_IN_OUT
	    EaseInBounce,      // BOUNCE_IN
	    EaseOutBounce,     // BOUNCE_OUT
	    EaseInOutBounce    // BOUNCE_IN_OUT
	];
}

enum TWEEN_ATTRIBUTE
{
	POSITION,
	SCALE,
	ALPHA,
	ROTATION,
	SUB_IMG,
	CUSTOM
}

enum TWEEN_CURVES
{
	LINEAR,
	EASE_IN,
	EASE_OUT,
	EASE_IN_OUT,
	CUBIC_IN,
	CUBIC_OUT,
	CUBIC_IN_OUT,
	QUART_IN,
	QUART_OUT,
	QUART_IN_OUT,
	EXPO_IN,
	EXPO_OUT,
	EXPO_IN_OUT,
	CIRC_IN,
	CIRC_OUT,
	CIRC_IN_OUT,
	BACK_IN,
	BACK_OUT,
	BACK_IN_OUT,
	ELASTIC_IN,
	ELASTIC_OUT,
	ELASTIC_IN_OUT,
	BOUNCE_IN,
	BOUNCE_OUT,
	BOUNCE_IN_OUT
}

enum TWEEN_TYPE
{
	MINI_TRANSFORM,
	OBJECT
}

#endregion

#region STRUCTS

function MiniTween(_tween_target, _type, _curve, _timer = 0) constructor
{
	// Curve
	tween_channel = noone;
	tween_curve = _curve;
	
	// Timers
	tween_timer_total = _timer;
	tween_timer = 0;
	
	tween_delay_total = 0;
	tween_delay_timer = 0;
	
	// Tween Control
	tween_attribute = TWEEN_ATTRIBUTE.POSITION;
	tween_target = _tween_target;
	tween_type = _type;

	// Function
	on_complete_func = noone;
	on_complete_func_param = tween_target;
	
	// Attributes
	tween_to_value = 0;
	tween_start_value = 0;
	tween_diff_value = 0;
	
	custom_attribute_name = "";
		
	// Tweening Control
	tween_progress = 0;
	tween_delayed = false;		
	tween_basic = true;	
	tween_started = false;
	destroy_flag = false;
		
	tween_with_curve = false;
	tween_vec2 = false;
	tween_vec2_values = new Vector2(false, false);
	
	// LOOPING
	tween_loops = 1;
	tween_ping_pong = false;
	tween_pong_flag = false;		
		
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
	
	///@function		tween_position(_position)
	///@description		Tween a node to an given position	
	static tween_position = function(_x, _y)
	{
		tween_attribute = TWEEN_ATTRIBUTE.POSITION;
		tween_to_value = new Vector2(_x ,_y);
		
		tween_vec2 = true;
		tween_vec2_values.x = _x != 0;
		tween_vec2_values.y = _y != 0;
		
		return self;
	}
	
	///@function		tween_scale(_scale)
	///@description		Tween a node to an given scale	
	static tween_scale = function(_x, _y)
	{
		tween_attribute = TWEEN_ATTRIBUTE.SCALE;
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
		tween_attribute = TWEEN_ATTRIBUTE.ALPHA;
		tween_to_value = _alpha;
		
		return self;
	}
	
	///@function		tween_rotation(_rotation)
	///@description		Tween a node to an given rotation	
	static tween_rotation = function(_rotation)
	{
		tween_attribute = TWEEN_ATTRIBUTE.ROTATION;
		tween_to_value = _rotation;
		
		return self;
	}
	
	///@function		tween_subimg(_)
	///@description		Tween a node to an given rotation	
	static tween_subimg = function()
	{
		tween_attribute = TWEEN_ATTRIBUTE.SUB_IMG;
		tween_basic = false;
		
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
	
	#endregion
	
	#region INTERNAL SYSTEM
	
	#region TWEEN CONFIGURATION
	
	///@function		__execute_on_complete(_)
	///@description		Execute on complete function
	__execute_on_complete = function()
	{
		if (on_complete_func != noone)
		{
			on_complete_func(on_complete_func_param);
		}
	}
	
	static __tween_get_attribute_mini_transform = function(_attribute)
	{
		var _value = noone;
		switch (_attribute)
		{
			case TWEEN_ATTRIBUTE.POSITION:
				_value = tween_target.position;
				break;
				
			case TWEEN_ATTRIBUTE.SCALE:
				_value = tween_target.scale;
				break;
				
			case TWEEN_ATTRIBUTE.ALPHA:
				_value = tween_target.alpha;	
				break;
				
			case TWEEN_ATTRIBUTE.ROTATION:
				_value = tween_target.rotation;	
				break;
			
			case TWEEN_ATTRIBUTE.CUSTOM:	
				_value = variable_struct_get(tween_target, custom_attribute_name);
				break;
				
		}
		return _value
	}	
	
	static __tween_get_attribute_object = function(_attribute)
	{
		var _value = noone;
		switch (_attribute)
		{
			case TWEEN_ATTRIBUTE.POSITION:
				_value = new Vector2(tween_target.x, tween_target.y);
				break;
				
			case TWEEN_ATTRIBUTE.SCALE:
				_value = new Vector2(tween_target.image_xscale, tween_target.image_yscale);
				break;
				
			case TWEEN_ATTRIBUTE.ALPHA:
				_value = tween_target.image_alpha;
				break;
				
			case TWEEN_ATTRIBUTE.ROTATION:
				_value = tween_target.image_angle;
				break;
				
			case TWEEN_ATTRIBUTE.CUSTOM:	
				_value = variable_instance_get(tween_target, custom_attribute_name);
				break;
				
		}
		return _value;
	}	
	
	static __tween_get_attribute = function(_attribute)
	{
		var _value = 0;
		switch (tween_type)
		{
			case TWEEN_TYPE.OBJECT:			
				_value = __tween_get_attribute_object(_attribute);
				break;
				
			case TWEEN_TYPE.MINI_TRANSFORM:	
				_value = __tween_get_attribute_mini_transform(_attribute);
				break;
		}
		return _value;
	}	
	
	static __tween_set_attribute_mini_transform = function(_attribute, _value)
	{
		switch (_attribute)
		{
			case TWEEN_ATTRIBUTE.POSITION:
				tween_target.position = variable_clone(_value);
				break;
				
			case TWEEN_ATTRIBUTE.SCALE:
				tween_target.scale = variable_clone(_value);
				break;
				
			case TWEEN_ATTRIBUTE.ALPHA:
				tween_target.alpha = variable_clone(_value);	
				break;
				
			case TWEEN_ATTRIBUTE.ROTATION:
				tween_target.rotation = variable_clone(_value);	
				break;
			
			case TWEEN_ATTRIBUTE.CUSTOM:	
				_value = variable_struct_set(tween_target, custom_attribute_name, _value);
				break;				
		}
	}	
	
	static __tween_set_attribute_object = function(_attribute, _value)
	{
		switch (_attribute)
		{
			case TWEEN_ATTRIBUTE.POSITION:
				variable_instance_set(tween_target, "x", _value.x);
				variable_instance_set(tween_target, "y", _value.y);
				break;
				
			case TWEEN_ATTRIBUTE.SCALE:
				variable_instance_set(tween_target, "image_xscale", _value.x);
				variable_instance_set(tween_target, "image_yscale", _value.y);
				break;
				
			case TWEEN_ATTRIBUTE.ALPHA:
				variable_instance_set(tween_target, "image_alpha", _value);	
				break;
				
			case TWEEN_ATTRIBUTE.ROTATION:
				variable_instance_set(tween_target, "image_angle", _value);	
				break;
			
			case TWEEN_ATTRIBUTE.CUSTOM:	
				_value = variable_instance_set(tween_target, custom_attribute_name, _value);
				break;	
				
		}
	}	
	
	static __tween_set_attribute = function(_attribute, _value)
	{
		switch (tween_type)
		{
			case TWEEN_TYPE.OBJECT:			
				__tween_set_attribute_object(_attribute, _value);
				break;
				
			case TWEEN_TYPE.MINI_TRANSFORM:	
				__tween_set_attribute_mini_transform(_attribute, _value);
				break;
		}
	}
	
	
	///@function		__tween_calculate_diff(_)
	///@description		Calculate values when start the tweening process
	static __tween_calculate_diff = function()
	{
		if (tween_vec2)
		{
			tween_start_value = __tween_get_attribute(tween_attribute);			
			tween_diff_value = new Vector2(-(tween_start_value.x - tween_to_value.x), -(tween_start_value.y - tween_to_value.y));
		}
		else
		{
			tween_start_value =  __tween_get_attribute(tween_attribute);
			tween_diff_value = -(tween_start_value - tween_to_value);
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
		var _value = 0;
		if (tween_vec2)
		{
			_value = new Vector2(0,0);
			_value.x = tween_progress.x;
			_value.y = tween_progress.y;
		}
		else
		{
			_value = tween_progress;			
		}
		__tween_set_attribute(tween_attribute, _value);
		
		// Call target update function
		//tween_target.update_children();
		
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
				_progress.x = global.tween_manager.easing_functions[tween_curve](tween_timer, tween_start_value.x, tween_diff_value.x, tween_timer_total);	
				_progress.y = global.tween_manager.easing_functions[tween_curve](tween_timer, tween_start_value.y, tween_diff_value.y, tween_timer_total);	
			}
			else
			{
				_progress = global.tween_manager.easing_functions[tween_curve](tween_timer, tween_start_value, tween_diff_value, tween_timer_total);
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
			case TWEEN_ATTRIBUTE.SUB_IMG:
				_tween_ended = __tween_sub_img();
				break;
		}
		return _tween_ended;
	}
	
	///@function		__tween_sub_img()
	///@description		Tween sub-image or sprite_index
	__tween_sub_img = function()
	{
		var _tween_ended = false;
		tween_target.sub_img += sprite_get_speed(tween_target.sprite) / game_get_speed(gamespeed_fps);	
		if (tween_target.sub_img > sprite_get_number(tween_target.sprite))
		{
			tween_target.sub_img = 0;
			_tween_ended = true;
		}
		return _tween_ended;
	}
	
	///@function		__tween_process()
	///@description		Handle the tweening process
	static __tween_process = function()
	{	
		
		if (tween_type == TWEEN_TYPE.MINI_TRANSFORM)
		{
			if (!weak_ref_alive(tween_target_weak_ref))
			{
				destroy_flag = true;
				return;
			}			
		}
		else if (tween_type == TWEEN_TYPE.OBJECT)
		{
			if (!instance_exists(tween_target))
			{
				destroy_flag = true;
				return;
			}
		}	
		
		if (!tween_started)
		{
			tween_started = true;
			__tween_calculate_diff();
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
				destroy_flag = true;
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

///@function									__mini_tween_basic(_tween_target, _curve, _channel, _timer)
///@description									Function used to create a Tween for a MiniTransform struct
///@param {struct} _tween_target				MiniTransform struct to be tweened
///@param {real} _type							Timer the tweening will last in seconds
///@param {real} _timer							Timer the tweening will last in seconds
///@param {real} _curve							Animation curve enum TWEEN_CURVES
function __mini_tween_basic(_tween_target, _type, _timer, _curve = TWEEN_CURVES.LINEAR)
{
	var _manager = __mini_tween_get_manager(),
		_tween_struct = noone;
		
	var _tween = new MiniTween(_tween_target ,_type, _curve, _timer);
	_tween_struct = _manager.add_tween(_tween);
		
	return _tween_struct;
}

///@function									mini_tween(_tween_target, _curve, _channel, _timer)
///@description									Function used to create a Tween for a MiniTransform struct
///@param {struct} _tween_target				MiniTransform struct to be tweened
///@param {real} _timer							Timer the tweening will last in seconds
///@param {real} _curve							Animation curve enum TWEEN_CURVES
function mini_tween(_tween_target, _timer, _curve = TWEEN_CURVES.LINEAR)
{
	var _tween = __mini_tween_basic(_tween_target, TWEEN_TYPE.MINI_TRANSFORM, _timer, _curve);		
	
	return _tween;
}

///@function									mini_tween_object(_tween_target, _curve, _channel, _timer)
///@description									Function used to create a Tween for a Object
///@param {ID.Instance} _tween_target			Object to be tweened
///@param {real} _timer							Timer the tweening will last in seconds
///@param {real} _curve							Animation curve enum TWEEN_CURVES
function mini_tween_object(_tween_target, _timer, _curve)
{
	var _tween = __mini_tween_basic(_tween_target, TWEEN_TYPE.OBJECT, _timer, _curve);		
	return _tween;
}

#endregion