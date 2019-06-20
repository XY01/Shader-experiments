#ifndef LIGHTING_EXP
#define LIGHTING_EXP

#include "UnityCG.cginc"
#include "Lighting.cginc"
#include "./Include/Primitives.cginc"
#include "./Include/Utils.cginc"

fixed4 simpleLambert(fixed3 normal, fixed3 viewDirection, fixed specPwr, float gloss, fixed4 color, fixed minLight, fixed bias, fixed scale, fixed power)
{
	//LIGHTING FLIPS FROM SOME ANGLES, ALAN ZUCCONI SAID THERE WAS A TYPO, CHECK PART 3.
	fixed3 lightDir = _WorldSpaceLightPos0.xyz;	// Light direction, NOT sure why I had to flip it, but it seems to be accurate when it's flipped :c
	fixed3 lightCol = _LightColor0.rgb;		// Light color

	fixed NdotL = max(dot(normal, lightDir), 0);
	fixed4 c;

	// Specular
	fixed3 h = (lightDir - viewDirection) / 2.;
	fixed spec = pow(dot(normal, h), specPwr) * gloss;

	//My addition, introduces minimum light - doesn't account for coloured light though.
	//lightCol = max(lightCol, _MinimumLight);

	//fixed3 lambertCol = _Color * lightCol * NdotL + s;

	fixed3 finalLight = lightCol + spec + UNITY_LIGHTMODEL_AMBIENT;
	fixed3 finalCol = color * finalLight * NdotL;

	fixed3 minimumCol = color * minLight;

	//rim lighting (doesn't work :c   dot(viewDirection, normal) always returns 0 for some reason... )
	//float3 normWorld = normalize(mul(float4x4(unity_ObjectToWorld), normal));
	//half rim = 1.0 - saturate(dot(lightDir, normWorld));
	//fixed3 rimCol = _RimColour.rgb * pow(rim, _RimPower);

	//basic fresnel instead, to serve as rim lighting. using the empirical approximation from NVidia CG guide and the simpler guide at http://kylehalladay.com/blog/tutorial/2014/02/18/Fresnel-Shaders-From-The-Ground-Up.html
	float3 I = viewDirection; //normalize(posWorld - _WorldSpaceCameraPos.xyz);
	float3 normWorld = normalize(mul(float4x4(unity_ObjectToWorld), normal));
	float R = bias + scale * pow(1.0 + dot(I, normWorld), power);

	c.rgb = max(finalCol, minimumCol);

	//apply fresnel effect
	c.rgb = lerp(c.rgb, color, R); //lerp towards the intrinsic colour of the object by R, the fresnel strength.

	c.a = 1;

	return c;
}

#endif
