// Author: Ruben Penalva ruben.penalva@rpenalva.com
// License: MIT License

// ShaderLab shader
// https://docs.unity3d.com/Manual/SL-ShaderPrograms.html
// https://docs.unity3d.com/Manual/SL-Shader.html
Shader "Shaders101/GradientSkyShader"
{
    // https://docs.unity3d.com/Manual/SL-Properties.html
    Properties
    {
        _StartColor ("Start color", Color) = (1,0,0,0)
        _EndColor ("End color", Color) = (0,0,1,0)
        _GradientDirection("Gradient direction", Vector) = (0,1,0)

        [Space]

        // https://docs.unity3d.com/ScriptReference/MaterialPropertyDrawer.html
        // https://docs.unity3d.com/Manual/SL-CustomShaderGUI.html
        [Toggle(MIDDLE_COLOR_ENABLED)] _MiddleColorEnable ("Enable middle color", Int) = 0
        _MiddleSectionLength("Middle color length", Range(0,1)) = 0
        _MiddleColor("Middle color", Color) = (0,1,0,0)
    }

    // https://docs.unity3d.com/Manual/SL-SubShader.html
    SubShader
    {
        // Queue Background:    The mesh rendered with this subshader will be pushed to the background queue.
        //                      This tells unity to render the geometry first.
        // PreviewType Skybox:  Tells unity to use the skybox preview
        // https://docs.unity3d.com/Manual/SL-SubShaderTags.html
        Tags { "Queue" = "Background" "PreviewType" = "Skybox" }

        Pass
        {
            // Depth writting is disable: The skybox will always be rendered as the farthest object in the world. 
            // Culling is disable: Skybox geometry is always facing in.
            // https://docs.unity3d.com/Manual/SL-CullAndDepth.html
            ZWrite Off Cull Off

            CGPROGRAM
            #pragma vertex VertexMain
            #pragma fragment FragmentMain

            // https://docs.unity3d.com/Manual/SL-MultipleProgramVariants.html
            #pragma shader_feature MIDDLE_COLOR_ENABLED

            // https://docs.unity3d.com/Manual/SL-BuiltinIncludes.html
            #include "UnityCG.cginc"

            // GradientCommon.cginc holds common gradient code used by different shaders
            #include "GradientCommon.cginc"

            // half4 is a 16bit precision float
            //  https://docs.unity3d.com/Manual/SL-ShaderPerformance.html
            //  https://docs.unity3d.com/Manual/SL-DataTypesAndPrecision.html
            // SV_POSITION and COLOR are semantics
            // https://docs.unity3d.com/Manual/SL-ShaderSemantics.html
            struct InterpolatedData
            {
                half4 m_clipPosition : SV_POSITION;
                half4 m_color : COLOR;
            };

            // Uniforms. Data that change per shader. This means every vertex and fragment shader execution
            // will have the same values in these variables
            half4 _StartColor;
            half4 _MiddleColor;
            half4 _EndColor;
            half _MiddleSectionLength;
            half3 _GradientDirection;

            half4 SkyColor(float4 position)
            {
                const half3 normal = normalize(position.xyz);

                // NOTE: _GradientDirection normalization should be done in a custom editor
                // Ive decided against implement it to not add complexity. This might be
                // revisited in the future.
                const half3 gradientDirection = normalize(_GradientDirection);

                const half gradientLerp = GradientLerp_Hemispherical(normal, gradientDirection);

            #if MIDDLE_COLOR_ENABLED
                return Gradient(_StartColor, _MiddleColor, _EndColor, _MiddleSectionLength, gradientLerp);
            #else
                return Gradient(_StartColor, _EndColor, gradientLerp);
            #endif
            }

            InterpolatedData VertexMain(float4 vertexPosition : POSITION)
            {
                InterpolatedData outData;
                
                // UnityObjectToClipPos is a helper function that transforms
                // a vertex from object space to clip space
                // https://docs.unity3d.com/Manual/SL-BuiltinFunctions.html
                outData.m_clipPosition = UnityObjectToClipPos(vertexPosition);

                outData.m_color = SkyColor(vertexPosition);

                return outData;
            }
            
            float4 FragmentMain(InterpolatedData inData) : SV_Target
            {
                return inData.m_color;
            }

            ENDCG
        }
    }
}
