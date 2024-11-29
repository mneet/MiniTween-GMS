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

global.mini_tween_manager = {};
with(global.mini_tween_manager)
{
	manager_object = noone;	
}

enum TWEEN_ATTRIBUTE
{
	POSITION,
	SCALE,
	ALPHA,
	ROTATION,
	SUB_IMG
}

enum TWEEN_CURVES
{
	EASE_IN,
	EASE_OUT,
	ELASTIC_IN,
	ELASTIC_OUT,
	MID_SLOW,
	BOUNCE_IN,
	BOUNCE_OUT
}

function MiniTween(_tween_target, _curve, _channel, _timer) constructor
{
	curve = _curve;
	channel = _channel;
	timer_total = _timer;
	delay_total = 0;
	
	tween_attribute = TWEEN_ATTRIBUTE.POSITION;
	tween_target = _tween_target;
			
	on_complete_func = noone;
	on_complete_func_param = tween_target;
	
	// Position
	tween_to_position = 0;
	tween_position_diff = 0;
	tween_position_start = 0;
	
	tween_to_scale = 0;
	tween_scale_diff = 0;
	tween_scale_start = 0;
	
	tween_to_alpha = 1;
	tween_alpha_diff = 0;
	tween_alpha_start = 0;
	
	tween_to_rotation = 0;
	tween_rotation_diff = 0;
	tween_rotation_start = 0;
		
	// Flags
	tween_timer = 0;
	tween_delay_timer = 0;
	tween_delayed = false;
	tween_channel = animcurve_get_channel(curve, channel);
	
	tween_basic = true;
	
	tween_started = false;
	tween_progress = 0;
	
	destroy_flag = false;
	
	#region Tween Building
	
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
		delay_total = _delay;
	}
	
	///@function		tween_position(_position)
	///@description		Tween a node to an given position	
	static tween_position = function(_position)
	{
		tween_attribute = TWEEN_ATTRIBUTE.POSITION;
		tween_to_position = _position;
		tween_position_diff = new Vector2(tween_target.position.x - _position.x, tween_target.position.y - _position.y);
		tween_position_start = variable_clone(tween_target.position);
		return self;
	}
	
	///@function		tween_scale(_scale)
	///@description		Tween a node to an given scale	
	static tween_scale = function(_scale)
	{
		tween_attribute = TWEEN_ATTRIBUTE.SCALE;
		tween_to_position = _scale;
		tween_scale_diff = new Vector2(-(tween_target.scale.x - _scale.x), -(tween_target.scale.y - _scale.y));
		tween_scale_start = variable_clone(tween_target.scale);
		return self;
	}
	
	///@function		tween_alpha(_alpha)
	///@description		Tween a node to an given alpha	
	static tween_alpha = function(_alpha)
	{
		tween_attribute = TWEEN_ATTRIBUTE.ALPHA;
		tween_to_position = _alpha;
		tween_alpha_diff = tween_target.alpha - _alpha;
		tween_alpha_start = variable_clone(tween_target.alpha);
		return self;
	}
	
	///@function		tween_rotation(_rotation)
	///@description		Tween a node to an given rotation	
	static tween_rotation = function(_rotation)
	{
		tween_attribute = TWEEN_ATTRIBUTE.ROTATION;
		tween_to_position = _rotation;
		tween_rotation_diff = tween_target.rotation - _rotation;
		tween_alpha_start = variable_clone(tween_target.rotation);
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
	
	#endregion
	
	#region Tween System
	
	///@function		__execute_on_complete(_)
	///@description		Execute on complete function
	__execute_on_complete = function()
	{
		if (on_complete_func != noone)
		{
			on_complete_func(on_complete_func_param);
		}
	}
	
	///@function		__tween_process()
	///@description		Handle the tweening process
	static __tween_process = function()
	{		
		if (!tween_delayed)
		{		
			tween_delay_timer += delta_time_seconds();
			if (tween_delay_timer >= delay_total)
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
	
	///@function		__tween_basic_attributes()
	///@description		Tween basic attributes like scale, position, etc
	__tween_basic_attributes = function()
	{	
		var _tween_ended = false;

		tween_timer += delta_time_seconds();
		tween_progress = animcurve_channel_evaluate(tween_channel, tween_timer / timer_total);
			
		switch (tween_attribute)
		{
			case TWEEN_ATTRIBUTE.POSITION:
				var _new_pos = new Vector2(0,0);
				_new_pos.x = tween_position_start.x + (tween_position_diff.x * tween_progress);
				_new_pos.y = tween_position_start.y + (tween_position_diff.y * tween_progress);
				tween_target.position = variable_clone(_new_pos);
				break;
			case TWEEN_ATTRIBUTE.SCALE:
				var _new_scale = new Vector2(0,0);
				_new_scale.x = tween_scale_start.x + (tween_scale_diff.x * tween_progress);
				_new_scale.y = tween_scale_start.y + (tween_scale_diff.y * tween_progress);
				tween_target.scale = variable_clone(_new_scale);
				break;
			case TWEEN_ATTRIBUTE.ALPHA:
				var _new_alpha = 0;
				_new_alpha = tween_alpha_start + (tween_alpha_diff * tween_progress);
				tween_target.alpha = variable_clone(_new_alpha);
				break;
			case TWEEN_ATTRIBUTE.ROTATION:
				var _new_rotation = 0;
				_new_rotation = tween_rotation_start + (tween_rotation_diff * tween_progress);
				tween_target.rotation = variable_clone(_new_rotation);
				break;
		}			
		tween_target.update_children();
		
		_tween_ended = tween_timer > timer_total ? true : false;
		
		return _tween_ended;
		
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
	
	#endregion
}

function MiniTweenObject(_tween_target, _curve, _channel, _timer) : MiniTween(_tween_target, _curve, _channel, _timer) constructor
{
	///@function		__tween_basic_attributes()
	///@description		Tween basic attributes like scale, position, etc
	__tween_basic_attributes = function()
	{	
		var _tween_ended = false;

		tween_timer += delta_time_seconds();
		tween_progress = animcurve_channel_evaluate(tween_channel, tween_timer / timer_total);
			
		switch (tween_attribute)
		{
			case TWEEN_ATTRIBUTE.POSITION:
				var _new_pos = new Vector2(0,0);
				_new_pos.x = tween_position_start.x + (tween_position_diff.x * tween_progress);
				_new_pos.y = tween_position_start.y + (tween_position_diff.y * tween_progress);
				tween_target.x = variable_clone(_new_pos.x);
				tween_target.y = variable_clone(_new_pos.y);
				break;
			case TWEEN_ATTRIBUTE.SCALE:
				var _new_scale = new Vector2(0,0);
				_new_scale.x = tween_scale_start.x + (tween_scale_diff.x * tween_progress);
				_new_scale.y = tween_scale_start.y + (tween_scale_diff.y * tween_progress);
				tween_target.image_xscale = variable_clone(_new_scale.x);
				tween_target.image_yscale = variable_clone(_new_scale.y);
				break;
			case TWEEN_ATTRIBUTE.ALPHA:
				var _new_alpha = 0;
				_new_alpha = tween_alpha_start + (tween_alpha_diff * tween_progress);
				tween_target.image_alpha = variable_clone(_new_alpha);
				break;
			case TWEEN_ATTRIBUTE.ROTATION:
				var _new_rotation = 0;
				_new_rotation = tween_rotation_start + (tween_rotation_diff * tween_progress);
				tween_target.image_angle = variable_clone(_new_rotation);
				break;
		}			
		
		_tween_ended = tween_timer > timer_total ? true : false;
		
		return _tween_ended;
		
	}
	
	///@function		__tween_sub_img()
	///@description		Tween sub-image or image_index
	__tween_sub_img = function()
	{
		var _tween_ended = false;
		tween_target.image_index += sprite_get_speed(tween_target.sprite_index) / game_get_speed(gamespeed_fps);	
		if (tween_target.image_index > sprite_get_number(tween_target.sprite_index))
		{
			tween_target.image_index = 0;
			_tween_ended = true;
		}
		return _tween_ended;
	}
}

#endregion

#region UTILITY FUNCTIONS

///@function									mini_tween(_tween_target, _curve, _channel, _timer)
///@description									Function used to create a Tween for a MiniTransform struct
///@param {struct} _tween_target				MiniTransform struct to be tweened
///@param {Asset.GMAnimCurve} _curve			Animation curve asset
///@param {real} _channel						Animation curve channel index
///@param {real} _timer							Timer the tweening will last in seconds
function mini_tween(_tween_target, _curve, _channel, _timer)
{
	var _manager = global.mini_tween_manager.manager_object,
		_tween_struct = noone;
		
	if (instance_exists(_manager))
	{
		var _tween = new MiniTween(_tween_target, _curve, _channel, _timer);
		_tween_struct = _manager.add_tween(_tween);
	}
	
	return _tween_struct;
}

///@function									mini_tween_object(_tween_target, _curve, _channel, _timer)
///@description									Function used to create a Tween for a Object
///@param {Asset.GMObject} _tween_target		Object to be tweened
///@param {Asset.GMAnimCurve} _curve			Animation curve asset
///@param {real} _channel						Animation curve channel index
///@param {real} _timer							Timer the tweening will last in seconds
function mini_tween_object(_tween_target, _curve, _channel, _timer)
{
	var _manager = global.mini_tween_manager.manager_object,
		_tween_struct = noone;
		
	if (instance_exists(_manager))
	{
		var _tween = new MiniTweenObject(_tween_target, _curve, _channel, _timer);
		_tween_struct = _manager.add_tween(_tween);
	}
	
	return _tween_struct;
}

///@function									mini_tween_object(_tween_target, _curve, _channel, _timer)
///@description									Function used to create a Tween for a Node (Node is an external system for creating interfaces)
///@param {struct} _node						Node struct to be tweened
///@param {Asset.GMAnimCurve} _curve			Animation curve asset
///@param {real} _channel						Animation curve channel index
///@param {real} _timer							Timer the tweening will last in seconds
///@param {struct} [_target]					The dafault target is the node own transform, but if you want to target another transform you can pass it here
function mini_tween_node(_node, _curve, _channel, _timer, _target = _node.transform)
{
	var _manager = global.mini_tween_manager.manager_object,
		_tween_struct = noone;
		
	if (instance_exists(_manager))
	{
		var _tween = new MiniTween(_target, _curve, _channel, _timer);
		_tween.on_complete_func_param = _node;
		
		_tween_struct = _manager.add_tween(_tween);
	}
	
	return _tween_struct;
}

// mini_tween_node is a function meant to be used only with NODE, an interface system made by M. Neet

#endregion