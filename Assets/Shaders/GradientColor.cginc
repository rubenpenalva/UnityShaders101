// Author: Ruben Penalva ruben.penalva@rpenalva.com
// License: MIT License

#include "GradientCommon.cginc"

half4   _RightStartColor;
half4   _RightMiddleColor;
half4   _RightEndColor;
half    _RightMiddleColorLength;
half    _RightGradientOffset;
half    _RightGradientLength;
half    _RightGradientAngle;

half4   _LeftStartColor;
half4   _LeftMiddleColor;
half4   _LeftEndColor;
half    _LeftMiddleColorLength;
half    _LeftGradientOffset;
half    _LeftGradientLength;
half    _LeftGradientAngle;

half4   _TopStartColor;
half4   _TopMiddleColor;
half4   _TopEndColor;
half    _TopMiddleColorLength;
half    _TopGradientOffset;
half    _TopGradientLength;
half    _TopGradientAngle;

half4   _BottomStartColor;
half4   _BottomMiddleColor;
half4   _BottomEndColor;
half    _BottomMiddleColorLength;
half    _BottomGradientOffset;
half    _BottomGradientLength;
half    _BottomGradientAngle;

half4   _FrontStartColor;
half4   _FrontMiddleColor;
half4   _FrontEndColor;
half    _FrontMiddleColorLength;
half    _FrontGradientOffset;
half    _FrontGradientLength;
half    _FrontGradientAngle;

half4   _BackStartColor;
half4   _BackMiddleColor;
half4   _BackEndColor;
half    _BackMiddleColorLength;
half    _BackGradientOffset;
half    _BackGradientLength;
half    _BackGradientAngle;

static const half3 RIGHT_DIR    =   half3(1.0h, 0.0h, 0.0h);
static const half3 LEFT_DIR     =   half3(-1.0h, 0.0h, 0.0h);
static const half3 TOP_DIR      =   half3(0.0h, 1.0h, 0.0h);
static const half3 BOTTOM_DIR   =   half3(0.0h, -1.0h, 0.0h);
static const half3 FRONT_DIR    =   half3(0.0h, 0.0h, 1.0h);
static const half3 BACK_DIR     =   half3(0.0h, 0.0h, -1.0h);

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

half4 LeftColor(half4 position, half3 normal)
{
#if _LEFTSOLID
    const half4 color = _LeftStartColor;
#else
    const half2 gradientOffsetScale = half2(_LeftGradientOffset, _LeftGradientLength);

    #if _LEFTMIDDLE
    const half4 color = Gradient_2D(position.zy, _LeftStartColor, _LeftMiddleColor, _LeftEndColor,
                                    _LeftMiddleColorLength, gradientOffsetScale, _LeftGradientAngle);
    #else
    const half4 color = Gradient_2D(position.zy, _LeftStartColor, _LeftEndColor, gradientOffsetScale,
                                    _LeftGradientAngle);
    #endif // _LEFTMIDDLE
#endif // _LEFTSOLID

    return DirectionalColor(normal, LEFT_DIR, color);
}

half4 TopColor(half4 position, half3 normal)
{
#if _TOPSOLID
    const half4 color = _TopStartColor;
#else
    const half2 gradientOffsetScale = half2(_TopGradientOffset, _TopGradientLength);

    #if _TOPMIDDLE
    const half4 color = Gradient_2D(position.zy, _TopStartColor, _TopMiddleColor, _TopEndColor,
                                    _LeftMiddleColorLength, gradientOffsetScale, _TopGradientAngle);
    #else
    const half4 color = Gradient_2D(position.zy, _TopStartColor, _TopEndColor, gradientOffsetScale,
                                    _TopGradientAngle);
    #endif // _TOPMIDDLE
#endif // _TOPSOLID

    return DirectionalColor(normal, TOP_DIR, color);
}

half4 BottomColor(half4 position, half3 normal)
{
#if _BOTTOMSOLID
    const half4 color = _BottomStartColor;
#else
    const half2 gradientOffsetScale = half2(_BottomGradientOffset, _BottomGradientLength);

    #if _BOTTOMMIDDLE
    const half4 color = Gradient_2D(position.zy, _BottomStartColor, _BottomMiddleColor, _BottomEndColor,
                                    _LeftMiddleColorLength, gradientOffsetScale, _BottomGradientAngle);
    #else
    const half4 color = Gradient_2D(position.zy, _BottomStartColor, _BottomEndColor, gradientOffsetScale,
                                    _BottomGradientAngle);
    #endif // _BOTTOMMIDDLE
#endif // _BOTTOMSOLID

    return DirectionalColor(normal, BOTTOM_DIR, color);
}

half4 FrontColor(half4 position, half3 normal)
{
#if _FRONTSOLID
    const half4 color = _FrontStartColor;
#else
    const half2 gradientOffsetScale = half2(_FrontGradientOffset, _FrontGradientLength);

    #if _FRONTMIDDLE
    const half4 color = Gradient_2D(position.zy, _FrontStartColor, _FrontMiddleColor, _FrontEndColor,
                                    _LeftMiddleColorLength, gradientOffsetScale, _FrontGradientAngle);
    #else
    const half4 color = Gradient_2D(position.zy, _FrontStartColor, _FrontEndColor, gradientOffsetScale,
                                    _FrontGradientAngle);
    #endif // _FRONTMIDDLE
#endif // _FRONTSOLID

    return DirectionalColor(normal, FRONT_DIR, color);
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
