// Author: Ruben Penalva ruben.penalva@rpenalva.com
// License: MIT License

struct GradientColor
{
    half4 m_startColor;
    half4 m_endColor;
    half3 m_direction;
};

static const half3 GRADIENT_UPDIR = half3(0.0h, 1.0h, 0.0h);

half GradientLerp_Hemispherical(half3 normal, half3 direction)
{
    return dot(normal, direction) * 0.5h + 0.5h;
}

// lerpFactor range [0,1]
half4 Gradient(half4 startColor, half4 endColor, half lerpFactor)
{
    return lerp(startColor, endColor, lerpFactor);
}

// middleSectionLength range [0,1]
// lerpFactor range [0,1]
half4 Gradient(half4 startColor, half4 middleColor, half4 endColor, half4 middleSectionLength, half lerpFactor)
{
    // Start Section: [0, startMiddleSection]
    const half startMiddleSection = (0.5h - middleSectionLength * 0.5h);

    // startSectionLerpFactor maps [0, startMiddleSection] to [0, >1]
    const half startSectionLerpFactor = (1.0f  / startMiddleSection) * lerpFactor;

    // startSectionColor will saturate when startSectionLerpFactor reaches one at the start
    // of the middle section. This means startSectionColor values bigger than 
    // startMiddleSection will get saturated to one
    const half4 startSectionColor = lerp(startColor, middleColor, startSectionLerpFactor);

    // End Section: [endMiddleSection, 1.0]
    const half endMiddleSection = (0.5h + middleSectionLength * 0.5h);

    // endSectionLerpFactor maps [endMiddleSection, 1.0] to [<0, one]
    const half endSectionLerpFactor = (lerpFactor - endMiddleSection) * (1.0f / (1.0f - endMiddleSection));

    return lerp(startSectionColor, endColor, endSectionLerpFactor);
}