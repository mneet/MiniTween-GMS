//=============================
// PENNER'S EASING ALGORITHMS
//=============================
/*
	Terms of Use: Easing Functions (Equations)
	Open source under the MIT License and the 3-Clause BSD License.

	MIT License
	Copyright © 2001 Robert Penner

	Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

	The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

	BSD License
	Copyright © 2001 Robert Penner

	Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

	Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
	Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
	Neither the name of the author nor the names of contributors may be used to endorse or promote products derived from this software without specific prior written permission.
	THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/


#region LINEAR

/// @param {real} time 
/// @param {real} start 
/// @param {real} change 
/// @param {real} duration
function EaseLinear(_time, _start, _change, _duration)
{		
	return _change * _time / _duration + _start;
}

#endregion

#region QUAD

/// @param {real} time 
/// @param {real} start 
/// @param {real} change 
/// @param {real} duration
function EaseInQuad(_time, _start, _change, _duration)
{		
	return _change * _time/_duration * _time/_duration + _start;
}

/// @param {real} time 
/// @param {real} start 
/// @param {real} change 
/// @param {real} duration
function EaseOutQuad(_time, _start, _change, _duration)
{	
	return -_change * _time/_duration * (_time/_duration-2) + _start;
}

/// @param {real} time 
/// @param {real} start 
/// @param {real} change 
/// @param {real} duration
function EaseInOutQuad(_time, _start, _change, _duration)
{
	_time = 2*_time/_duration;
	return _time < 1 ? _change * 0.5 * _time * _time + _start
					 : _change * -0.5 * ((_time-1) * (_time - 3) - 1) + _start;
}

#endregion

#region CUBIC

/// @param {real} time 
/// @param {real} start 
/// @param {real} change 
/// @param {real} duration
function EaseInCubic(_time, _start, _change, _duration)
{
	return _change * power(_time/_duration, 3) + _start;
}

/// @param {real} time 
/// @param {real} start 
/// @param {real} change 
/// @param {real} duration
function EaseOutCubic(_time, _start, _change, _duration)
{
	return _change * (power(_time/_duration - 1, 3) + 1) + _start;
}

/// @param {real} time 
/// @param {real} start 
/// @param {real} change 
/// @param {real} duration
function EaseInOutCubic(_time, _start, _change, _duration)
{
	_time = 2 * _time / _duration;
	return _time < 1 ? _change * 0.5 * power(_time, 3) + _start
					 : _change * 0.5 * (power(_time-2, 3) + 2) + _start;
}

#endregion

#region QUART

/// @param {real} time 
/// @param {real} start 
/// @param {real} change 
/// @param {real} duration
function EaseInQuart(_time, _start, _change, _duration)
{
	return _change * power(_time/_duration, 4) + _start;
}

/// @param {real} time 
/// @param {real} start 
/// @param {real} change 
/// @param {real} duration
function EaseOutQuart(_time, _start, _change, _duration)
{
	//return -_change * (power(_time/_duration - 1, 4) - 1) + _start; // THIS BREAKS ANDROID YYC!
	return _change * -(power(_time/_duration - 1, 4) - 1) + _start;
}

/// @param {real} time 
/// @param {real} start 
/// @param {real} change 
/// @param {real} duration
function EaseInOutQuart(_time, _start, _change, _duration)
{
	_time = 2*_time/_duration;
	return _time < 1 ? _change * 0.5 * power(_time, 4) + _start
					 : _change * -0.5 * (power(_time - 2, 4) - 2) + _start;
}

#endregion

#region QUINT

/// @param {real} time 
/// @param {real} start 
/// @param {real} change 
/// @param {real} duration
function EaseInQuint(_time, _start, _change, _duration)
{
	return _change * power(_time/_duration, 5) + _start;
}

/// @param {real} time 
/// @param {real} start 
/// @param {real} change 
/// @param {real} duration
function EaseOutQuint(_time, _start, _change, _duration)
{
	return _change * (power(_time/_duration - 1, 5) + 1) + _start;
}

/// @param {real} time 
/// @param {real} start 
/// @param {real} change 
/// @param {real} duration
function EaseInOutQuint(_time, _start, _change, _duration)
{
	_time = 2*_time/_duration;
	return _time < 1 ? _change * 0.5 * power(_time, 5) + _start
					 : _change * 0.5 * (power(_time - 2, 5) + 2) + _start;
}

#endregion

#region SINE

/// @param {real} time 
/// @param {real} start 
/// @param {real} change 
/// @param {real} duration
function EaseInSine(_time, _start, _change, _duration)
{
	return _change * (1 - cos(_time/_duration * (pi/2))) + _start;
}

/// @param {real} time 
/// @param {real} start 
/// @param {real} change 
/// @param {real} duration
function EaseOutSine(_time, _start, _change, _duration)
{
	return _change * sin(_time/_duration * (pi/2)) + _start;
}

/// @param {real} time 
/// @param {real} start 
/// @param {real} change 
/// @param {real} duration
function EaseInOutSine(_time, _start, _change, _duration)
{
	return _change * 0.5 * (1 - cos(pi*_time/_duration)) + _start;
}

#endregion

#region CIRC

/// @param {real} time 
/// @param {real} start 
/// @param {real} change 
/// @param {real} duration
function EaseInCirc(_time, _start, _change, _duration)
{
	return _change * (1 - sqrt(1 - _time/_duration * _time/_duration)) + _start;
}

/// @param {real} time 
/// @param {real} start 
/// @param {real} change 
/// @param {real} duration
function EaseOutCirc(_time, _start, _change, _duration)
{
	_time = _time/_duration - 1;
	return _change * sqrt(abs(1 - _time * _time)) + _start;
}

/// @param {real} time 
/// @param {real} start 
/// @param {real} change 
/// @param {real} duration
function EaseInOutCirc(_time, _start, _change, _duration)
{
	_time = 2*_time/_duration;
	return _time < 1 ? _change * 0.5 * (1 - sqrt(abs(1 - _time * _time))) + _start
					 : _change * 0.5 * (sqrt(abs(1 - (_time-2) * (_time-2))) + 1) + _start;
}

#endregion

#region EXPO

/// @param {real} time 
/// @param {real} start 
/// @param {real} change 
/// @param {real} duration
function EaseInExpo(_time, _start, _change, _duration)
{
	return (_time == 0) ? _start : _change * power(2, 10 * (_time/_duration - 1)) + _start;
}

/// @param {real} time 
/// @param {real} start 
/// @param {real} change 
/// @param {real} duration
function EaseOutExpo(_time, _start, _change, _duration)
{
	return (_time == _duration) ? _start + _change : _change * (-power(2, -10 * _time / _duration) + 1) + _start;
}

/// @param {real} time 
/// @param {real} start 
/// @param {real} change 
/// @param {real} duration
function EaseInOutExpo(_time, _start, _change, _duration)
{
	if (_time == 0) { return _start; }
	if (_time == _duration) { return _start + _change; }
	
	_time = 2 * _time / _duration;
	return (_time < 1) ? _change * 0.5 * power(2, 10 * (_time-1)) + _start : _change * 0.5 * (-power(2, -10 * (_time-1)) + 2) + _start;
}
	
#endregion

#region BACK

/// @param {real} time 
/// @param {real} start 
/// @param {real} change 
/// @param {real} duration
function EaseInBack(_time, _start, _change, _duration)
{
	_time /= _duration;
	_duration = 1.70158; // repurpose _duration as Robert Penner's "s" value -- You can hardcode this into wherever you see '_duration' in the next line
	return _change * _time * _time * ((_duration + 1) * _time - _duration) + _start;
}

/// @param {real} time 
/// @param {real} start 
/// @param {real} change 
/// @param {real} duration
function EaseOutBack(_time, _start, _change, _duration)
{
	_time = _time/_duration - 1;
	_duration = 1.70158; // "s"
	return _change * (_time * _time * ((_duration + 1) * _time + _duration) + 1) + _start;
}	

/// @param {real} time 
/// @param {real} start 
/// @param {real} change 
/// @param {real} duration
function EaseInOutBack(_time, _start, _change, _duration)
{
	_time = _time/_duration*2;
	_duration = 1.70158; // "s"

	if (_time < 1)
	{
	    _duration *= 1.525;
	    return _change * 0.5 * (((_duration + 1) * _time - _duration) * _time * _time) + _start;
	}

	_time -= 2;
	_duration *= 1.525;

	return _change * 0.5 * (((_duration + 1) * _time + _duration) * _time * _time + 2) + _start;
}

#endregion

#region BOUNCE

/// @param {real} time 
/// @param {real} start 
/// @param {real} change 
/// @param {real} duration
function EaseInBounce(_time, _start, _change, _duration)
{	
	return _change - EaseOutBounce(_duration - _time, 0, _change, _duration) + _start;
}

/// @param {real} time 
/// @param {real} start 
/// @param {real} change 
/// @param {real} duration
function EaseOutBounce(_time, _start, _change, _duration)
{
	_time /= _duration;

	if (_time < 1/2.75)
	{
	    return _change * 7.5625 * _time * _time + _start;
	}
	else
	if (_time < 2/2.75)
	{
	    _time -= 1.5/2.75;
	    return _change * (7.5625 * _time * _time + 0.75) + _start;
	}
	else
	if (_time < 2.5/2.75)
	{
	    _time -= 2.25/2.75;
	    return _change * (7.5625 * _time * _time + 0.9375) + _start;
	}
	else
	{
	    _time -= 2.625/2.75;
	    return _change * (7.5625 * _time * _time + 0.984375) + _start;
	}
}

/// @param {real} time 
/// @param {real} start 
/// @param {real} change 
/// @param {real} duration
function EaseInOutBounce(_time, _start, _change, _duration)
{
	return _time < _duration*0.5 ? EaseInBounce(_time*2, 0, _change, _duration)*0.5 + _start
							     : EaseOutBounce(_time*2 - _duration, 0, _change, _duration)*0.5 + _change*0.5 + _start;
}
	
#endregion

#region ELASTIC

/// @param {real} time 
/// @param {real} start 
/// @param {real} change 
/// @param {real} duration
function EaseInElastic(_time, _start, _change, _duration)
{
	var _s = 1.70158;
	var _p = _duration*0.3;
	var _a = _change;
	var _val = _time;
	
	if (_val == 0 || _a == 0) { return _start; }

	_val /= _duration;

	if (_val == 1) { return _start+_change; }

	if (_a < abs(_change)) 
	{ 
	    _a = _change; // lol, wut?
	    _s = _p*0.25; 
	}
	else
	{
	    _s = _p / (2*pi) * arcsin(_change/_a);
	}

	return -(_a * power(2,10 * (_val-1)) * sin(((_val-1) * _duration - _s) * (2*pi) / _p)) + _start;
}

/// @param {real} time 
/// @param {real} start 
/// @param {real} change 
/// @param {real} duration
function EaseOutElastic(_time, _start, _change, _duration)
{
	var _s = 1.70158;
	var _p = _duration * 0.3;
	var _a = _change;
	var _val = _time;

	if (_val == 0 || _a == 0) { return _start; }

	_val /= _duration;

	if (_val == 1) { return _start + _change; }

	if (_a < abs(_change)) 
	{ 
	    _a = _change; // lol, wut?
	    _s = _p * 0.25; 
	}
	else
	{
	    _s = _p / (2*pi) * arcsin (_change/_a);
	}

	return _a * power(2, -10 * _val) * sin((_val * _duration - _s) * (2*pi) / _p ) + _change + _start;
}

/// @param {real} time 
/// @param {real} start 
/// @param {real} change 
/// @param {real} duration
function EaseInOutElastic(_time, _start, _change, _duration)
{
	var _s = 1.70158;
	var _p = _duration * (0.3 * 1.5);
	var _a = _change;
	var _val = _time;

	if (_val == 0 || _a == 0) { return _start; }

	_val /= _duration*0.5;

	if (_val == 2) { return _start+_change; }

	if (_a < abs(_change)) 
	{ 
	    _a = _change;
	    _s = _p * 0.25;
	}
	else
	{
	    _s = _p / (2*pi) * arcsin (_change / _a);
	}

	if (_val < 1) { return -0.5 * (_a * power(2, 10 * (_val-1)) * sin(((_val-1) * _duration - _s) * (2*pi) / _p)) + _start; }

	return _a * power(2, -10 * (_val-1)) * sin(((_val-1) * _duration - _s) * (2*pi) / _p) * 0.5 + _change + _start;
}

#endregion