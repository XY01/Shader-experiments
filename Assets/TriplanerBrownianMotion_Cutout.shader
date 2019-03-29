// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "TriplanerBrownianMotion_Cutout"
{
	Properties
	{
		_TessPhongStrength( "Phong Tess Strength", Range( 0, 1 ) ) = 0.5
		_TimeScaler("Time Scaler", Float) = 0
		_Freq("Freq", Float) = 1
		_Offset("Offset", Float) = 4
		_Cutoff( "Mask Clip Value", Float ) = 0.9
		_TopoRingStart("TopoRingStart", Float) = 0.01
		_TopotRingRange("TopotRingRange", Float) = 0.01
		[HDR]_RingCol("RingCol", Color) = (0.9245283,0.04797081,0.04797081,0)
		[HDR]_TipCol("TipCol", Color) = (0.1609909,0.1564169,0.8962264,0)
		_Smoothness("Smoothness", Range( 0 , 1)) = 0.2
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "TransparentCutout"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Off
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#include "Tessellation.cginc"
		#pragma target 4.6
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows vertex:vertexDataFunc tessellate:tessFunction tessphong:_TessPhongStrength 
		struct Input
		{
			float3 worldPos;
		};

		uniform float _Freq;
		uniform float _TimeScaler;
		uniform float _Offset;
		uniform float _TopoRingStart;
		uniform float _TopotRingRange;
		uniform float4 _RingCol;
		uniform float4 _TipCol;
		uniform float _Smoothness;
		uniform float _Cutoff = 0.9;
		uniform float _TessPhongStrength;


		float FractalBrownianMotion( float frequency , float amplitude , float time , float x )
		{
			float y = sin(x * frequency);
			float t = 0.01*(-time*130.0);
			y += sin(x*frequency*2.1 + t)*4.5;
			y += sin(x*frequency*1.72 + t*1.121)*4.0;
			y += sin(x*frequency*2.221 + t*0.437)*5.0;
			y += sin(x*frequency*3.1122+ t*4.269)*2.5;
			y *= amplitude*0.06;
			return y;
		}


		float4 tessFunction( appdata_full v0, appdata_full v1, appdata_full v2 )
		{
			float4 temp_cast_2 = (12.0).xxxx;
			return temp_cast_2;
		}

		void vertexDataFunc( inout appdata_full v )
		{
			float frequency8 = _Freq;
			float amplitude8 = 1.0;
			float mulTime11 = _Time.y * _TimeScaler;
			float time8 = ( mulTime11 + 23.0 );
			float3 ase_worldPos = mul( unity_ObjectToWorld, v.vertex );
			float3 break38 = mul( float4( ase_worldPos , 0.0 ), unity_WorldToObject ).xyz;
			float x8 = break38.x;
			float localFractalBrownianMotion8 = FractalBrownianMotion( frequency8 , amplitude8 , time8 , x8 );
			float frequency22 = _Freq;
			float amplitude22 = 1.0;
			float time22 = ( mulTime11 + 2.0 );
			float x22 = break38.y;
			float localFractalBrownianMotion22 = FractalBrownianMotion( frequency22 , amplitude22 , time22 , x22 );
			float frequency23 = _Freq;
			float amplitude23 = 1.0;
			float time23 = ( mulTime11 + -72.0 );
			float x23 = break38.z;
			float localFractalBrownianMotion23 = FractalBrownianMotion( frequency23 , amplitude23 , time23 , x23 );
			float3 ase_vertexNormal = v.normal.xyz;
			float3 temp_output_14_0 = ( ( 1.0 - abs( ( ( localFractalBrownianMotion8 + localFractalBrownianMotion22 + localFractalBrownianMotion23 ) / 3.0 ) ) ) * _Offset * ase_vertexNormal );
			v.vertex.xyz += temp_output_14_0;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float4 color16 = IsGammaSpace() ? float4(0.1886792,0.1886792,0.1886792,0) : float4(0.02968647,0.02968647,0.02968647,0);
			o.Albedo = color16.rgb;
			float frequency8 = _Freq;
			float amplitude8 = 1.0;
			float mulTime11 = _Time.y * _TimeScaler;
			float time8 = ( mulTime11 + 23.0 );
			float3 ase_worldPos = i.worldPos;
			float3 break38 = mul( float4( ase_worldPos , 0.0 ), unity_WorldToObject ).xyz;
			float x8 = break38.x;
			float localFractalBrownianMotion8 = FractalBrownianMotion( frequency8 , amplitude8 , time8 , x8 );
			float frequency22 = _Freq;
			float amplitude22 = 1.0;
			float time22 = ( mulTime11 + 2.0 );
			float x22 = break38.y;
			float localFractalBrownianMotion22 = FractalBrownianMotion( frequency22 , amplitude22 , time22 , x22 );
			float frequency23 = _Freq;
			float amplitude23 = 1.0;
			float time23 = ( mulTime11 + -72.0 );
			float x23 = break38.z;
			float localFractalBrownianMotion23 = FractalBrownianMotion( frequency23 , amplitude23 , time23 , x23 );
			float temp_output_3_0_g3 = ( ( 1.0 - abs( ( ( localFractalBrownianMotion8 + localFractalBrownianMotion22 + localFractalBrownianMotion23 ) / 3.0 ) ) ) - ( _TopoRingStart + _TopotRingRange ) );
			float temp_output_3_0_g4 = ( _TopoRingStart - ( 1.0 - abs( ( ( localFractalBrownianMotion8 + localFractalBrownianMotion22 + localFractalBrownianMotion23 ) / 3.0 ) ) ) );
			float temp_output_71_0 = saturate( ( ( 1.0 - saturate( saturate( ( temp_output_3_0_g3 / fwidth( temp_output_3_0_g3 ) ) ) ) ) - saturate( saturate( ( temp_output_3_0_g4 / fwidth( temp_output_3_0_g4 ) ) ) ) ) );
			float temp_output_51_0 = saturate( ( 1.0 - abs( ( ( localFractalBrownianMotion8 + localFractalBrownianMotion22 + localFractalBrownianMotion23 ) / 3.0 ) ) ) );
			o.Emission = ( ( temp_output_71_0 * _RingCol ) + ( _TipCol * temp_output_51_0 ) ).rgb;
			float smoothstepResult58 = smoothstep( 0.9 , 0.95 , ( 1.0 - temp_output_51_0 ));
			o.Metallic = smoothstepResult58;
			o.Smoothness = _Smoothness;
			o.Alpha = 1;
			clip( ( temp_output_71_0 + ( 1.0 - abs( ( ( localFractalBrownianMotion8 + localFractalBrownianMotion22 + localFractalBrownianMotion23 ) / 3.0 ) ) ) ) - _Cutoff );
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=16301
2121;212;1906;1172;-291.0259;646.5225;1;True;True
Node;AmplifyShaderEditor.WorldPosInputsNode;9;-2792.667,677.7941;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;90;-3104,144;Float;False;Property;_TimeScaler;Time Scaler;0;0;Create;True;0;0;False;0;0;0.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldToObjectMatrix;34;-2776.667,821.794;Float;False;0;1;FLOAT4x4;0
Node;AmplifyShaderEditor.SimpleTimeNode;11;-2909.27,154.6942;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;43;-2621.669,-38.80549;Float;False;Constant;_Float3;Float 3;3;0;Create;True;0;0;False;0;23;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;35;-2488.668,741.794;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT4x4;0,0,0,0,0,1,0,0,0,0,1,0,0,0,0,1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;46;-2621.669,281.1945;Float;False;Constant;_Float5;Float 5;3;0;Create;True;0;0;False;0;-72;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;45;-2621.669,121.1945;Float;False;Constant;_Float4;Float 4;3;0;Create;True;0;0;False;0;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;47;-2621.669,345.1945;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;38;-2344.668,741.794;Float;False;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SimpleAddOpNode;44;-2621.669,185.1945;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;18;-2218.169,-115.0055;Float;False;Constant;_Float0;Float 0;2;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;19;-2218.169,-211.0056;Float;False;Property;_Freq;Freq;1;0;Create;True;0;0;False;0;1;3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;42;-2621.669,25.19454;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CustomExpressionNode;22;-1936.87,146.5945;Float;False;float y = sin(x * frequency)@$float t = 0.01*(-time*130.0)@$y += sin(x*frequency*2.1 + t)*4.5@$y += sin(x*frequency*1.72 + t*1.121)*4.0@$y += sin(x*frequency*2.221 + t*0.437)*5.0@$y += sin(x*frequency*3.1122+ t*4.269)*2.5@$y *= amplitude*0.06@$return y@;1;False;4;True;frequency;FLOAT;0;In;;Float;True;amplitude;FLOAT;0;In;;Float;True;time;FLOAT;0;In;;Float;True;x;FLOAT;0;In;;Float;FractalBrownianMotion;False;False;0;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;40;-1469.656,-257.3284;Float;False;340;233;Blobby;3;28;29;27;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CustomExpressionNode;8;-1936.87,-13.40549;Float;False;float y = sin(x * frequency)@$float t = 0.01*(-time*130.0)@$y += sin(x*frequency*2.1 + t)*4.5@$y += sin(x*frequency*1.72 + t*1.121)*4.0@$y += sin(x*frequency*2.221 + t*0.437)*5.0@$y += sin(x*frequency*3.1122+ t*4.269)*2.5@$y *= amplitude*0.06@$return y@;1;False;4;True;frequency;FLOAT;0;In;;Float;True;amplitude;FLOAT;0;In;;Float;True;time;FLOAT;0;In;;Float;True;x;FLOAT;0;In;;Float;FractalBrownianMotion;False;False;0;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CustomExpressionNode;23;-1936.87,306.5945;Float;False;float y = sin(x * frequency)@$float t = 0.01*(-time*130.0)@$y += sin(x*frequency*2.1 + t)*4.5@$y += sin(x*frequency*1.72 + t*1.121)*4.0@$y += sin(x*frequency*2.221 + t*0.437)*5.0@$y += sin(x*frequency*3.1122+ t*4.269)*2.5@$y *= amplitude*0.06@$return y@;1;False;4;True;frequency;FLOAT;0;In;;Float;True;amplitude;FLOAT;0;In;;Float;True;time;FLOAT;0;In;;Float;True;x;FLOAT;0;In;;Float;FractalBrownianMotion;False;False;0;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;29;-1455.001,-99.50002;Float;False;Constant;_Float1;Float 1;3;0;Create;True;0;0;False;0;3;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;27;-1454.001,-221.5;Float;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;84;-1054.167,-151.092;Float;False;137.7001;126;Vally;1;80;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;28;-1287.001,-186.5;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;72;-398.097,-1222.85;Float;False;1386.087;544.3693;Topo rings;12;77;76;71;66;67;70;68;61;64;73;65;62;;1,1,1,1;0;0
Node;AmplifyShaderEditor.AbsOpNode;80;-1041.494,-103.5883;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;85;-882.5659,-149.792;Float;False;188.4;123.4;Peak;1;83;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;65;-383.7098,-927.8903;Float;False;Property;_TopotRingRange;TopotRingRange;5;0;Create;True;0;0;False;0;0.01;0.31;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;62;-367.7098,-1167.891;Float;False;Property;_TopoRingStart;TopoRingStart;4;0;Create;True;0;0;False;0;0.01;0.39;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;83;-859.6942,-103.4884;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;73;-159.7096,-1023.89;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RelayNode;82;-613.7949,-112.9884;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;64;-28.43467,-933.7131;Float;True;Step Antialiasing;-1;;3;2a825e80dfb3290468194f83380797bd;0;2;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;61;-32.83902,-1156.714;Float;True;Step Antialiasing;-1;;4;2a825e80dfb3290468194f83380797bd;0;2;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;68;192.5662,-931.1132;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;67;184.7663,-1135.214;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;70;349.866,-931.1133;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;66;507.165,-1078.014;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;74;-81.97444,-6.081673;Float;False;499.0407;336.698;Metallic;4;55;59;58;60;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SaturateNode;71;648.4481,-1073.795;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;51;-87.81297,-257.6257;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;76;526.2946,-897.3325;Float;False;Property;_RingCol;RingCol;6;1;[HDR];Create;True;0;0;False;0;0.9245283,0.04797081,0.04797081,0;0.608393,0.608393,0.608393,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;79;-139.2209,-453.6438;Float;False;Property;_TipCol;TipCol;7;1;[HDR];Create;True;0;0;False;0;0.1609909,0.1564169,0.8962264,0;0.09513278,0.08781487,0.8891256,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;77;806.4478,-999.7084;Float;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;55;-20.93363,51.91833;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;39;-1381.656,420.6717;Float;False;210;199;Ribbony wavey effect;1;25;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;60;-31.97445,215.6164;Float;False;Constant;_Max;Max;5;0;Create;True;0;0;False;0;0.95;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;52;381.2072,-318.7013;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;17;-612.897,348.1086;Float;False;Property;_Offset;Offset;2;0;Create;True;0;0;False;0;4;-0.3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;59;-25.93362,125.9183;Float;False;Constant;_Float7;Float 7;5;0;Create;True;0;0;False;0;0.9;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.NormalVertexDataNode;13;-615.7978,431.5084;Float;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;14;-355.4973,348.3086;Float;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ColorNode;16;1157.02,-322.0051;Float;False;Constant;_BaseCol;BaseCol;6;0;Create;True;0;0;False;0;0.1886792,0.1886792,0.1886792,0;0.2735848,0.2735848,0.2735848,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;21;1040.763,630.4206;Float;False;Constant;_Float2;Float 2;2;0;Create;True;0;0;False;0;12;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;25;-1362.362,470.9227;Float;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;96;734.9427,-71.45465;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;48;-178.7717,514.996;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;78;846.226,-285.4855;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;56;6.291382,431.9546;Float;False;Property;_Smoothness;Smoothness;8;0;Create;True;0;0;False;0;0.2;0.282;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;49;-375.0716,586.4953;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;58;217.0663,43.91833;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;97;564.3253,-101.717;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1051.988,49.75165;Float;False;True;6;Float;ASEMaterialInspector;0;0;Standard;TriplanerBrownianMotion_Cutout;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.9;True;True;0;True;TransparentCutout;;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;True;2;15;10;25;True;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;3;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;11;0;90;0
WireConnection;35;0;9;0
WireConnection;35;1;34;0
WireConnection;47;0;11;0
WireConnection;47;1;46;0
WireConnection;38;0;35;0
WireConnection;44;0;11;0
WireConnection;44;1;45;0
WireConnection;42;0;11;0
WireConnection;42;1;43;0
WireConnection;22;0;19;0
WireConnection;22;1;18;0
WireConnection;22;2;44;0
WireConnection;22;3;38;1
WireConnection;8;0;19;0
WireConnection;8;1;18;0
WireConnection;8;2;42;0
WireConnection;8;3;38;0
WireConnection;23;0;19;0
WireConnection;23;1;18;0
WireConnection;23;2;47;0
WireConnection;23;3;38;2
WireConnection;27;0;8;0
WireConnection;27;1;22;0
WireConnection;27;2;23;0
WireConnection;28;0;27;0
WireConnection;28;1;29;0
WireConnection;80;0;28;0
WireConnection;83;0;80;0
WireConnection;73;0;62;0
WireConnection;73;1;65;0
WireConnection;82;0;83;0
WireConnection;64;1;73;0
WireConnection;64;2;82;0
WireConnection;61;1;82;0
WireConnection;61;2;62;0
WireConnection;68;0;64;0
WireConnection;67;0;61;0
WireConnection;70;0;68;0
WireConnection;66;0;70;0
WireConnection;66;1;67;0
WireConnection;71;0;66;0
WireConnection;51;0;82;0
WireConnection;77;0;71;0
WireConnection;77;1;76;0
WireConnection;55;0;51;0
WireConnection;52;0;79;0
WireConnection;52;1;51;0
WireConnection;14;0;82;0
WireConnection;14;1;17;0
WireConnection;14;2;13;0
WireConnection;25;0;8;0
WireConnection;25;1;22;0
WireConnection;25;2;23;0
WireConnection;96;0;51;0
WireConnection;96;1;71;0
WireConnection;48;0;14;0
WireConnection;48;1;49;0
WireConnection;78;0;77;0
WireConnection;78;1;52;0
WireConnection;49;0;82;0
WireConnection;49;1;17;0
WireConnection;58;0;55;0
WireConnection;58;1;59;0
WireConnection;58;2;60;0
WireConnection;97;0;71;0
WireConnection;97;1;82;0
WireConnection;0;0;16;0
WireConnection;0;2;78;0
WireConnection;0;3;58;0
WireConnection;0;4;56;0
WireConnection;0;10;97;0
WireConnection;0;11;14;0
WireConnection;0;14;21;0
ASEEND*/
//CHKSM=AFDBC32392B5BE65E3FD118AA63BE111ED792C14