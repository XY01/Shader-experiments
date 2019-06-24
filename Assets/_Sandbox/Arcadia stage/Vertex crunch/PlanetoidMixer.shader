// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "PlanetoidMixer"
{
	Properties
	{
		_EdgeLength ( "Edge length", Range( 2, 50 ) ) = 15
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		_TopTexture0("Top Texture 0", 2D) = "white" {}
		_Tiling("Tiling", Float) = 0.1
		_EMissivescaler("EMissive scaler", Float) = 2
		_Albedo0("Albedo0", 2D) = "white" {}
		_Fade("Fade", Range( 0 , 1)) = 0
		_Albedo1("Albedo1", 2D) = "white" {}
		_FadeNoiseSize("FadeNoiseSize", Range( 0 , 5)) = 1
		_Float7("Float 7", Float) = 0.75
		_Normal1("Normal1", 2D) = "bump" {}
		_Normal0("Normal0", 2D) = "bump" {}
		_WorldPosOffset("WorldPosOffset", Float) = 0
		_TexValOffset("TexValOffset", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "AlphaTest+0" }
		Cull Off
		CGINCLUDE
		#include "Tessellation.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 4.6
		#define ASE_TEXTURE_PARAMS(textureName) textureName

		#ifdef UNITY_PASS_SHADOWCASTER
			#undef INTERNAL_DATA
			#undef WorldReflectionVector
			#undef WorldNormalVector
			#define INTERNAL_DATA half3 internalSurfaceTtoW0; half3 internalSurfaceTtoW1; half3 internalSurfaceTtoW2;
			#define WorldReflectionVector(data,normal) reflect (data.worldRefl, half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal)))
			#define WorldNormalVector(data,normal) half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal))
		#endif
		struct Input
		{
			float2 uv_texcoord;
			float3 worldPos;
			float3 worldNormal;
			INTERNAL_DATA
		};

		uniform sampler2D _Normal0;
		uniform float4 _Normal0_ST;
		uniform sampler2D _Normal1;
		uniform float4 _Normal1_ST;
		uniform sampler2D _TopTexture0;
		uniform float _Tiling;
		uniform float _WorldPosOffset;
		uniform float _TexValOffset;
		uniform float _EMissivescaler;
		uniform sampler2D _Albedo0;
		uniform float4 _Albedo0_ST;
		uniform sampler2D _Albedo1;
		uniform float4 _Albedo1_ST;
		uniform float _Float7;
		uniform float _Fade;
		uniform float _FadeNoiseSize;
		uniform float _Cutoff = 0.5;
		uniform float _EdgeLength;


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


		float4 tessFunction( appdata_full v0, appdata_full v1, appdata_full v2 )
		{
			return UnityEdgeLengthBasedTess (v0.vertex, v1.vertex, v2.vertex, _EdgeLength);
		}

		void vertexDataFunc( inout appdata_full v )
		{
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_Normal0 = i.uv_texcoord * _Normal0_ST.xy + _Normal0_ST.zw;
			float2 uv_Normal1 = i.uv_texcoord * _Normal1_ST.xy + _Normal1_ST.zw;
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldNormal = WorldNormalVector( i, float3( 0, 0, 1 ) );
			float4 triplanar1 = TriplanarSamplingSF( _TopTexture0, ( ase_worldPos + _WorldPosOffset ), ase_worldNormal, 1.0, _Tiling, 1.0, 0 );
			float fmodResult18 = frac(( triplanar1.x + _TexValOffset )/0.3)*0.3;
			float temp_output_13_0 = ( pow( fmodResult18 , 3.0 ) * _EMissivescaler );
			float temp_output_3_0_g3 = ( 0.5 - saturate( temp_output_13_0 ) );
			float temp_output_94_0 = saturate( ( temp_output_3_0_g3 / fwidth( temp_output_3_0_g3 ) ) );
			float3 lerpResult87 = lerp( UnpackNormal( tex2D( _Normal0, uv_Normal0 ) ) , UnpackNormal( tex2D( _Normal1, uv_Normal1 ) ) , temp_output_94_0);
			o.Normal = lerpResult87;
			float2 uv_Albedo0 = i.uv_texcoord * _Albedo0_ST.xy + _Albedo0_ST.zw;
			float2 uv_Albedo1 = i.uv_texcoord * _Albedo1_ST.xy + _Albedo1_ST.zw;
			float4 lerpResult80 = lerp( tex2D( _Albedo0, uv_Albedo0 ) , tex2D( _Albedo1, uv_Albedo1 ) , temp_output_94_0);
			o.Albedo = lerpResult80.rgb;
			o.Metallic = 0.0;
			o.Smoothness = ( temp_output_94_0 * _Float7 );
			o.Alpha = 1;
			float simplePerlin3D5_g4 = snoise( ( _FadeNoiseSize * ase_worldPos ) );
			clip( ( (-1.0 + (_Fade - 0.0) * (2.0 - -1.0) / (1.0 - 0.0)) + simplePerlin3D5_g4 ) - _Cutoff );
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard keepalpha fullforwardshadows vertex:vertexDataFunc tessellate:tessFunction 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 4.6
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
				float2 customPack1 : TEXCOORD1;
				float4 tSpace0 : TEXCOORD2;
				float4 tSpace1 : TEXCOORD3;
				float4 tSpace2 : TEXCOORD4;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				vertexDataFunc( v );
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				half3 worldTangent = UnityObjectToWorldDir( v.tangent.xyz );
				half tangentSign = v.tangent.w * unity_WorldTransformParams.w;
				half3 worldBinormal = cross( worldNormal, worldTangent ) * tangentSign;
				o.tSpace0 = float4( worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x );
				o.tSpace1 = float4( worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y );
				o.tSpace2 = float4( worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z );
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
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
				surfIN.uv_texcoord = IN.customPack1.xy;
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
209;1581;1906;1010;-66.12708;171.839;1;True;True
Node;AmplifyShaderEditor.RangedFloatNode;76;-2321.21,-319.4427;Float;False;Property;_WorldPosOffset;WorldPosOffset;21;0;Create;True;0;0;False;0;0;12.39379;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;65;-2329.408,-235.5561;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;10;-2314.518,-66.05868;Float;False;Property;_Tiling;Tiling;11;0;Create;True;0;0;False;0;0.1;0.0395312;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;66;-2064.268,-234.9756;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.TriplanarNode;1;-1766.164,-108.287;Float;True;Spherical;World;False;Top Texture 0;_TopTexture0;white;8;Assets/AmplifyShaderEditor/Examples/Community/LowPolyWater/foam-distortion-001.png;Mid Texture 0;_MidTexture0;white;-1;None;Bot Texture 0;_BotTexture0;white;-1;None;Triplanar Sampler;False;10;0;SAMPLER2D;;False;5;FLOAT;1;False;1;SAMPLER2D;;False;6;FLOAT;0;False;2;SAMPLER2D;;False;7;FLOAT;0;False;9;FLOAT3;0,0,0;False;8;FLOAT;1;False;3;FLOAT;1;False;4;FLOAT;1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;77;-1628.711,156.2574;Float;False;Property;_TexValOffset;TexValOffset;22;0;Create;True;0;0;False;0;0;9.027489;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;26;-1336.645,-7.38279;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;19;-849.5,279.5;Float;False;Constant;_Float2;Float 2;5;0;Create;True;0;0;False;0;0.3;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;12;-219.2,96.89996;Float;False;Constant;_Float1;Float 1;4;0;Create;True;0;0;False;0;3;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimplifiedFModOpNode;18;-730.5,171.5;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;11;-37.10002,120.7;Float;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;14;11.89999,244.4;Float;False;Property;_EMissivescaler;EMissive scaler;12;0;Create;True;0;0;False;0;2;400;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;13;196.6001,100.2;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;88;392.6041,97.8419;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;95;646.5405,171.1552;Float;False;Constant;_Float9;Float 9;17;0;Create;True;0;0;False;0;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;44;142.4863,1417.403;Float;False;Property;_FadeNoiseSize;FadeNoiseSize;16;0;Create;True;0;0;False;0;1;1;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;78;104.861,-380.7827;Float;True;Property;_Albedo1;Albedo1;15;0;Create;True;0;0;False;0;ddce39766e2a9ce48a69c914a4a29487;ddce39766e2a9ce48a69c914a4a29487;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;98;977.1271,253.161;Float;False;Property;_Float7;Float 7;17;0;Create;True;0;0;False;0;0.75;0.75;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;94;680.5405,26.15521;Float;False;Step Antialiasing;-1;;3;2a825e80dfb3290468194f83380797bd;0;2;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;43;146.4861,1334.403;Float;False;Property;_Fade;Fade;14;0;Create;True;0;0;False;0;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;79;103.1881,-566.4646;Float;True;Property;_Albedo0;Albedo0;13;0;Create;True;0;0;False;0;b297077dae62c1944ba14cad801cddf5;b297077dae62c1944ba14cad801cddf5;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;85;282.1041,272.0418;Float;True;Property;_Normal0;Normal0;20;0;Create;True;0;0;False;0;0bebe40e9ebbecc48b8e9cfea982da7e;0bebe40e9ebbecc48b8e9cfea982da7e;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;86;282.1043,464.4417;Float;True;Property;_Normal1;Normal1;19;0;Create;True;0;0;False;0;12c40864f9ef9974592868faef1d76c5;12c40864f9ef9974592868faef1d76c5;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;7;-397.5,136.5;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;80;661.907,-302.1606;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;8;-812.5,-47.5;Float;False;Property;_Offset;Offset;10;0;Create;True;0;0;False;0;1;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;30;-167.4711,385.5072;Float;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;71;186.8943,1222.281;Float;False;Property;_ManualTime;_ManualTime;18;0;Create;True;0;0;False;0;0;603.22;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldNormalVector;31;-470.2372,451.2633;Float;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.LerpOp;87;725.4041,359.1417;Float;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;91;1010.541,597.1552;Float;False;Constant;_Float8;Float 8;17;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;73;378.7461,1221.908;Float;False;ManualTime;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;5;-29.00003,-137.6;Float;False;Property;_MainCol;MainCol;9;0;Create;True;0;0;False;0;0.8018868,0.8018868,0.8018868,0;0.8018868,0.8018868,0.8018868,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;2;-28.5,620.5;Float;False;Constant;_Float0;Float 0;1;0;Create;True;0;0;False;0;5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;59;518.1411,1352.876;Float;False;WorldFade;6;;4;361dea0c654d2bb4586db9164587a602;0;2;12;FLOAT;1;False;13;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;9;312.4999,-109.1;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;97;1111.127,159.161;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1587.167,6.936876;Float;False;True;6;Float;ASEMaterialInspector;0;0;Standard;PlanetoidMixer;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;True;0;True;Opaque;;AlphaTest;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;True;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;5;-1;-1;0;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;66;0;65;0
WireConnection;66;1;76;0
WireConnection;1;9;66;0
WireConnection;1;3;10;0
WireConnection;26;0;1;1
WireConnection;26;1;77;0
WireConnection;18;0;26;0
WireConnection;18;1;19;0
WireConnection;11;0;18;0
WireConnection;11;1;12;0
WireConnection;13;0;11;0
WireConnection;13;1;14;0
WireConnection;88;0;13;0
WireConnection;94;1;88;0
WireConnection;94;2;95;0
WireConnection;7;0;8;0
WireConnection;7;1;18;0
WireConnection;80;0;79;0
WireConnection;80;1;78;0
WireConnection;80;2;94;0
WireConnection;30;0;7;0
WireConnection;30;1;31;0
WireConnection;87;0;85;0
WireConnection;87;1;86;0
WireConnection;87;2;94;0
WireConnection;73;0;71;0
WireConnection;59;12;43;0
WireConnection;59;13;44;0
WireConnection;9;0;5;0
WireConnection;9;1;13;0
WireConnection;97;0;94;0
WireConnection;97;1;98;0
WireConnection;0;0;80;0
WireConnection;0;1;87;0
WireConnection;0;3;91;0
WireConnection;0;4;97;0
WireConnection;0;10;59;0
ASEEND*/
//CHKSM=63E7D0643D8295B6DD8D788163C29D67639D1454