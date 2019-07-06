// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "BrownianNoiseLinesOnly"
{
	Properties
	{
		_ManualSpeed("ManualSpeed", Float) = 0
		_Freq("Freq", Float) = 1
		_Cutoff( "Mask Clip Value", Float ) = 0.55
		_RingStart("RingStart", Float) = 0.01
		_RingWidth("RingWidth", Float) = 0.01
		[HDR]_RingCol("RingCol", Color) = (0.9245283,0.04797081,0.04797081,0)
		_PeakValleyMix("PeakValleyMix", Range( 0 , 1)) = 0
		_Fade("Fade", Range( 0 , 1)) = 0
		_FadeNoiseSize("FadeNoiseSize", Range( 0 , 5)) = 1
		_Emission("Emission", Range( 0 , 1)) = 0
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "TransparentCutout"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Off
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 4.6
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float3 worldPos;
		};

		uniform float _Freq;
		uniform float _ManualSpeed;
		uniform float _PeakValleyMix;
		uniform float _RingStart;
		uniform float _RingWidth;
		uniform float4 _RingCol;
		uniform float _Emission;
		uniform float _Fade;
		uniform float _FadeNoiseSize;
		uniform float _Cutoff = 0.55;


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


		float3 mod3D289( float3 x ) { return x - floor( x / 289.0 ) * 289.0; }

		float4 mod3D289( float4 x ) { return x - floor( x / 289.0 ) * 289.0; }

		float4 permute( float4 x ) { return mod3D289( ( x * 34.0 + 1.0 ) * x ); }

		float4 taylorInvSqrt( float4 r ) { return 1.79284291400159 - r * 0.85373472095314; }

		float snoise( float3 v )
		{
			const float2 C = float2( 1.0 / 6.0, 1.0 / 3.0 );
			float3 i = floor( v + dot( v, C.yyy ) );
			float3 x0 = v - i + dot( i, C.xxx );
			float3 g = step( x0.yzx, x0.xyz );
			float3 l = 1.0 - g;
			float3 i1 = min( g.xyz, l.zxy );
			float3 i2 = max( g.xyz, l.zxy );
			float3 x1 = x0 - i1 + C.xxx;
			float3 x2 = x0 - i2 + C.yyy;
			float3 x3 = x0 - 0.5;
			i = mod3D289( i);
			float4 p = permute( permute( permute( i.z + float4( 0.0, i1.z, i2.z, 1.0 ) ) + i.y + float4( 0.0, i1.y, i2.y, 1.0 ) ) + i.x + float4( 0.0, i1.x, i2.x, 1.0 ) );
			float4 j = p - 49.0 * floor( p / 49.0 );  // mod(p,7*7)
			float4 x_ = floor( j / 7.0 );
			float4 y_ = floor( j - 7.0 * x_ );  // mod(j,N)
			float4 x = ( x_ * 2.0 + 0.5 ) / 7.0 - 1.0;
			float4 y = ( y_ * 2.0 + 0.5 ) / 7.0 - 1.0;
			float4 h = 1.0 - abs( x ) - abs( y );
			float4 b0 = float4( x.xy, y.xy );
			float4 b1 = float4( x.zw, y.zw );
			float4 s0 = floor( b0 ) * 2.0 + 1.0;
			float4 s1 = floor( b1 ) * 2.0 + 1.0;
			float4 sh = -step( h, 0.0 );
			float4 a0 = b0.xzyw + s0.xzyw * sh.xxyy;
			float4 a1 = b1.xzyw + s1.xzyw * sh.zzww;
			float3 g0 = float3( a0.xy, h.x );
			float3 g1 = float3( a0.zw, h.y );
			float3 g2 = float3( a1.xy, h.z );
			float3 g3 = float3( a1.zw, h.w );
			float4 norm = taylorInvSqrt( float4( dot( g0, g0 ), dot( g1, g1 ), dot( g2, g2 ), dot( g3, g3 ) ) );
			g0 *= norm.x;
			g1 *= norm.y;
			g2 *= norm.z;
			g3 *= norm.w;
			float4 m = max( 0.6 - float4( dot( x0, x0 ), dot( x1, x1 ), dot( x2, x2 ), dot( x3, x3 ) ), 0.0 );
			m = m* m;
			m = m* m;
			float4 px = float4( dot( x0, g0 ), dot( x1, g1 ), dot( x2, g2 ), dot( x3, g3 ) );
			return 42.0 * dot( m, px);
		}


		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float frequency8 = _Freq;
			float amplitude8 = 1.0;
			float time8 = ( _ManualSpeed + 23.0 );
			float3 ase_worldPos = i.worldPos;
			float3 break38 = mul( float4( ase_worldPos , 0.0 ), unity_WorldToObject ).xyz;
			float x8 = break38.x;
			float localFractalBrownianMotion8 = FractalBrownianMotion( frequency8 , amplitude8 , time8 , x8 );
			float frequency22 = _Freq;
			float amplitude22 = 1.0;
			float time22 = ( _ManualSpeed + 2.0 );
			float x22 = break38.y;
			float localFractalBrownianMotion22 = FractalBrownianMotion( frequency22 , amplitude22 , time22 , x22 );
			float frequency23 = _Freq;
			float amplitude23 = 1.0;
			float time23 = ( _ManualSpeed + -72.0 );
			float x23 = break38.z;
			float localFractalBrownianMotion23 = FractalBrownianMotion( frequency23 , amplitude23 , time23 , x23 );
			float temp_output_80_0 = abs( ( ( localFractalBrownianMotion8 + localFractalBrownianMotion22 + localFractalBrownianMotion23 ) / 3.0 ) );
			float lerpResult98 = lerp( ( 1.0 - temp_output_80_0 ) , temp_output_80_0 , _PeakValleyMix);
			float temp_output_3_0_g3 = ( lerpResult98 - ( _RingStart + _RingWidth ) );
			float temp_output_3_0_g4 = ( _RingStart - lerpResult98 );
			float temp_output_71_0 = saturate( ( ( 1.0 - saturate( saturate( ( temp_output_3_0_g3 / fwidth( temp_output_3_0_g3 ) ) ) ) ) - saturate( saturate( ( temp_output_3_0_g4 / fwidth( temp_output_3_0_g4 ) ) ) ) ) );
			float4 color16 = IsGammaSpace() ? float4(1,1,1,0) : float4(1,1,1,0);
			float4 temp_output_107_0 = ( ( temp_output_71_0 * _RingCol ) * color16 );
			o.Albedo = temp_output_107_0.rgb;
			o.Emission = ( temp_output_107_0 * _Emission ).rgb;
			o.Smoothness = 0.2;
			o.Alpha = 1;
			float simplePerlin3D5_g5 = snoise( ( _FadeNoiseSize * ase_worldPos ) );
			clip( ( saturate( temp_output_71_0 ) * saturate( ( (-1.0 + (_Fade - 0.0) * (2.0 - -1.0) / (1.0 - 0.0)) + simplePerlin3D5_g5 ) ) ) - _Cutoff );
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=16700
7;1087;1906;1004;718.2651;667.5215;1.720357;True;True
Node;AmplifyShaderEditor.WorldPosInputsNode;9;-2792.667,677.7941;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldToObjectMatrix;34;-2776.667,821.794;Float;False;0;1;FLOAT4x4;0
Node;AmplifyShaderEditor.RangedFloatNode;46;-2621.669,281.1945;Float;False;Constant;_Float5;Float 5;3;0;Create;True;0;0;False;0;-72;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;35;-2488.668,741.794;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT4x4;0,0,0,0,0,1,0,0,0,0,1,0,0,0,0,1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;90;-3072.801,158.3001;Float;False;Property;_ManualSpeed;ManualSpeed;0;0;Create;True;0;0;False;0;0;7.524067;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;45;-2621.669,121.1945;Float;False;Constant;_Float4;Float 4;3;0;Create;True;0;0;False;0;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;43;-2621.669,-38.80549;Float;False;Constant;_Float3;Float 3;3;0;Create;True;0;0;False;0;23;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;19;-2218.169,-211.0056;Float;False;Property;_Freq;Freq;1;0;Create;True;0;0;False;0;1;2.9;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;38;-2344.668,741.794;Float;False;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SimpleAddOpNode;47;-2621.669,345.1945;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;44;-2621.669,185.1945;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;42;-2621.669,25.19454;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;18;-2240.439,-3.661891;Float;False;Constant;_Float0;Float 0;2;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CustomExpressionNode;23;-1936.87,306.5945;Float;False;float y = sin(x * frequency)@$float t = 0.01*(-time*130.0)@$y += sin(x*frequency*2.1 + t)*4.5@$y += sin(x*frequency*1.72 + t*1.121)*4.0@$y += sin(x*frequency*2.221 + t*0.437)*5.0@$y += sin(x*frequency*3.1122+ t*4.269)*2.5@$y *= amplitude*0.06@$return y@;1;False;4;True;frequency;FLOAT;0;In;;Float;False;True;amplitude;FLOAT;0;In;;Float;False;True;time;FLOAT;0;In;;Float;False;True;x;FLOAT;0;In;;Float;False;FractalBrownianMotion;False;False;0;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CustomExpressionNode;8;-1936.87,-13.40549;Float;False;float y = sin(x * frequency)@$float t = 0.01*(-time*130.0)@$y += sin(x*frequency*2.1 + t)*4.5@$y += sin(x*frequency*1.72 + t*1.121)*4.0@$y += sin(x*frequency*2.221 + t*0.437)*5.0@$y += sin(x*frequency*3.1122+ t*4.269)*2.5@$y *= amplitude*0.06@$return y@;1;False;4;True;frequency;FLOAT;0;In;;Float;False;True;amplitude;FLOAT;0;In;;Float;False;True;time;FLOAT;0;In;;Float;False;True;x;FLOAT;0;In;;Float;False;FractalBrownianMotion;False;False;0;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CustomExpressionNode;22;-1936.87,146.5945;Float;False;float y = sin(x * frequency)@$float t = 0.01*(-time*130.0)@$y += sin(x*frequency*2.1 + t)*4.5@$y += sin(x*frequency*1.72 + t*1.121)*4.0@$y += sin(x*frequency*2.221 + t*0.437)*5.0@$y += sin(x*frequency*3.1122+ t*4.269)*2.5@$y *= amplitude*0.06@$return y@;1;False;4;True;frequency;FLOAT;0;In;;Float;False;True;amplitude;FLOAT;0;In;;Float;False;True;time;FLOAT;0;In;;Float;False;True;x;FLOAT;0;In;;Float;False;FractalBrownianMotion;False;False;0;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;40;-1469.656,-257.3284;Float;False;340;233;Blobby;3;28;29;27;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;29;-1455.001,-99.50002;Float;False;Constant;_Float1;Float 1;3;0;Create;True;0;0;False;0;3;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;27;-1454.001,-221.5;Float;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;84;-1054.167,-151.092;Float;False;137.7001;126;Vally;1;80;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;28;-1287.001,-186.5;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.AbsOpNode;80;-1041.494,-103.5883;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;85;-864.119,-281.5573;Float;False;188.4;123.4;Peak;1;83;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;99;-815.4761,141.4947;Float;False;Property;_PeakValleyMix;PeakValleyMix;8;0;Create;True;0;0;False;0;0;0.8;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;83;-841.2473,-235.2535;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;72;-526.6304,-1108.131;Float;False;1386.087;544.3693;Topo rings;12;77;76;71;66;67;70;68;61;64;65;62;73;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;62;-476.6046,-1009.935;Float;False;Property;_RingStart;RingStart;3;0;Create;True;0;0;False;0;0.01;0.3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;65;-492.6046,-769.9343;Float;False;Property;_RingWidth;RingWidth;4;0;Create;True;0;0;False;0;0.01;0.04813544;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;98;-591.4756,-169.4708;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;73;-308.5237,-859.2823;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RelayNode;82;-406.5149,-518.7803;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;64;-156.9681,-818.9939;Float;True;Step Antialiasing;-1;;3;2a825e80dfb3290468194f83380797bd;0;2;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;61;-161.3724,-1041.995;Float;True;Step Antialiasing;-1;;4;2a825e80dfb3290468194f83380797bd;0;2;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;68;64.03278,-816.3941;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;67;56.23289,-1020.495;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;70;221.3327,-816.3941;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;66;378.6316,-963.2949;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;76;397.7612,-782.6134;Float;False;Property;_RingCol;RingCol;5;1;[HDR];Create;True;0;0;False;0;0.9245283,0.04797081,0.04797081,0;0.9811321,0.9811321,0.9811321,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;71;519.9148,-959.0759;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;101;383.2329,628.1481;Float;False;Property;_Fade;Fade;9;0;Create;True;0;0;False;0;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;100;379.2331,711.1481;Float;False;Property;_FadeNoiseSize;FadeNoiseSize;10;0;Create;True;0;0;False;0;1;1.3;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;77;677.9145,-884.9892;Float;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;102;671.7162,650.0818;Float;False;WorldFade;6;;5;361dea0c654d2bb4586db9164587a602;0;2;12;FLOAT;1;False;13;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;16;523.1692,-302.321;Float;False;Constant;_MainCol;MainCol;6;0;Create;True;0;0;False;0;1,1,1,0;0.2735848,0.2735848,0.2735848,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;107;955.6422,-201.3049;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;109;623.6133,22.34159;Float;False;Property;_Emission;Emission;11;0;Create;True;0;0;False;0;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;106;961.3776,642.8857;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;105;519.9932,331.7582;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;103;1009.933,455.8593;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;56;640.3902,149.1551;Float;False;Constant;_Smoothness;Smoothness;8;0;Create;True;0;0;False;0;0.2;0.282;0;1.1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;108;1041.66,51.58766;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1384.911,33.27171;Float;False;True;6;Float;ASEMaterialInspector;0;0;Standard;BrownianNoiseLinesOnly;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.55;True;True;0;True;TransparentCutout;;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;True;0.53;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;2;-1;-1;0;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;35;0;9;0
WireConnection;35;1;34;0
WireConnection;38;0;35;0
WireConnection;47;0;90;0
WireConnection;47;1;46;0
WireConnection;44;0;90;0
WireConnection;44;1;45;0
WireConnection;42;0;90;0
WireConnection;42;1;43;0
WireConnection;23;0;19;0
WireConnection;23;1;18;0
WireConnection;23;2;47;0
WireConnection;23;3;38;2
WireConnection;8;0;19;0
WireConnection;8;1;18;0
WireConnection;8;2;42;0
WireConnection;8;3;38;0
WireConnection;22;0;19;0
WireConnection;22;1;18;0
WireConnection;22;2;44;0
WireConnection;22;3;38;1
WireConnection;27;0;8;0
WireConnection;27;1;22;0
WireConnection;27;2;23;0
WireConnection;28;0;27;0
WireConnection;28;1;29;0
WireConnection;80;0;28;0
WireConnection;83;0;80;0
WireConnection;98;0;83;0
WireConnection;98;1;80;0
WireConnection;98;2;99;0
WireConnection;73;0;62;0
WireConnection;73;1;65;0
WireConnection;82;0;98;0
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
WireConnection;77;0;71;0
WireConnection;77;1;76;0
WireConnection;102;12;101;0
WireConnection;102;13;100;0
WireConnection;107;0;77;0
WireConnection;107;1;16;0
WireConnection;106;0;102;0
WireConnection;105;0;71;0
WireConnection;103;0;105;0
WireConnection;103;1;106;0
WireConnection;108;0;107;0
WireConnection;108;1;109;0
WireConnection;0;0;107;0
WireConnection;0;2;108;0
WireConnection;0;4;56;0
WireConnection;0;10;103;0
ASEEND*/
//CHKSM=BC8D2FDD30C3C1C2481AD34E2FE6E35764D0B436