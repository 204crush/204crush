package js.three;

import js.html.*;

@:native("THREE")
extern enum Blending
{
	NoBlending;
	NormalBlending;
	AdditiveBlending;
	SubtractiveBlending;
	MultiplyBlending;
	CustomBlending;
}