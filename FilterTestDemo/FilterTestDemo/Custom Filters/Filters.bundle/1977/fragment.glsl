varying highp vec2 textureCoordinate;

//有两个纹理采样器就是用来叠加的
uniform sampler2D inputImageTexture;
uniform sampler2D inputImageTexture_1;

uniform highp float alpha;
 
void main()
{
    //获取正常的rgb颜色
    lowp vec3 origin_texel = texture2D(inputImageTexture, textureCoordinate).rgb;
    //将r,g,b改变后获得新的rgb
	lowp vec3 texel = vec3(texture2D(inputImageTexture_1, vec2(origin_texel.r, 0.1667)).r, texture2D(inputImageTexture_1, vec2(origin_texel.g, 0.5)).g, texture2D(inputImageTexture_1, vec2(origin_texel.b, 0.8333)).b);
    
    //mix:线性混合
    //保存片元着色器完成的颜色值
	gl_FragColor = vec4(mix(origin_texel, texel, alpha), 1.0);
}
