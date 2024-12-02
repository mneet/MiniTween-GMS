/// @description Inserir descrição aqui
// Você pode escrever seu código neste editor

tween_queue = [];
tween_amnt = 0;
tween_active = false;
	
#region TWEEN FUNCTIONS
	
///@function		tween_queue_process(_owner)
///@description		Handle the tween queue step process
tween_queue_process = function()
{
	if (!tween_active) return;
	for (var _i = tween_amnt - 1; _i >= 0; _i--) 
	{
		var _tween = tween_queue[_i];
		_tween.__tween_process();
		if (_tween.destroy_flag) {
		    array_delete(tween_queue, _i, 1); 
			tween_amnt--;
		}
	}
		
	if (tween_amnt <= 0) tween_active = false;

}
	
///@function			add_tween(_tween)
///@function			Create a default Tween struct on the node
add_tween = function(_tween)
{
	array_push(tween_queue, _tween);
		
	tween_amnt = array_length(tween_queue);
	tween_active = true;
	return tween_queue[tween_amnt - 1];
}
		
#endregion


global.tween_manager.manager_object = id;