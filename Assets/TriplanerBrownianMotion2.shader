// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "TriplanerBrownianMotion2"
{
	Properties
	{
		_TessPhongStrength( "Phong Tess Strength", Range( 0, 1 ) ) = 0.5
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		_Color0("Color 0", Color) = (0,0,0,0)
		_NormalOffset("Normal Offset", Float) = 4
		_Freq("Freq", Float) = 1
		_Smoothness("Smoothness", Range( 0 , 1)) = 0.2
		_TopoRingStart("TopoRingStart", Float) = 0.01
		_TopotRingRange("TopotRingRange", Float) = 0.01
		[HDR]_TopoRingCol("TopoRingCol", Color) = (0.9245283,0.04797081,0.04797081,0)
		[HDR]_TipEmitCol("TipEmitCol", Color) = (0.1609909,0.1564169,0.8962264,0)
		_TimeScaler("Time Scaler", Float) = 0
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
		uniform float _NormalOffset;
		uniform float4 _Color0;
		uniform float _TopoRingStart;
		uniform float _TopotRingRange;
		uniform float4 _TopoRingCol;
		uniform float4 _TipEmitCol;
		uniform float _Smoothness;
		uniform float _Cutoff = 0.5;
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
			float4 temp_cast_2 = (20.0).xxxx;
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
			float temp_output_28_0 = ( ( localFractalBrownianMotion8 + localFractalBrownianMotion22 + localFractalBrownianMotion23 ) / 3.0 );
			float3 ase_vertexNormal = v.normal.xyz;
			float3 temp_output_14_0 = ( temp_output_28_0 * _NormalOffset * ase_vertexNormal );
			v.vertex.xyz += temp_output_14_0;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			o.Albedo = _Color0.rgb;
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
			float temp_output_28_0 = ( ( localFractalBrownianMotion8 + localFractalBrownianMotion22 + localFractalBrownianMotion23 ) / 3.0 );
			float temp_output_3_0_g3 = ( temp_output_28_0 - ( _TopoRingStart + _TopotRingRange ) );
			float temp_output_3_0_g4 = ( _TopoRingStart - temp_output_28_0 );
			float temp_output_51_0 = saturate( temp_output_28_0 );
			float4 temp_output_78_0 = ( ( saturate( ( ( 1.0 - saturate( saturate( ( temp_output_3_0_g3 / fwidth( temp_output_3_0_g3 ) ) ) ) ) - saturate( saturate( ( temp_output_3_0_g4 / fwidth( temp_output_3_0_g4 ) ) ) ) ) ) * _TopoRingCol ) + ( _TipEmitCol * temp_output_51_0 ) );
			o.Emission = temp_output_78_0.rgb;
			float smoothstepResult58 = smoothstep( 0.9 , 0.95 , ( 1.0 - temp_output_51_0 ));
			o.Metallic = smoothstepResult58;
			o.Smoothness = _Smoothness;
			o.Alpha = 1;
			float temp_output_93_1 = temp_output_78_0.g;
			clip( temp_output_93_1 - _Cutoff );
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=16301
478;82;1945;1289;4745.017;345.7664;1;True;True
Node;AmplifyShaderEditor.WorldPosInputsNode;9;-3588.075,677.7941;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;100;-3957.017,186.2336;Float;False;Property;_TimeScaler;Time Scaler;9;0;Create;True;0;0;False;0;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldToObjectMatrix;34;-3572.075,821.794;Float;False;0;1;FLOAT4x4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;35;-3284.076,741.794;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT4x4;0,0,0,0,0,1,0,0,0,0,1,0,0,0,0,1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;46;-3417.077,281.1945;Float;False;Constant;_Float5;Float 5;3;0;Create;True;0;0;False;0;-72;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;45;-3417.077,121.1945;Float;False;Constant;_Float4;Float 4;3;0;Create;True;0;0;False;0;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;43;-3417.077,-38.80549;Float;False;Constant;_Float3;Float 3;3;0;Create;True;0;0;False;0;23;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;11;-3704.678,154.6942;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;44;-3417.077,185.1945;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;47;-3417.077,345.1945;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;38;-3140.076,741.794;Float;False;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.RangedFloatNode;18;-3013.577,-115.0055;Float;False;Constant;_Float0;Float 0;2;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;19;-3013.577,-211.0056;Float;False;Property;_Freq;Freq;3;0;Create;True;0;0;False;0;1;6;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;42;-3417.077,25.19454;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;40;-2265.066,-257.3284;Float;False;340;233;Blobby;3;28;29;27;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CustomExpressionNode;23;-2732.278,306.5945;Float;False;float y = sin(x * frequency)@$float t = 0.01*(-time*130.0)@$y += sin(x*frequency*2.1 + t)*4.5@$y += sin(x*frequency*1.72 + t*1.121)*4.0@$y += sin(x*frequency*2.221 + t*0.437)*5.0@$y += sin(x*frequency*3.1122+ t*4.269)*2.5@$y *= amplitude*0.06@$return y@;1;False;4;True;frequency;FLOAT;0;In;;Float;True;amplitude;FLOAT;0;In;;Float;True;time;FLOAT;0;In;;Float;True;x;FLOAT;0;In;;Float;FractalBrownianMotion;False;False;0;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CustomExpressionNode;22;-2732.278,146.5945;Float;False;float y = sin(x * frequency)@$float t = 0.01*(-time*130.0)@$y += sin(x*frequency*2.1 + t)*4.5@$y += sin(x*frequency*1.72 + t*1.121)*4.0@$y += sin(x*frequency*2.221 + t*0.437)*5.0@$y += sin(x*frequency*3.1122+ t*4.269)*2.5@$y *= amplitude*0.06@$return y@;1;False;4;True;frequency;FLOAT;0;In;;Float;True;amplitude;FLOAT;0;In;;Float;True;time;FLOAT;0;In;;Float;True;x;FLOAT;0;In;;Float;FractalBrownianMotion;False;False;0;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CustomExpressionNode;8;-2732.278,-13.40549;Float;False;float y = sin(x * frequency)@$float t = 0.01*(-time*130.0)@$y += sin(x*frequency*2.1 + t)*4.5@$y += sin(x*frequency*1.72 + t*1.121)*4.0@$y += sin(x*frequency*2.221 + t*0.437)*5.0@$y += sin(x*frequency*3.1122+ t*4.269)*2.5@$y *= amplitude*0.06@$return y@;1;False;4;True;frequency;FLOAT;0;In;;Float;True;amplitude;FLOAT;0;In;;Float;True;time;FLOAT;0;In;;Float;True;x;FLOAT;0;In;;Float;FractalBrownianMotion;False;False;0;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;29;-2250.411,-99.50002;Float;False;Constant;_Float1;Float 1;3;0;Create;True;0;0;False;0;3;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;27;-2249.411,-221.5;Float;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;72;-1515.898,-1334.668;Float;False;1386.087;544.3693;Topo rings;12;77;76;71;66;67;70;68;61;64;73;65;62;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;28;-2082.413,-186.5;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;65;-1501.511,-1039.707;Float;False;Property;_TopotRingRange;TopotRingRange;6;0;Create;True;0;0;False;0;0.01;0.01;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;62;-1485.511,-1279.709;Float;False;Property;_TopoRingStart;TopoRingStart;5;0;Create;True;0;0;False;0;0.01;0.31;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RelayNode;82;-1208.171,-136.1031;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;73;-1277.51,-1135.708;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;64;-1146.235,-1045.53;Float;True;Step Antialiasing;-1;;3;2a825e80dfb3290468194f83380797bd;0;2;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;68;-925.2341,-1042.93;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;61;-1150.639,-1268.532;Float;True;Step Antialiasing;-1;;4;2a825e80dfb3290468194f83380797bd;0;2;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;70;-767.9345,-1042.93;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;67;-933.034,-1247.032;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;66;-610.6357,-1189.832;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;51;-424.8326,-196.6756;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;71;-469.3527,-1185.613;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;79;-139.2209,-453.6438;Float;False;Property;_TipEmitCol;TipEmitCol;8;1;[HDR];Create;True;0;0;False;0;0.1609909,0.1564169,0.8962264,0;1.505882,1.505882,11.98431,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;76;-559.0698,-1050.048;Float;False;Property;_TopoRingCol;TopoRingCol;7;1;[HDR];Create;True;0;0;False;0;0.9245283,0.04797081,0.04797081,0;0.7490196,0.7490196,0.7490196,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;77;-311.3529,-1111.526;Float;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;74;-81.97444,-6.081673;Float;False;499.0407;336.698;Metallic;4;55;59;58;60;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;52;346.2072,-232.7013;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;78;534.2265,-475.2851;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.NormalVertexDataNode;13;-615.7978,431.5084;Float;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;39;-2177.066,420.6717;Float;False;210;199;Ribbony wavey effect;1;25;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;85;-1677.978,-149.792;Float;False;188.4;123.4;Peak;1;83;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;60;-31.97445,215.6164;Float;False;Constant;_Max;Max;5;0;Create;True;0;0;False;0;0.95;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;17;-612.897,348.1086;Float;False;Property;_NormalOffset;Normal Offset;2;0;Create;True;0;0;False;0;4;-0.6;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;55;-20.93363,51.91833;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;59;-25.93362,125.9183;Float;False;Constant;_Float7;Float 7;5;0;Create;True;0;0;False;0;0.9;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;84;-1849.579,-151.092;Float;False;137.7001;126;Vally;1;80;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;14;-355.4973,348.3086;Float;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;56;6.291382,431.9546;Float;False;Property;_Smoothness;Smoothness;4;0;Create;True;0;0;False;0;0.2;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;98;1371.464,587.1633;Float;False;Constant;_Float6;Float 6;9;0;Create;True;0;0;False;0;7;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;95;1372.445,436.9079;Float;False;World;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldNormalVector;96;1365.464,296.1633;Float;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.FresnelNode;94;1611.358,351.1188;Float;False;Standard;WorldNormal;ViewDir;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.AbsOpNode;80;-1836.906,-103.5883;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;99;1881.464,440.1633;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;83;-1655.106,-103.4884;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;48;-178.7717,514.996;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ColorNode;16;899.2435,-689.2423;Float;False;Property;_Color0;Color 0;1;0;Create;True;0;0;False;0;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;21;-35.67391,639.7537;Float;False;Constant;_Float2;Float 2;2;0;Create;True;0;0;False;0;20;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;97;2023.464,251.1633;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;58;217.0663,43.91833;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;49;-375.0716,586.4953;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;93;1004.822,53.46644;Float;False;COLOR;1;0;COLOR;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.DynamicAppendNode;25;-2157.773,470.9227;Float;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;2264.411,267.5449;Float;False;True;6;Float;ASEMaterialInspector;0;0;Standard;TriplanerBrownianMotion2;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;True;0;True;TransparentCutout;;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;True;2;15;10;25;True;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;35;0;9;0
WireConnection;35;1;34;0
WireConnection;11;0;100;0
WireConnection;44;0;11;0
WireConnection;44;1;45;0
WireConnection;47;0;11;0
WireConnection;47;1;46;0
WireConnection;38;0;35;0
WireConnection;42;0;11;0
WireConnection;42;1;43;0
WireConnection;23;0;19;0
WireConnection;23;1;18;0
WireConnection;23;2;47;0
WireConnection;23;3;38;2
WireConnection;22;0;19;0
WireConnection;22;1;18;0
WireConnection;22;2;44;0
WireConnection;22;3;38;1
WireConnection;8;0;19;0
WireConnection;8;1;18;0
WireConnection;8;2;42;0
WireConnection;8;3;38;0
WireConnection;27;0;8;0
WireConnection;27;1;22;0
WireConnection;27;2;23;0
WireConnection;28;0;27;0
WireConnection;28;1;29;0
WireConnection;82;0;28;0
WireConnection;73;0;62;0
WireConnection;73;1;65;0
WireConnection;64;1;73;0
WireConnection;64;2;82;0
WireConnection;68;0;64;0
WireConnection;61;1;82;0
WireConnection;61;2;62;0
WireConnection;70;0;68;0
WireConnection;67;0;61;0
WireConnection;66;0;70;0
WireConnection;66;1;67;0
WireConnection;51;0;82;0
WireConnection;71;0;66;0
WireConnection;77;0;71;0
WireConnection;77;1;76;0
WireConnection;52;0;79;0
WireConnection;52;1;51;0
WireConnection;78;0;77;0
WireConnection;78;1;52;0
WireConnection;55;0;51;0
WireConnection;14;0;82;0
WireConnection;14;1;17;0
WireConnection;14;2;13;0
WireConnection;94;0;96;0
WireConnection;94;4;95;0
WireConnection;94;3;98;0
WireConnection;80;0;28;0
WireConnection;99;0;94;0
WireConnection;83;0;28;0
WireConnection;48;0;14;0
WireConnection;48;1;49;0
WireConnection;97;0;93;1
WireConnection;97;1;94;0
WireConnection;58;0;55;0
WireConnection;58;1;59;0
WireConnection;58;2;60;0
WireConnection;49;0;82;0
WireConnection;49;1;17;0
WireConnection;93;0;78;0
WireConnection;25;0;8;0
WireConnection;25;1;22;0
WireConnection;25;2;23;0
WireConnection;0;0;16;0
WireConnection;0;2;78;0
WireConnection;0;3;58;0
WireConnection;0;4;56;0
WireConnection;0;10;93;1
WireConnection;0;11;14;0
WireConnection;0;14;21;0
ASEEND*/
//CHKSM=49A090FF314C7ECD48EA891D54683989BAA24024