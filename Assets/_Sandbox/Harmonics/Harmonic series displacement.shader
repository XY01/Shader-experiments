
Shader "HarmonicSeriesDisplacement"
{
	Properties
	{
		_Harmonics("Harmonics", Int) = 3
		_Offset("Offset", float) = 1
		_Iterations("Iterations", float) = 1
		_Tesselation("Tesselation", float) = 10

		_ColorLow("Colour Low", Color) = (0,0,0,1)
		_ColorHigh("Colour High", Color) = (1,1,1,1)

		_Glossiness("Gloss", float) = 1
		_Metallic("Metallic", float) = 1

	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Off
		CGPROGRAM
		#include "Tessellation.cginc"
		#pragma target 4.6
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows vertex:vertexDataFunc tessellate:tessFunction 
		
		struct Input
		{
			float2 uv_texcoord;
			float3 viewDir; 
			float3 worldNormal;
		};

		half _Glossiness;
		half _Metallic;

		float _Tesselation;
		float4 tessFunction( appdata_full v0, appdata_full v1, appdata_full v2 )
		{
			return _Tesselation;
		}

		int _Harmonics;
		float _Iterations;

		float harmonic(float2 uv, int notes)
		{
			float harmonicValue = 0;
			float steppingStart = 0;
			float steppingDistance = 1.0/(float)notes;
			for (int i = 1; i <= notes; i++)
			{
				float sinNote = sin(uv.y * UNITY_PI * 2 * i)/i;
				float smoothMask = smoothstep(steppingStart, steppingStart + steppingDistance, uv.x);
				
				harmonicValue += sinNote * smoothMask;
				steppingStart += steppingDistance;
			}

			return harmonicValue / notes;
		}

		float _Offset;
		fixed4 _ColorLow;
		fixed4 _ColorHigh;
		void vertexDataFunc( inout appdata_full v )
		{
			float2 scaledUV = v.texcoord.xy;
			scaledUV.x *= 2;
			if (scaledUV.x > 1)
			{
				scaledUV.x = 2 - scaledUV.x;
			}

			scaledUV.y *= _Iterations;
			

			float offset = harmonic(scaledUV, _Harmonics);
			v.vertex.xyz += (offset * _Offset * v.normal.xyz);
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 scaledUV = i.uv_texcoord.xy;
			scaledUV.x *= 2;
			if (scaledUV.x > 1)
			{
				scaledUV.x = 2 - scaledUV.x;
			}

			scaledUV.y *= _Iterations;

			float fresnel = 1-saturate((dot(normalize(i.viewDir.xyz), normalize(i.worldNormal.xyz))) * 10);

			o.Smoothness = .2;
			o.Metallic = _Metallic;
			o.Albedo = lerp(_ColorLow, _ColorHigh, harmonic(scaledUV, _Harmonics));// +(fresnel * 3);
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}