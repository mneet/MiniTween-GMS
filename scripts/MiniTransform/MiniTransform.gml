/*
	MiniTransform is a system used together with MiniTween to 
	handle visual attributes and create simple animations with them!
	
	-- When you should use it? --
	If you need variables for visual elements that aren't objects or 
	you don't want to use the default ones
	
	-- Example --
	You have two different sprites inside an object and you need
	them to have different transform attributes
	
	-- Credits -- 
	
	MiniTransform and MiniTween is a system created by Neet,
	you can check my stuff at https://github.com/mneet/ or https://lioneet.itch.io/ ;D
	
	Version 0.1.0.0
*/

///@function MiniTransform()
///@description Transform attributes for objects and structs
function MiniTransform() constructor
{
	owner = noone;
	parent = noone;
	children = noone;
	
	// ATTRIBUTES
	position = new Vector2(0,0);
	local_position = new Vector2(0,0);
	
	scale = new Vector2(1,1);
	local_scale = new Vector2(1,1);
	
	alpha = 1;	
	local_alpha = 1;
	
	rotation = 0;
	local_rotation = 0;
	
	size = new Vector2(16,16);
	base_size = new Vector2(16,16);

	color = c_white;
	
	sub_img = 0;
	depth = 0;
	
	#region System
	
	///@function		update_from_parent()
	///@description		Update all attributes from parent transform
	static update_from_parent = function()
	{
		if (parent == noone) return;
		
		position.x =  parent.position.x + local_position.x;
		position.y =  parent.position.y + local_position.y;
		
		scale.x =  parent.scale.x + local_scale.x;
		scale.y =  parent.scale.y + local_scale.y;
		
		alpha = local_alpha * parent.alpha;
		
		rotation = local_rotation + parent.rotation;
		
		size.x = base_size.x * scale.x;
		size.y = base_size.y * scale.y;
		
	}
	
	///@function		update_children()
	///@description		Update all children transforms
	update_children = function()
	{
		
	}
	
	#endregion
	
	#region ADD

	static transform_add_scale = function(_x, _y)
	{
		scale.x += _x;
		scale.y += _y;
		
		local_scale.x += _x;
		local_scale.y += _y;
		
		return self;
	}
	
	static transform_add_position = function(_x, _y)
	{
		position.x += _x;
		position.y += _y;
		
		local_position.x += _x;
		local_position.y += _y;
		
		return self;
	}
	
	static transform_add_alpha = function(_alpha)
	{
		alpha += _alpha;	
		local_alpha += _alpha;
		
		
		return self;
	}
	
	static transform_add_rotation = function(_rotation)
	{
		rotation += _rotation;	
		local_rotation += _rotation;
		
		return self;
	}
	
	#endregion
	
	#region SET
	
	static transform_set_scale = function(_x, _y)
	{
		scale.x = _x;
		scale.y = _y;
		
		local_scale.x = _x;
		local_scale.y = _y;
		
		return self;
	}
	
	static transform_set_position = function(_x, _y)
	{
		position.x = _x;
		position.y = _y;
		
		local_position.x = _x;
		local_position.y = _y;
		
		return self;
	}
	
	static transform_set_alpha = function(_alpha)
	{
		alpha = _alpha;	
		local_alpha = _alpha;
		
		
		return self;
	}
	
	static transform_set_rotation = function(_rotation)
	{
		rotation = _rotation;	
		local_rotation = _rotation;
		
		return self;
	}
	
	#endregion
}	