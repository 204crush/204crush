precision mediump float;

varying mediump vec2 vTextureCoord;

uniform sampler2D uSampler;
uniform sampler2D noise;

uniform float time;
uniform vec4 filterClamp;

uniform float aspect;

uniform vec2 off;
uniform float flash;

void main(  )
{
	// Normalized pixel coordinates (from 0 to 1)
    vec2 uv = vTextureCoord;
	vec2 nuv = vTextureCoord*3.0;
	
    float n = texture2D(noise, nuv+vec2(sin(time*.3),time)*.02-off*.4).r-.5;
    float n2 = texture2D(noise,vec2(.2)+ nuv+vec2(sin(time*.5),time)*.04-off*.8).r-.5;
    n+=n2;
    
	nuv.y*=aspect;
    uv.x+=n/250.;
    uv.y+=n/250.;
    
    float d = length(uv-vec2(0.5));
    d=smoothstep(0.1,0.6,1.-d);
	vec4 base = texture2D(uSampler, uv)*d;
	
    // Output to screen
    vec4 col = vec4( sin(uv.x+time), cos(uv.y+time), uv.x,1.);
    
	gl_FragColor = base+smoothstep(-1., 1., n)*col*.1 + vec4(2., 0.,0.,1.)*flash*smoothstep(-0.1,1.5,1.-d);
	//gl_FragColor =vec4(n,n,n,1.);//
}
