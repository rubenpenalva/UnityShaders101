// Author: Ruben Penalva ruben.penalva@rpenalva.com
// License: MIT License

// returns a the dot product in [0,1] range 
half GradientLerpFactor_Dot01(half3 normal, half3 direction)
{
    return dot(normal, direction) * 0.5h + 0.5h;
}

// TODO: find a better name for position. maybe height? width?
half GradientLerpFactor_1D(half position, half2 gradientOffsetScale)
{
    return (position + gradientOffsetScale.x) / gradientOffsetScale.y;
}

// NOTE: sin(angle) and cos(angle) should be cached in a material editor script
// and send them as a parameter to the shader. Right now, it stays here to keep
// the complexity as low as possible. It might change in the future.
half GradientLerpFactor_2D(half2 position, half2 gradientOffsetScale, half angle)
{
    // NOTE: Check https://www.siggraph.org/education/materials/HyperGraph/modeling/mod_tran/2drota.htm
    const half positionRotated = position.y * cos(angle) + position.x * sin(angle);

    // Reusing existing code to reduce code duplication which reduces bugs, improves
    // readability and maintainability
    return GradientLerpFactor_1D(positionRotated, gradientOffsetScale);
}

// lerpFactor range [0,1]
half4 Gradient(half4 startColor, half4 endColor, half lerpFactor)
{
    return lerp(startColor, endColor, lerpFactor);
}

// middleSectionLength range [0,1]
// lerpFactor range [0,1]
half4 Gradient(half4 startColor, half4 middleColor, half4 endColor, half middleSectionLength, half lerpFactor)
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

half4 Gradient_2D(half2 position, half4 startColor, half4 endColor,
                  half2 gradientOffsetScale, half gradientAngle)
{
    const half lerpFactor = GradientLerpFactor_2D(position, gradientOffsetScale, gradientAngle);
    return Gradient(startColor, endColor, lerpFactor);
}

half4 Gradient_2D(half2 position, half4 startColor, half4 middleColor, half4 endColor,
                  half middleColorLength, half2 gradientOffsetScale, half gradientAngle)
{
    const half lerpFactor = GradientLerpFactor_2D(position, gradientOffsetScale, gradientAngle);
    return Gradient(startColor, middleColor, endColor, middleColorLength, lerpFactor);
}