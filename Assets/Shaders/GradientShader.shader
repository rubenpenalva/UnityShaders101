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
        [Header(Right Face)]
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

        [Header(Left Face)]
        _LeftStartColor            ("Left start color", Color) = (1,0,0,0)
        _LeftMiddleColor           ("Left middle color", Color) = (0,1,0,0)
        _LeftEndColor              ("Left end color", Color) = (0,0,1,0)
        _LeftMiddleColorLength     ("Left middle color length", Float) = 0
        _LeftGradientOffset        ("Left gradient offset", Float) = 0
        _LeftGradientLength        ("Left gradient length", Range(1,100)) = 1
        _LeftGradientAngle         ("Left gradient angle", Range(0,6.28)) = 0
        [Toggle(_LEFTSOLID)]_LS    ("Left solid enabled", Int) = 0
        [Toggle(_LEFTMIDDLE)]_LM   ("Left middle color enabled", Int) = 0 

        [Space]

        [Header(Top Face)]
        _TopStartColor            ("Top start color", Color) = (1,0,0,0)
        _TopMiddleColor           ("Top middle color", Color) = (0,1,0,0)
        _TopEndColor              ("Top end color", Color) = (0,0,1,0)
        _TopMiddleColorLength     ("Top middle color length", Float) = 0
        _TopGradientOffset        ("Top gradient offset", Float) = 0
        _TopGradientLength        ("Top gradient length", Range(1,100)) = 1
        _TopGradientAngle         ("Top gradient angle", Range(0,6.28)) = 0
        [Toggle(_TOPSOLID)]_TS    ("Top solid enabled", Int) = 0
        [Toggle(_TOPMIDDLE)]_TM   ("Top middle color enabled", Int) = 0 

        [Space]

        [Header(Bottom Face)]
        _BottomStartColor            ("Bottom start color", Color) = (1,0,0,0)
        _BottomMiddleColor           ("Bottom middle color", Color) = (0,1,0,0)
        _BottomEndColor              ("Bottom end color", Color) = (0,0,1,0)
        _BottomMiddleColorLength     ("Bottom middle color length", Float) = 0
        _BottomGradientOffset        ("Bottom gradient offset", Float) = 0
        _BottomGradientLength        ("Bottom gradient length", Range(1,100)) = 1
        _BottomGradientAngle         ("Bottom gradient angle", Range(0,6.28)) = 0
        [Toggle(_BOTTOMSOLID)]_BS    ("Bottom solid enabled", Int) = 0
        [Toggle(_BOTTOMMIDDLE)]_BM   ("Bottom middle color enabled", Int) = 0 

        [Space]

        [Header(Front Face)]
        _FrontStartColor            ("Front start color", Color) = (1,0,0,0)
        _FrontMiddleColor           ("Front middle color", Color) = (0,1,0,0)
        _FrontEndColor              ("Front end color", Color) = (0,0,1,0)
        _FrontMiddleColorLength     ("Front middle color length", Float) = 0
        _FrontGradientOffset        ("Front gradient offset", Float) = 0
        _FrontGradientLength        ("Front gradient length", Range(1,100)) = 1
        _FrontGradientAngle         ("Front gradient angle", Range(0,6.28)) = 0
        [Toggle(_FRONTSOLID)]_FS    ("Front solid enabled", Int) = 0
        [Toggle(_FRONTTMIDDLE)]_FM   ("Front middle color enabled", Int) = 0 

        [Space]

        [Header(Back Face)]
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

            #pragma shader_feature _LEFTSOLID
            #pragma shader_feature _LEFTMIDDLE

            #pragma shader_feature _TOPSOLID
            #pragma shader_feature _TOPMIDDLE

            #pragma shader_feature _BOTTOMSOLID
            #pragma shader_feature _BOTTOMMIDDLE

            #pragma shader_feature _FRONTSOLID
            #pragma shader_feature _FRONTMIDDLE

            #pragma shader_feature _BACKSOLID
            #pragma shader_feature _BACKMIDDLE

            #include "UnityCG.cginc"

            #include "GradientColor.cginc"

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


            InterpolatedData VertexShaderMain(VertexData vertexData)
            {
                InterpolatedData interpolatedData;
                interpolatedData.m_clipPosition = UnityObjectToClipPos(vertexData.m_position);

                interpolatedData.m_color    =   RightColor(vertexData.m_position, vertexData.m_normal)  +
                                                LeftColor(vertexData.m_position, vertexData.m_normal)   +
                                                TopColor(vertexData.m_position, vertexData.m_normal)    +
                                                BottomColor(vertexData.m_position, vertexData.m_normal) +
                                                FrontColor(vertexData.m_position, vertexData.m_normal)  +
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