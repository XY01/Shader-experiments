// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "Raymarching/Simple/Sphere Intersection"
{

	Properties
	{
		_MainTex ("Texture", 2D) = "white" {} 
		_Color("Colour", Color) = (1,1,1,1)
		_SpecularPower("Specular Power", Float) = 0
		_Gloss("Gloss", Float) = 0
		_MinimumLight("Minimum Light", Range(0,1)) = 0
		_Steps("_Steps", Int) = 32						//how many iterations (max) in raymarch
		_MinDistance("MinimumDistance", Float) = 0.01	//how close ray has to be to render a point

		_RimColor("Rim Colour", Color) = (1,1,1,1)		
		_RimPower("Rim Power", Float) = 0.1
		_Bias("Fresnel Bias", Float) = 0
		_Scale("Fresnel Scale", Float) = 1
		_Power("Fresnel Power", Float) = 1
		[MaterialToggle]_isClipped("Clip to Boundaries", Int) = 1 //TODO: MAKE THIS WORK
		[MaterialToggle] _isObjectSpace("Is Object Space", Int) = 1
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }
		LOD 100

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			// make fog work
			#pragma multi_compile_fog
			 
			#include "UnityCG.cginc"
			#include "Lighting.cginc"			
			#include "./Include/Primitives.cginc"
			#include "./Include/Utils.cginc"
			#include "./Include/Lighting_EXP.cginc" 
			#include "./Include/SDF_Operations.cginc" 

			#define STEP_SIZE 0.01

			float _MinDistance;
			fixed _Steps;
			fixed _SpecularPower;
			fixed _Gloss;
			fixed _MinimumLight;
			fixed4 _RimColour;
			fixed _RimPower;
			float _Bias;
			float _Power;
			float _Scale;
			float _isClipped;
			float _isObjectSpace;
			
			

			fixed4		_Color;
			sampler2D	_MainTex;
			float4		_MainTex_ST;
			
			// Structs
			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;				
				float4 vertex : SV_POSITION;
				float3 wPos : TEXCOORD1; //World position
				float3 lPos : TEXCOORD2; //Local position
			};

			//   ------------------------------------------  DISTANCE FUNCTION  -----------------------------------------------------------------------

			// Define the distance function for raymarching here
			float distanceFunction(float3 pos)
			{
				float dist = 0;
				
				//dist = min(Sphere(pos - float3 (.1, 0, 0), 0.2), Sphere(pos + float3 (.1, 0, 0), 0.2)); // min = union
				//dist = max(Sphere(pos - float3 (.1, 0, 0), 0.2), Sphere(pos + float3 (.1, 0, 0), 0.2)); // max = intersection

				
				float spheresRad = .1;
				float sinTimeNorm = (_SinTime[3] + 1.) / 2.;

				dist = HexagonalPrismX(pos, .1);

				// Pulsey spheres
				/*
				float yOffset = sinTimeNorm * spheresRad * 3;
				float sphereOffset = yOffset;
				
				float sphereBlend = .7;

				// blend test
				float centerSphere = Sphere(pos, .1);// opSmoothUnion(Sphere(pos - float3 (0, yOffset, 0), 0.2), Sphere(pos + float3 (0, yOffset, 0), 0.2), 24);
				float spheresY = opSmoothUnion(Sphere(pos - float3 (0, sphereOffset, 0), spheresRad), Sphere(pos + float3 (0, sphereOffset, 0), spheresRad), sphereBlend);
				float spheresX = opSmoothUnion(Sphere(pos - float3 (sphereOffset, 0, 0), spheresRad), Sphere(pos + float3 (sphereOffset, 0, 0), spheresRad), sphereBlend);
				float spheresZ = opSmoothUnion(Sphere(pos - float3 (0, 0, sphereOffset), spheresRad), Sphere(pos + float3 (0, 0, sphereOffset), spheresRad), sphereBlend);

				float spheresXYZ = opSmoothUnion(spheresX, spheresY, .05);
				spheresXYZ = opSmoothUnion(spheresXYZ, spheresZ,.05);

				dist = sdf_blend(centerSphere, spheresXYZ, 1-sinTimeNorm);
				*/
								
				return dist;
			}

			//   ------------------------------------------  RAYMARCHING, NORMAL AND LIGHTING  -----------------------------------------------------------------------
			// Get normal by sampling along x y and z. Won't return real normal for rough surfaces
			float3 volumeNormal(float3 p)
			{
				const float eps = 0.01;
				float3 normal = normalize
				(
					float3
					(
						distanceFunction(p + float3(eps, 0, 0)) - distanceFunction(p - float3(eps, 0, 0)),
						distanceFunction(p + float3(0, eps, 0)) - distanceFunction(p - float3(0, eps, 0)),
						distanceFunction(p + float3(0, 0, eps)) - distanceFunction(p - float3(0, 0, eps))
					)
				);

				return normal;
			}
			
			// Gets the normal at a position then gets the lighting using the normal
			fixed4 getNormalAndLighting(float3 pos, float3 viewDirection)
			{
				// Get the voilumes normal at a position
				float3 normal = volumeNormal(pos);

				// return the lit colour at that position with the given normal
				return simpleLambert(normal, viewDirection, _SpecularPower, _Gloss, _Color, _MinimumLight, _Bias, _Scale, _Power);
			}

			// Raymarches until the distance function evaluates to less than min dist then gets the normal and lighting and returns a colour value
			fixed4 raymarch(float3 position, float3 direction)
			{
				for (int i = 0; i < _Steps; i++)
				{
					float distance = distanceFunction(position);

					// is the distance less than the min distance, if so then render the volume surface
					if (distance < _MinDistance)
					{
						return getNormalAndLighting(position, direction);
					}

					//assuming direction is normalized
					position += distance * direction;
				}
				discard;
				return fixed4(0, 0, 0, 0);
			}


			//   ------------------------------------------  VERT AND FRAGMENT  -----------------------------------------------------------------------
			v2f vert(appdata v)
			{
				v2f o;												// Create v2f struct				
				o.vertex = UnityObjectToClipPos(v.vertex);			// Set the vertex into object clip space				
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);				// Set the UVs 		
				o.wPos = mul(unity_ObjectToWorld, v.vertex).xyz;	// Set world pos				
				o.lPos = v.vertex;									// Set local pos

				return o;
			}

			fixed4 frag(v2f i) : SV_Target
			{				
				//raymarching
				float3 worldPosition = i.wPos;
				float3 localPosition = i.lPos;
				float3 viewDirection = normalize(i.wPos - _WorldSpaceCameraPos);

				float3 usedPosition = worldPosition;
				if (_isObjectSpace)
				{
					usedPosition = localPosition;
				}

				fixed4 color = raymarch(usedPosition, viewDirection);

				return color;
			}
			

			ENDCG
		}
	}
}
