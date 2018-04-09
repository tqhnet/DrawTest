varying highp vec2 textureCoordinate;

uniform sampler2D inputImageTexture;

void main()
{
    //这里就是改变每个像素的颜色
    //输入的pgba
    lowp vec4 textureColor = texture2D(inputImageTexture, textureCoordinate);
    //输出的rgba
    lowp vec4 outputColor;
    //混合改变颜色
    outputColor.r = (textureColor.r * 1.9) + (textureColor.g * -0.3) + (textureColor.b * -0.2);
    outputColor.g = (textureColor.r * -0.2) + (textureColor.g * 1.7) + (textureColor.b * -1.0);
    outputColor.b = (textureColor.r * -0.1) + (textureColor.g * -0.6) + (textureColor.b * 2.0);
    outputColor.a = 1.0;

    
    
    //输出颜色
    gl_FragColor = outputColor;
}
