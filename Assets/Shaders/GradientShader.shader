// Author: Ruben Penalva ruben.penalva@rpenalva.com
// License: MIT License

// ShaderLab shader
// https://docs.unity3d.com/Manual/SL-ShaderPrograms.html
// https://docs.unity3d.com/Manual/SL-Shader.html
Shader "Shaders101/GradientShader"
{

    Properties
    {
    }

    SubShader
    {
        Pass
        {
            CGPROGRAM

            #pragma vertex VertexShaderMain
            #pragma fragment FragmentShaderMain
            
            #include "UnityCG.cginc"

            struct VertexData
            {
                float4 m_position   :   POSITION;
            };

            struct InterpolatedData
            {
                float4 m_clipPosition : SV_POSITION;
            };

            InterpolatedData VertexShaderMain(VertexData vertexData)
            {
                InterpolatedData interpolatedData;
                interpolatedData.m_clipPosition = UnityObjectToClipPos(vertexData.m_position);

                return interpolatedData;
            }

            half4 FragmentShaderMain(InterpolatedData inData) : SV_TARGET
            {
                return half4(1.0h, 0.0h, 0.0h, 0.0h);
            }


            ENDCG
        }
    }
}