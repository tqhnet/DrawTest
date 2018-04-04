precision mediump float;

uniform sampler2D image;
uniform sampler2D image1;

varying vec2 vTexcoord;

void main()
{
    gl_FragColor = texture2D(image, vTexcoord);
}

