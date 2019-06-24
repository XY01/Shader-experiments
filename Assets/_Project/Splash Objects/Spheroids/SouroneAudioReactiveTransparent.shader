// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "SouroneAudioReactiveTransparent"
{
	Properties
	{
		_OffsetTex("OffsetTex", 2D) = "white" {}
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		_MainCol("MainCol", Color) = (0,0,0,0)
		_VertCount("VertCount", Float) = 1000
		_StepCutoff("StepCutoff", Range( -0.1 , 1)) = 1.05
		_VertOffset_Min("VertOffset_Min", Float) = 0
		_VertOffset_Max("VertOffset_Max", Float) = 0.1
		[HDR]_EmissionCol("EmissionCol", Color) = (0,0,0,0)
		_Contrastcontrol("Contrast control", Range( 0 , 1)) = 0.6588235
		_Smoothness("Smoothness", Range( 0 , 1)) = 0
		_Metallic("Metallic", Range( 0 , 1)) = 0
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "TransparentCutout"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Off
		CGINCLUDE
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		#define ASE_TEXTURE_PARAMS(textureName) textureName

		#ifdef UNITY_PASS_SHADOWCASTER
			#undef INTERNAL_DATA
			#undef WorldReflectionVector
			#undef WorldNormalVector
			#define INTERNAL_DATA half3 internalSurfaceTtoW0; half3 internalSurfaceTtoW1; half3 internalSurfaceTtoW2;
			#define WorldReflectionVector(data,normal) reflect (data.worldRefl, half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal)))
			#define WorldNormalVector(data,normal) half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal))
		#endif

		struct appdata_full_custom
		{
			float4 vertex : POSITION;
			float4 tangent : TANGENT;
			float3 normal : NORMAL;
			float4 texcoord : TEXCOORD0;
			float4 texcoord1 : TEXCOORD1;
			float4 texcoord2 : TEXCOORD2;
			float4 texcoord3 : TEXCOORD3;
			fixed4 color : COLOR;
			UNITY_VERTEX_INPUT_INSTANCE_ID
			uint ase_vertexId : SV_VertexID;
		};
		struct Input
		{
			float3 worldPos;
			uint ase_vertexId;
			float3 worldNormal;
			INTERNAL_DATA
		};

		uniform float _VertOffset_Min;
		uniform float _VertOffset_Max;
		uniform sampler2D _OffsetTex;
		uniform float _Contrastcontrol;
		uniform float4 _MainCol;
		uniform float _StepCutoff;
		uniform float _VertCount;
		uniform float4 _EmissionCol;
		uniform float _Metallic;
		uniform float _Smoothness;
		uniform float _Cutoff = 0.5;


		inline float4 TriplanarSamplingSV( sampler2D topTexMap, float3 worldPos, float3 worldNormal, float falloff, float2 tiling, float3 normalScale, float3 index )
		{
			float3 projNormal = ( pow( abs( worldNormal ), falloff ) );
			projNormal /= ( projNormal.x + projNormal.y + projNormal.z ) + 0.00001;
			float3 nsign = sign( worldNormal );
			half4 xNorm; half4 yNorm; half4 zNorm;
			xNorm = ( tex2Dlod( ASE_TEXTURE_PARAMS( topTexMap ), float4( tiling * worldPos.zy * float2( nsign.x, 1.0 ), 0, 0 ) ) );
			yNorm = ( tex2Dlod( ASE_TEXTURE_PARAMS( topTexMap ), float4( tiling * worldPos.xz * float2( nsign.y, 1.0 ), 0, 0 ) ) );
			zNorm = ( tex2Dlod( ASE_TEXTURE_PARAMS( topTexMap ), float4( tiling * worldPos.xy * float2( -nsign.z, 1.0 ), 0, 0 ) ) );
			return xNorm * projNormal.x + yNorm * projNormal.y + zNorm * projNormal.z;
		}


		inline float4 TriplanarSamplingSF( sampler2D topTexMap, float3 worldPos, float3 worldNormal, float falloff, float2 tiling, float3 normalScale, float3 index )
		{
			float3 projNormal = ( pow( abs( worldNormal ), falloff ) );
			projNormal /= ( projNormal.x + projNormal.y + projNormal.z ) + 0.00001;
			float3 nsign = sign( worldNormal );
			half4 xNorm; half4 yNorm; half4 zNorm;
			xNorm = ( tex2D( ASE_TEXTURE_PARAMS( topTexMap ), tiling * worldPos.zy * float2( nsign.x, 1.0 ) ) );
			yNorm = ( tex2D( ASE_TEXTURE_PARAMS( topTexMap ), tiling * worldPos.xz * float2( nsign.y, 1.0 ) ) );
			zNorm = ( tex2D( ASE_TEXTURE_PARAMS( topTexMap ), tiling * worldPos.xy * float2( -nsign.z, 1.0 ) ) );
			return xNorm * projNormal.x + yNorm * projNormal.y + zNorm * projNormal.z;
		}


		void vertexDataFunc( inout appdata_full_custom v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float3 ase_vertexNormal = v.normal.xyz;
			float3 ase_worldPos = mul( unity_ObjectToWorld, v.vertex );
			float3 ase_worldNormal = UnityObjectToWorldNormal( v.normal );
			float4 triplanar46 = TriplanarSamplingSV( _OffsetTex, ase_worldPos, ase_worldNormal, 1.0, float2( 1,1 ), 1.0, 0 );
			float temp_output_36_0 = (0.0 + (triplanar46.x - 0.0) * (1.0 - 0.0) / (_Contrastcontrol - 0.0));
			float lerpResult40 = lerp( _VertOffset_Min , _VertOffset_Max , temp_output_36_0);
			v.vertex.xyz += ( ase_vertexNormal * lerpResult40 );
			o.ase_vertexId = v.ase_vertexId;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			o.Normal = float3(0,0,1);
			float temp_output_47_0 = ( 1.0 - _StepCutoff );
			float temp_output_5_0 = ( i.ase_vertexId / _VertCount );
			float temp_output_3_0_g1 = ( temp_output_47_0 - temp_output_5_0 );
			float temp_output_8_0 = saturate( ( temp_output_3_0_g1 / fwidth( temp_output_3_0_g1 ) ) );
			o.Albedo = ( _MainCol * ( 1.0 - temp_output_8_0 ) ).rgb;
			float ifLocalVar29 = 0;
			if( temp_output_47_0 >= 0.0 )
				ifLocalVar29 = 1.0;
			else
				ifLocalVar29 = ( 1.0 - temp_output_8_0 );
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldNormal = WorldNormalVector( i, float3( 0, 0, 1 ) );
			float4 triplanar46 = TriplanarSamplingSF( _OffsetTex, ase_worldPos, ase_worldNormal, 1.0, float2( 1,1 ), 1.0, 0 );
			float temp_output_36_0 = (0.0 + (triplanar46.x - 0.0) * (1.0 - 0.0) / (_Contrastcontrol - 0.0));
			o.Emission = ( ifLocalVar29 * _EmissionCol * temp_output_36_0 ).rgb;
			o.Metallic = _Metallic;
			o.Smoothness = _Smoothness;
			o.Alpha = 1;
			clip( ( 1.0 - temp_output_8_0 ) - _Cutoff );
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard keepalpha fullforwardshadows vertex:vertexDataFunc 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			#pragma multi_compile_shadowcaster
			#pragma multi_compile UNITY_PASS_SHADOWCASTER
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			#include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float1 customPack1 : TEXCOORD1;
				float4 tSpace0 : TEXCOORD2;
				float4 tSpace1 : TEXCOORD3;
				float4 tSpace2 : TEXCOORD4;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};
			v2f vert( appdata_full_custom v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				vertexDataFunc( v, customInputData );
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				half3 worldTangent = UnityObjectToWorldDir( v.tangent.xyz );
				half tangentSign = v.tangent.w * unity_WorldTransformParams.w;
				half3 worldBinormal = cross( worldNormal, worldTangent ) * tangentSign;
				o.tSpace0 = float4( worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x );
				o.tSpace1 = float4( worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y );
				o.tSpace2 = float4( worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z );
				o.customPack1.x = customInputData.ase_vertexId;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				return o;
			}
			half4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				surfIN.ase_vertexId = IN.customPack1.x;
				float3 worldPos = float3( IN.tSpace0.w, IN.tSpace1.w, IN.tSpace2.w );
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldPos = worldPos;
				surfIN.worldNormal = float3( IN.tSpace0.z, IN.tSpace1.z, IN.tSpace2.z );
				surfIN.internalSurfaceTtoW0 = IN.tSpace0.xyz;
				surfIN.internalSurfaceTtoW1 = IN.tSpace1.xyz;
				surfIN.internalSurfaceTtoW2 = IN.tSpace2.xyz;
				SurfaceOutputStandard o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandard, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=16700
268;1263;1906;1004;1252.735;209.4288;1;True;True
Node;AmplifyShaderEditor.VertexIdVariableNode;3;-653.5,72;Float;False;0;1;INT;0
Node;AmplifyShaderEditor.RangedFloatNode;9;-1009.5,358;Float;False;Property;_StepCutoff;StepCutoff;4;0;Create;True;0;0;False;0;1.05;1;-0.1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;4;-660.5,161;Float;False;Property;_VertCount;VertCount;3;0;Create;True;0;0;False;0;1000;3585;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;19;-205.5,44.13641;Float;False;284;323.8636;both interesting variations;2;8;11;;1,1,1,1;0;0
Node;AmplifyShaderEditor.OneMinusNode;47;-684.7355,446.5712;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;5;-454.5,99;Float;False;2;0;INT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;8;-151.504,224.0845;Float;False;Step Antialiasing;-1;;1;2a825e80dfb3290468194f83380797bd;0;2;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;38;274.567,1355.636;Float;False;Constant;_Float5;Float 5;6;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;39;172.567,1268.636;Float;False;Property;_Contrastcontrol;Contrast control;8;0;Create;True;0;0;False;0;0.6588235;0.72;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TriplanarNode;46;-97.90307,884.3372;Float;True;Spherical;World;False;OffsetTex;_OffsetTex;white;0;None;Mid Texture 0;_MidTexture0;white;-1;None;Bot Texture 0;_BotTexture0;white;-1;None;Triplanar Sampler;False;10;0;SAMPLER2D;;False;5;FLOAT;1;False;1;SAMPLER2D;;False;6;FLOAT;0;False;2;SAMPLER2D;;False;7;FLOAT;0;False;9;FLOAT3;0,0,0;False;8;FLOAT;1;False;3;FLOAT2;1,1;False;4;FLOAT;1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;37;273.567,1188.636;Float;False;Constant;_Float4;Float 4;6;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;31;83.30528,379.0815;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;15;683.4619,864.8878;Float;False;Property;_VertOffset_Min;VertOffset_Min;5;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;32;470.576,209.2281;Float;False;Constant;_Float3;Float 3;6;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;33;366.0356,201.0992;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;36;560.5674,1172.636;Float;True;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;30;470.7017,127.6605;Float;False;Constant;_Float2;Float 2;6;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;41;683.4619,944.8878;Float;False;Property;_VertOffset_Max;VertOffset_Max;6;0;Create;True;0;0;False;0;0.1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;14;468.4676,315.4444;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NormalVertexDataNode;17;-594.4999,762.3988;Float;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;2;-107.3226,-246.3925;Float;False;Property;_MainCol;MainCol;2;0;Create;True;0;0;False;0;0,0,0,0;0.2075472,0.2026522,0.2026522,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;40;931.4619,865.8878;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ConditionalIfNode;29;660.9469,161.5068;Float;False;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;26;660.7714,422.8296;Float;False;Property;_EmissionCol;EmissionCol;7;1;[HDR];Create;True;0;0;False;0;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;43;216.7887,30.46497;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;18;1127.944,781.2228;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;12;-516.0721,549.1364;Float;False;Constant;_Float0;Float 0;4;0;Create;True;0;0;False;0;0.1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;13;-312.0721,511.1364;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;45;1273.297,223.6223;Float;False;Property;_Metallic;Metallic;10;0;Create;True;0;0;False;0;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;27;981.7709,178.9216;Float;False;3;3;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;22;452.6049,-64.44028;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SmoothstepOpNode;11;-143.0721,94.13641;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;44;1281.297,300.6223;Float;False;Property;_Smoothness;Smoothness;9;0;Create;True;0;0;False;0;0;0.65;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;42;1164.334,414.6264;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1587.41,93.89021;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;SouroneAudioReactiveTransparent;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;True;0;True;TransparentCutout;;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;47;0;9;0
WireConnection;5;0;3;0
WireConnection;5;1;4;0
WireConnection;8;1;5;0
WireConnection;8;2;47;0
WireConnection;31;0;47;0
WireConnection;33;0;31;0
WireConnection;36;0;46;1
WireConnection;36;1;37;0
WireConnection;36;2;39;0
WireConnection;36;3;37;0
WireConnection;36;4;38;0
WireConnection;14;0;8;0
WireConnection;40;0;15;0
WireConnection;40;1;41;0
WireConnection;40;2;36;0
WireConnection;29;0;33;0
WireConnection;29;1;30;0
WireConnection;29;2;32;0
WireConnection;29;3;32;0
WireConnection;29;4;14;0
WireConnection;43;0;8;0
WireConnection;18;0;17;0
WireConnection;18;1;40;0
WireConnection;13;0;9;0
WireConnection;13;1;12;0
WireConnection;27;0;29;0
WireConnection;27;1;26;0
WireConnection;27;2;36;0
WireConnection;22;0;2;0
WireConnection;22;1;43;0
WireConnection;11;0;5;0
WireConnection;11;1;47;0
WireConnection;11;2;13;0
WireConnection;42;0;8;0
WireConnection;0;0;22;0
WireConnection;0;2;27;0
WireConnection;0;3;45;0
WireConnection;0;4;44;0
WireConnection;0;10;42;0
WireConnection;0;11;18;0
ASEEND*/
//CHKSM=A48931C0683CE20F113D30122B5813A893E44D55