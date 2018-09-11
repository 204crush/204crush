package js.three;

import js.html.*;

@:native("THREE")
extern enum TextureFilter
{
	NearestFilter;
	NearestMipMapNearestFilter;
	NearestMipMapLinearFilter;
	LinearFilter;
	LinearMipMapNearestFilter;
	LinearMipMapLinearFilter;
}