// Author: Ruben Penalva ruben.penalva@rpenalva.com
// License: MIT License

// ShaderLab shader
// https://docs.unity3d.com/Manual/SL-ShaderPrograms.html
// https://docs.unity3d.com/Manual/SL-Shader.html
Shader "Shaders101/GradientShader"
{

    Properties
    {
        // https://docs.unity3d.com/ScriptReference/MaterialPropertyDrawer.html
        [Header(Right Face Settings)] _RightHeader ("RightHeader", Float) = 0
        _RightStartColor            ("Right start color", Color) = (1,0,0,0)
        _RightMiddleColor           ("Right middle color", Color) = (0,1,0,0)
        _RightEndColor              ("Right end color", Color) = (0,0,1,0)
        _RightMiddleColorLength     ("Right middle color length", Float) = 0
        _RightGradientOffset        ("Right gradient offset", Float) = 0
        _RightGradientLength        ("Right gradient length", Range(1,100)) = 1
        _RightGradientAngle         ("Right gradient angle", Range(0,6.28)) = 0
        [Toggle(_RIGHTSOLID)]_RS    ("Right solid enabled", Int) = 0
        [Toggle(_RIGHTMIDDLE)]_RM   ("Right middle color enabled", Int) = 0 

        [Space]

        [Header(Back Face Settings)] _BacktHeader ("BackHeader", Float) = 0
        _BackStartColor            ("Back start color", Color) = (1,0,0,0)
        _BackMiddleColor           ("Back middle color", Color) = (0,1,0,0)
        _BackEndColor              ("Back end color", Color) = (0,0,1,0)
        _BackMiddleColorLength     ("Back middle color length", Float) = 0
        _BackGradientOffset        ("Back gradient offset", Float) = 0
        _BackGradientLength        ("Back gradient length", Range(1,100)) = 1
        _BackGradientAngle         ("Back gradient angle", Range(0,6.28)) = 0
        [Toggle(_BACKSOLID)]_BS    ("Back solid enabled", Int) = 0
        [Toggle(_BACKMIDDLE)]_BM   ("Back middle color enabled", Int) = 0 
    }

    SubShader
    {
        Pass
        {
            CGPROGRAM

            #pragma vertex VertexShaderMain
            #pragma fragment FragmentShaderMain

            #pragma shader_feature _RIGHTSOLID
            #pragma shader_feature _RIGHTMIDDLE

            #pragma shader_feature _BACKSOLID
            #pragma shader_feature _BACKMIDDLE

            #include "UnityCG.cginc"
            #include "GradientCommon.cginc"

            struct VertexData
            {
                float4 m_position   :   POSITION;
                half4 m_normal      :   NORMAL;
            };

            struct InterpolatedData
            {
                float4 m_clipPosition : SV_POSITION;
                half4 m_color : COLOR;
            };

            half4   _RightStartColor;
            half4   _RightMiddleColor;
            half4   _RightEndColor;
            half    _RightMiddleColorLength;
            half    _RightGradientOffset;
            half    _RightGradientLength;
            half    _RightGradientAngle;

            half4   _BackStartColor;
            half4   _BackMiddleColor;
            half4   _BackEndColor;
            half    _BackMiddleColorLength;
            half    _BackGradientOffset;
            half    _BackGradientLength;
            half    _BackGradientAngle;

            static const half3 RIGHT_DIR = half3(1.0h, 0.0h, 0.0h);
            static const half3 BACK_DIR = half3(0.0h, 0.0h, -1.0h);

            half4 DirectionalColor(half3 normal, half3 direction, half4 color)
            {
                return saturate(dot(normal, direction)) * color;
            }

            half4 RightColor(half4 position, half3 normal)
            {
            #if _RIGHTSOLID
                const half4 color = _RightStartColor;
            #else
                const half2 gradientOffsetScale = half2(_RightGradientOffset, _RightGradientLength);

                #if _RIGHTMIDDLE
                const half4 color = Gradient_2D(position.zy, _RightStartColor, _RightMiddleColor, _RightEndColor,
                                                _RightMiddleColorLength, gradientOffsetScale, _RightGradientAngle);
                #else
                const half4 color = Gradient_2D(position.zy, _RightStartColor, _RightEndColor, gradientOffsetScale,
                                                _RightGradientAngle);
                #endif // _RIGHTMIDDLE
            #endif // _RIGHTSOLID

                return DirectionalColor(normal, RIGHT_DIR, color);
            }

            half4 BackColor(half4 position, half3 normal)
            {
            #if _BACKSOLID
                const half4 color = _BackStartColor;
            #else
                const half2 gradientOffsetScale = half2(_BackGradientOffset, _BackGradientLength);

                #if _BACKMIDDLE
                const half4 color = Gradient_2D(position.xy, _BackStartColor, _BackMiddleColor, _BackEndColor,
                                                _BackMiddleColorLength, gradientOffsetScale, _BackGradientAngle);
                #else
                const half4 color = Gradient_2D(position.xy, _BackStartColor, _BackEndColor, gradientOffsetScale,
                                                _BackGradientAngle);
                #endif // _BACKMIDDLE
            #endif // _BACKSOLID

                return DirectionalColor(normal, BACK_DIR, color);
            }

            InterpolatedData VertexShaderMain(VertexData vertexData)
            {
                InterpolatedData interpolatedData;
                interpolatedData.m_clipPosition = UnityObjectToClipPos(vertexData.m_position);

                interpolatedData.m_color =  RightColor(vertexData.m_position, vertexData.m_normal) +
                                            BackColor(vertexData.m_position, vertexData.m_normal);

                return interpolatedData;
            }

            half4 FragmentShaderMain(InterpolatedData inData) : SV_TARGET
            {
                return inData.m_color;
            }


            ENDCG
        }
    }
}