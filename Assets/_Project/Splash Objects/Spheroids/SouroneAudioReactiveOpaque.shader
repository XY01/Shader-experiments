// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "SouroneAudioReactiveOpaque"
{
	Properties
	{
		_OffsetTex("OffsetTex", 2D) = "white" {}
		_MainCol("MainCol", Color) = (0,0,0,0)
		_VertCount("VertCount", Float) = 1000
		_StepCutoff("StepCutoff", Range( -0.1 , 1)) = 1.05
		_VertOffset("VertOffset", Float) = 0
		[HDR]_EmissionCol("EmissionCol", Color) = (0,0,0,0)
		_Contrastcontrol("Contrast control", Range( 0 , 1)) = 0.6588235
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Off
		CGINCLUDE
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0

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
			uint ase_vertexId;
			float3 worldNormal;
		};

		uniform float _VertOffset;
		uniform sampler2D _OffsetTex;
		uniform float _Contrastcontrol;
		uniform float4 _MainCol;
		uniform float _StepCutoff;
		uniform float _VertCount;
		uniform float4 _EmissionCol;

		void vertexDataFunc( inout appdata_full_custom v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float3 ase_vertexNormal = v.normal.xyz;
			float4 appendResult21 = (float4(ase_vertexNormal.x , 0.0 , 0.0 , 0.0));
			float4 tex2DNode1 = tex2Dlod( _OffsetTex, float4( appendResult21.xy, 0, 0.0) );
			v.vertex.xyz += ( ase_vertexNormal * _VertOffset * (0.0 + (tex2DNode1.r - 0.0) * (1.0 - 0.0) / (_Contrastcontrol - 0.0)) );
			o.ase_vertexId = v.ase_vertexId;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float temp_output_5_0 = ( i.ase_vertexId / _VertCount );
			float temp_output_3_0_g1 = ( _StepCutoff - temp_output_5_0 );
			float temp_output_8_0 = saturate( ( temp_output_3_0_g1 / fwidth( temp_output_3_0_g1 ) ) );
			o.Albedo = ( _MainCol * temp_output_8_0 ).rgb;
			float ifLocalVar29 = 0;
			if( _StepCutoff >= 1.0 )
				ifLocalVar29 = 0.0;
			else
				ifLocalVar29 = ( 1.0 - temp_output_8_0 );
			float3 ase_worldNormal = i.worldNormal;
			float3 ase_vertexNormal = mul( unity_WorldToObject, float4( ase_worldNormal, 0 ) );
			float4 appendResult21 = (float4(ase_vertexNormal.x , 0.0 , 0.0 , 0.0));
			float4 tex2DNode1 = tex2D( _OffsetTex, appendResult21.xy );
			o.Emission = ( ifLocalVar29 * _EmissionCol * tex2DNode1.r ).rgb;
			o.Alpha = 1;
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
				float3 worldPos : TEXCOORD2;
				float3 worldNormal : TEXCOORD3;
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
				o.worldNormal = worldNormal;
				o.customPack1.x = customInputData.ase_vertexId;
				o.worldPos = worldPos;
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
				float3 worldPos = IN.worldPos;
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldNormal = IN.worldNormal;
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
Version=16100
1162;164;1933;1207;-2.596558;-671.9186;1;True;True
Node;AmplifyShaderEditor.VertexIdVariableNode;3;-626.5,157;Float;False;0;1;INT;0
Node;AmplifyShaderEditor.RangedFloatNode;4;-633.5,246;Float;False;Property;_VertCount;VertCount;2;0;Create;True;0;0;False;0;1000;89000;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;9;-637.5,343;Float;False;Property;_StepCutoff;StepCutoff;3;0;Create;True;0;0;False;0;1.05;0.87;-0.1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;5;-427.5,184;Float;False;2;0;INT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;19;-205.5,44.13641;Float;False;284;323.8636;both interesting variations;2;8;11;;1,1,1,1;0;0
Node;AmplifyShaderEditor.NormalVertexDataNode;17;-127.2999,787.9985;Float;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;23;-115.5451,1115.626;Float;False;Constant;_Float1;Float 1;5;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;8;-155.5,235;Float;False;Step Antialiasing;-1;;1;2a825e80dfb3290468194f83380797bd;0;2;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;31;83.30528,379.0815;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;21;140.313,1120.006;Float;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SamplerNode;1;395.3408,994.4542;Float;True;Property;_OffsetTex;OffsetTex;0;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;37;760.4975,1130.277;Float;False;Constant;_Float4;Float 4;6;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;38;761.4975,1297.277;Float;False;Constant;_Float5;Float 5;6;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;32;470.576,209.2281;Float;False;Constant;_Float3;Float 3;6;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;33;366.0356,201.0992;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;14;468.4676,315.4444;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;39;659.4975,1210.277;Float;False;Property;_Contrastcontrol;Contrast control;6;0;Create;True;0;0;False;0;0.6588235;0.6588235;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;30;470.7017,127.6605;Float;False;Constant;_Float2;Float 2;6;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;15;413.0669,869.6852;Float;False;Property;_VertOffset;VertOffset;4;0;Create;True;0;0;False;0;0;0.17;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;26;176.7708,482.2299;Float;False;Property;_EmissionCol;EmissionCol;5;1;[HDR];Create;True;0;0;False;0;0,0,0,0;10.68063,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ConditionalIfNode;29;660.9469,161.5068;Float;False;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;2;-107.3226,-246.3925;Float;False;Property;_MainCol;MainCol;1;0;Create;True;0;0;False;0;0,0,0,0;0.1037735,0.1037735,0.1037735,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCRemapNode;36;1047.498,1114.277;Float;True;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;22;291.8895,18.40259;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;12;-516.0721,549.1364;Float;False;Constant;_Float0;Float 0;4;0;Create;True;0;0;False;0;0.1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;13;-312.0721,511.1364;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;18;685.0673,798.6852;Float;False;3;3;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SmoothstepOpNode;11;-143.0721,94.13641;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;27;905.7709,254.9216;Float;False;3;3;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1587.41,93.89021;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;SouroneAudioReactiveOpaque;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;5;0;3;0
WireConnection;5;1;4;0
WireConnection;8;1;5;0
WireConnection;8;2;9;0
WireConnection;31;0;9;0
WireConnection;21;0;17;1
WireConnection;21;1;23;0
WireConnection;1;1;21;0
WireConnection;33;0;31;0
WireConnection;14;0;8;0
WireConnection;29;0;33;0
WireConnection;29;1;30;0
WireConnection;29;2;32;0
WireConnection;29;3;32;0
WireConnection;29;4;14;0
WireConnection;36;0;1;1
WireConnection;36;1;37;0
WireConnection;36;2;39;0
WireConnection;36;3;37;0
WireConnection;36;4;38;0
WireConnection;22;0;2;0
WireConnection;22;1;8;0
WireConnection;13;0;9;0
WireConnection;13;1;12;0
WireConnection;18;0;17;0
WireConnection;18;1;15;0
WireConnection;18;2;36;0
WireConnection;11;0;5;0
WireConnection;11;1;9;0
WireConnection;11;2;13;0
WireConnection;27;0;29;0
WireConnection;27;1;26;0
WireConnection;27;2;1;1
WireConnection;0;0;22;0
WireConnection;0;2;27;0
WireConnection;0;11;18;0
ASEEND*/
//CHKSM=7FE33858400233EB425614AC1E52B3BF393C041B