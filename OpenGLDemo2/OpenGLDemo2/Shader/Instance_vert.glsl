attribute vec3 position;
attribute vec3 offset;  //偏移量
attribute vec2 texcoord;

varying vec2 vTexcoord;

void main()
{
    gl_Position = vec4(position+offset, 1.0);
    vTexcoord = texcoord;
}

