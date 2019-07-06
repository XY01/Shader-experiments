// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Arcadia/PRBTriplanerObjectSpace_Blend"
{
	Properties
	{
		_MaskTex("MaskTex", 2D) = "white" {}
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		_Albedo("Albedo", 2D) = "white" {}
		_Albedo1("Albedo 1", 2D) = "white" {}
		_Rough("Rough", 2D) = "white" {}
		_Rouugh1("Rouugh 1", 2D) = "white" {}
		_Metallic("Metallic", 2D) = "black" {}
		_Metallic1("Metallic 1", 2D) = "black" {}
		_Normal("Normal", 2D) = "white" {}
		_Normal1("Normal 1", 2D) = "white" {}
		_Emission("Emission", 2D) = "black" {}
		_Emission1("Emission 1", 2D) = "black" {}
		_Tiling("Tiling", Vector) = (1,1,0,0)
		_Tiling2("Tiling2", Vector) = (1,1,0,0)
		_NormalScale("Normal Scale", Range( 0 , 3)) = 1
		_Falloff("Falloff", Range( 0.75 , 4)) = 1.760414
		_MaskFalloff("MaskFalloff", Range( 0.75 , 4)) = 1.760414
		_Fade("Fade", Range( 0 , 1)) = 0
		_MaskTiling("MaskTiling", Vector) = (1,1,0,0)
		[Toggle]_ToggleSwitch0("Toggle Switch0", Float) = 1
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "TransparentCutout"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
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
			float3 worldPos;
			float3 worldNormal;
			INTERNAL_DATA
		};

		uniform sampler2D _Normal;
		uniform float2 _Tiling;
		uniform float _Falloff;
		uniform float _NormalScale;
		uniform sampler2D _Normal1;
		uniform float2 _Tiling2;
		uniform float _ToggleSwitch0;
		uniform sampler2D _MaskTex;
		uniform float2 _MaskTiling;
		uniform float _MaskFalloff;
		uniform sampler2D _Albedo;
		uniform sampler2D _Albedo1;
		uniform sampler2D _Emission;
		uniform sampler2D _Emission1;
		uniform float _Fade;
		uniform sampler2D _Metallic;
		uniform sampler2D _Metallic1;
		uniform sampler2D _Rough;
		uniform sampler2D _Rouugh1;
		uniform float _Cutoff = 0.5;


		inline float3 TriplanarSamplingSNF( sampler2D topTexMap, float3 worldPos, float3 worldNormal, float falloff, float2 tiling, float3 normalScale, float3 index )
		{
			float3 projNormal = ( pow( abs( worldNormal ), falloff ) );
			projNormal /= ( projNormal.x + projNormal.y + projNormal.z ) + 0.00001;
			float3 nsign = sign( worldNormal );
			half4 xNorm; half4 yNorm; half4 zNorm;
			xNorm = ( tex2D( ASE_TEXTURE_PARAMS( topTexMap ), tiling * worldPos.zy * float2( nsign.x, 1.0 ) ) );
			yNorm = ( tex2D( ASE_TEXTURE_PARAMS( topTexMap ), tiling * worldPos.xz * float2( nsign.y, 1.0 ) ) );
			zNorm = ( tex2D( ASE_TEXTURE_PARAMS( topTexMap ), tiling * worldPos.xy * float2( -nsign.z, 1.0 ) ) );
			xNorm.xyz = half3( UnpackScaleNormal( xNorm, normalScale.y ).xy * float2( nsign.x, 1.0 ) + worldNormal.zy, worldNormal.x ).zyx;
			yNorm.xyz = half3( UnpackScaleNormal( yNorm, normalScale.x ).xy * float2( nsign.y, 1.0 ) + worldNormal.xz, worldNormal.y ).xzy;
			zNorm.xyz = half3( UnpackScaleNormal( zNorm, normalScale.y ).xy * float2( -nsign.z, 1.0 ) + worldNormal.xy, worldNormal.z ).xyz;
			return normalize( xNorm.xyz * projNormal.x + yNorm.xyz * projNormal.y + zNorm.xyz * projNormal.z );
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
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldNormal = WorldNormalVector( i, float3( 0, 0, 1 ) );
			float3 ase_worldTangent = WorldNormalVector( i, float3( 1, 0, 0 ) );
			float3 ase_worldBitangent = WorldNormalVector( i, float3( 0, 1, 0 ) );
			float3x3 ase_worldToTangent = float3x3( ase_worldTangent, ase_worldBitangent, ase_worldNormal );
			float4 ase_vertexTangent = mul( unity_WorldToObject, float4( ase_worldTangent, 0 ) );
			float3 ase_vertexBitangent = mul( unity_WorldToObject, float4( ase_worldBitangent, 0 ) );
			float3 ase_vertexNormal = mul( unity_WorldToObject, float4( ase_worldNormal, 0 ) );
			float3x3 objectToTangent = float3x3(ase_vertexTangent.xyz, ase_vertexBitangent, ase_vertexNormal);
			float3 ase_vertex3Pos = mul( unity_WorldToObject, float4( i.worldPos , 1 ) );
			float3 triplanar8 = TriplanarSamplingSNF( _Normal, ase_vertex3Pos, ase_vertexNormal, _Falloff, _Tiling, _NormalScale, 0 );
			float3 tanTriplanarNormal8 = mul( objectToTangent, triplanar8 );
			float3 triplanar23 = TriplanarSamplingSNF( _Normal1, ase_vertex3Pos, ase_vertexNormal, _Falloff, _Tiling2, 1.0, 0 );
			float3 tanTriplanarNormal23 = mul( objectToTangent, triplanar23 );
			float4 triplanar35 = TriplanarSamplingSF( _MaskTex, ase_vertex3Pos, ase_vertexNormal, _MaskFalloff, _MaskTiling, 1.0, 0 );
			float3 lerpResult30 = lerp( tanTriplanarNormal8 , tanTriplanarNormal23 , lerp(triplanar35.x,( 1.0 - triplanar35.x ),_ToggleSwitch0));
			o.Normal = lerpResult30;
			float4 triplanar5 = TriplanarSamplingSF( _Albedo, ase_vertex3Pos, ase_vertexNormal, _Falloff, _Tiling, 1.0, 0 );
			float4 triplanar22 = TriplanarSamplingSF( _Albedo1, ase_vertex3Pos, ase_vertexNormal, _Falloff, _Tiling2, 1.0, 0 );
			float4 lerpResult29 = lerp( triplanar5 , triplanar22 , lerp(triplanar35.x,( 1.0 - triplanar35.x ),_ToggleSwitch0));
			o.Albedo = lerpResult29.xyz;
			float4 triplanar9 = TriplanarSamplingSF( _Emission, ase_vertex3Pos, ase_vertexNormal, _Falloff, _Tiling, 1.0, 0 );
			float4 triplanar24 = TriplanarSamplingSF( _Emission1, ase_vertex3Pos, ase_vertexNormal, _Falloff, _Tiling2, 1.0, 0 );
			float4 lerpResult31 = lerp( triplanar9 , triplanar24 , lerp(triplanar35.x,( 1.0 - triplanar35.x ),_ToggleSwitch0));
			float simplePerlin3D5_g8 = snoise( ( 1.0 * ( ase_worldPos * float3(0.2,8,0.2) ) ) );
			float temp_output_6_0_g8 = ( (-1.0 + (_Fade - 0.0) * (2.0 - -1.0) / (1.0 - 0.0)) + simplePerlin3D5_g8 );
			float smoothstepResult24_g8 = smoothstep( 0.5 , 0.95 , temp_output_6_0_g8);
			o.Emission = ( lerpResult31 + ( ( 1.0 - smoothstepResult24_g8 ) * lerpResult29 * 2.0 ) ).xyz;
			float4 triplanar16 = TriplanarSamplingSF( _Metallic, ase_vertex3Pos, ase_vertexNormal, _Falloff, _Tiling, 1.0, 0 );
			float4 triplanar25 = TriplanarSamplingSF( _Metallic1, ase_vertex3Pos, ase_vertexNormal, _Falloff, _Tiling2, 1.0, 0 );
			float lerpResult32 = lerp( triplanar16.x , triplanar25.x , lerp(triplanar35.x,( 1.0 - triplanar35.x ),_ToggleSwitch0));
			o.Metallic = lerpResult32;
			float4 triplanar7 = TriplanarSamplingSF( _Rough, ase_vertex3Pos, ase_vertexNormal, _Falloff, _Tiling, 1.0, 0 );
			float4 triplanar21 = TriplanarSamplingSF( _Rouugh1, ase_vertex3Pos, ase_vertexNormal, _Falloff, _Tiling2, 1.0, 0 );
			float lerpResult33 = lerp( ( 1.0 - triplanar7.x ) , ( 1.0 - triplanar21.x ) , lerp(triplanar35.x,( 1.0 - triplanar35.x ),_ToggleSwitch0));
			o.Smoothness = lerpResult33;
			o.Alpha = 1;
			clip( temp_output_6_0_g8 - _Cutoff );
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard keepalpha fullforwardshadows 

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
				float4 tSpace0 : TEXCOORD1;
				float4 tSpace1 : TEXCOORD2;
				float4 tSpace2 : TEXCOORD3;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				half3 worldTangent = UnityObjectToWorldDir( v.tangent.xyz );
				half tangentSign = v.tangent.w * unity_WorldTransformParams.w;
				half3 worldBinormal = cross( worldNormal, worldTangent ) * tangentSign;
				o.tSpace0 = float4( worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x );
				o.tSpace1 = float4( worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y );
				o.tSpace2 = float4( worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z );
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
7;7;1453;1004;1092.173;357.6372;1.758723;True;True
Node;AmplifyShaderEditor.Vector2Node;38;-897.2,100.3;Float;False;Property;_MaskTiling;MaskTiling;18;0;Create;True;0;0;False;0;1,1;0.4,0.4;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;37;-994.531,227.8626;Float;False;Property;_MaskFalloff;MaskFalloff;16;0;Create;True;0;0;False;0;1.760414;4;0.75;4;0;1;FLOAT;0
Node;AmplifyShaderEditor.TriplanarNode;35;-554.3837,159.5849;Float;True;Spherical;Object;False;MaskTex;_MaskTex;white;0;None;Mid Texture 10;_MidTexture10;white;-1;None;Bot Texture 10;_BotTexture10;white;-1;None;Mask;False;10;0;SAMPLER2D;;False;5;FLOAT;1;False;1;SAMPLER2D;;False;6;FLOAT;0;False;2;SAMPLER2D;;False;7;FLOAT;0;False;9;FLOAT3;0,0,0;False;8;FLOAT;1;False;3;FLOAT2;1,1;False;4;FLOAT;1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;11;-1101.42,-769.1771;Float;False;Property;_Tiling;Tiling;12;0;Create;True;0;0;False;0;1,1;1,1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.OneMinusNode;54;-167.7987,244.5372;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;26;-1205.621,647.494;Float;False;Property;_Tiling2;Tiling2;13;0;Create;True;0;0;False;0;1,1;1,1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;13;-1316.442,530.1149;Float;False;Property;_Falloff;Falloff;15;0;Create;True;0;0;False;0;1.760414;4;0.75;4;0;1;FLOAT;0
Node;AmplifyShaderEditor.TriplanarNode;22;-657.1541,409.1019;Float;True;Spherical;Object;False;Albedo 1;_Albedo1;white;3;Assets/_Project/Materials/Substances/Mordor/mordor_rock.sbsar;Mid Texture 6;_MidTexture6;white;-1;None;Bot Texture 6;_BotTexture6;white;-1;None;Albedo;False;10;0;SAMPLER2D;;False;5;FLOAT;1;False;1;SAMPLER2D;;False;6;FLOAT;0;False;2;SAMPLER2D;;False;7;FLOAT;0;False;9;FLOAT3;0,0,0;False;8;FLOAT;1;False;3;FLOAT2;1,1;False;4;FLOAT;1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TriplanarNode;5;-645.919,-969.377;Float;True;Spherical;Object;False;Albedo;_Albedo;white;2;Assets/_Project/Materials/Substances/Mordor/mordor_rock.sbsar;Mid Texture 1;_MidTexture1;white;-1;None;Bot Texture 1;_BotTexture1;white;-1;None;Albedo;False;10;0;SAMPLER2D;;False;5;FLOAT;1;False;1;SAMPLER2D;;False;6;FLOAT;0;False;2;SAMPLER2D;;False;7;FLOAT;0;False;9;FLOAT3;0,0,0;False;8;FLOAT;1;False;3;FLOAT2;1,1;False;4;FLOAT;1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;18;-72.60638,783.4371;Float;False;Property;_Fade;Fade;17;0;Create;True;0;0;False;0;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ToggleSwitchNode;53;72.62332,173.4196;Float;False;Property;_ToggleSwitch0;Toggle Switch0;19;0;Create;True;0;0;False;0;1;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TriplanarNode;9;-649.8186,-584.5767;Float;True;Spherical;Object;False;Emission;_Emission;black;10;None;Mid Texture 0;_MidTexture0;white;-1;None;Bot Texture 0;_BotTexture0;white;-1;None;Emission;False;10;0;SAMPLER2D;;False;5;FLOAT;1;False;1;SAMPLER2D;;False;6;FLOAT;0;False;2;SAMPLER2D;;False;7;FLOAT;0;False;9;FLOAT3;0,0,0;False;8;FLOAT;1;False;3;FLOAT2;1,1;False;4;FLOAT;1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;29;619.5694,-99.40221;Float;False;3;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;2;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;49;577.1011,945.237;Float;False;Constant;_Float8;Float 8;19;0;Create;True;0;0;False;0;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TriplanarNode;7;-648.5183,-178.976;Float;True;Spherical;Object;False;Rough;_Rough;white;4;Assets/_Project/Materials/Substances/Mordor/mordor_rock.sbsar;Mid Texture 2;_MidTexture2;white;-1;None;Bot Texture 2;_BotTexture2;white;-1;None;Rough;False;10;0;SAMPLER2D;;False;5;FLOAT;1;False;1;SAMPLER2D;;False;6;FLOAT;0;False;2;SAMPLER2D;;False;7;FLOAT;0;False;9;FLOAT3;0,0,0;False;8;FLOAT;1;False;3;FLOAT2;1,1;False;4;FLOAT;1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TriplanarNode;21;-659.7533,1199.502;Float;True;Spherical;Object;False;Rouugh 1;_Rouugh1;white;5;Assets/_Project/Materials/Substances/Mordor/mordor_rock.sbsar;Mid Texture 5;_MidTexture5;white;-1;None;Bot Texture 5;_BotTexture5;white;-1;None;Rough1;False;10;0;SAMPLER2D;;False;5;FLOAT;1;False;1;SAMPLER2D;;False;6;FLOAT;0;False;2;SAMPLER2D;;False;7;FLOAT;0;False;9;FLOAT3;0,0,0;False;8;FLOAT;1;False;3;FLOAT2;1,1;False;4;FLOAT;1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TriplanarNode;24;-661.0536,793.9019;Float;True;Spherical;Object;False;Emission 1;_Emission1;black;11;None;Mid Texture 8;_MidTexture8;white;-1;None;Bot Texture 8;_BotTexture8;white;-1;None;Emission;False;10;0;SAMPLER2D;;False;5;FLOAT;1;False;1;SAMPLER2D;;False;6;FLOAT;0;False;2;SAMPLER2D;;False;7;FLOAT;0;False;9;FLOAT3;0,0,0;False;8;FLOAT;1;False;3;FLOAT2;1,1;False;4;FLOAT;1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;12;-1211.42,-643.0769;Float;False;Property;_NormalScale;Normal Scale;14;0;Create;True;0;0;False;0;1;1.39;0;3;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;46;202.5486,786.2101;Float;False;WorldFade;-1;;8;361dea0c654d2bb4586db9164587a602;0;1;12;FLOAT;1;False;2;FLOAT;26;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;20;-177.3216,1234.25;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TriplanarNode;16;-642.7178,-375.2766;Float;True;Spherical;Object;False;Metallic;_Metallic;black;6;None;Mid Texture 4;_MidTexture4;white;-1;None;Bot Texture 4;_BotTexture4;white;-1;None;Metallic;False;10;0;SAMPLER2D;;False;5;FLOAT;1;False;1;SAMPLER2D;;False;6;FLOAT;0;False;2;SAMPLER2D;;False;7;FLOAT;0;False;9;FLOAT3;0,0,0;False;8;FLOAT;1;False;3;FLOAT2;1,1;False;4;FLOAT;1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;47;847.501,685.2371;Float;False;3;3;0;FLOAT;0;False;1;FLOAT4;0,0,0,0;False;2;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.TriplanarNode;25;-653.9528,1003.202;Float;True;Spherical;Object;False;Metallic 1;_Metallic1;black;7;Assets/_Project/Materials/Substances/Mordor/mordor_rock.sbsar;Mid Texture 9;_MidTexture9;white;-1;None;Bot Texture 9;_BotTexture9;white;-1;None;Metallic1;False;10;0;SAMPLER2D;;False;5;FLOAT;1;False;1;SAMPLER2D;;False;6;FLOAT;0;False;2;SAMPLER2D;;False;7;FLOAT;0;False;9;FLOAT3;0,0,0;False;8;FLOAT;1;False;3;FLOAT2;1,1;False;4;FLOAT;1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;17;-186.4183,-159.4776;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;31;619.5694,156.5977;Float;False;3;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;2;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.TriplanarNode;8;-644.6187,-779.2289;Float;True;Spherical;Object;True;Normal;_Normal;white;8;Assets/_Project/Materials/Substances/Mordor/mordor_rock.sbsar;Mid Texture 3;_MidTexture3;white;-1;None;Bot Texture 3;_BotTexture3;white;-1;None;Normal;False;10;0;SAMPLER2D;;False;5;FLOAT;1;False;1;SAMPLER2D;;False;6;FLOAT;0;False;2;SAMPLER2D;;False;7;FLOAT;0;False;9;FLOAT3;0,0,0;False;8;FLOAT;1;False;3;FLOAT2;1,1;False;4;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TriplanarNode;23;-655.8538,596.3017;Float;True;Spherical;Object;True;Normal 1;_Normal1;white;9;Assets/_Project/Materials/Substances/Mordor/mordor_rock.sbsar;Mid Texture 7;_MidTexture7;white;-1;None;Bot Texture 7;_BotTexture7;white;-1;None;Normal;False;10;0;SAMPLER2D;;False;5;FLOAT;1;False;1;SAMPLER2D;;False;6;FLOAT;0;False;2;SAMPLER2D;;False;7;FLOAT;0;False;9;FLOAT3;0,0,0;False;8;FLOAT;1;False;3;FLOAT2;1,1;False;4;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;33;619.5694,410.8391;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;30;619.5694,28.5978;Float;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;44;800.7012,197.7371;Float;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.LerpOp;32;623.0869,282.839;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;941.9388,136.1164;Float;False;True;6;Float;ASEMaterialInspector;0;0;Standard;Arcadia/PRBTriplanerObjectSpace_Blend;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;True;0;True;TransparentCutout;;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;35;3;38;0
WireConnection;35;4;37;0
WireConnection;54;0;35;1
WireConnection;22;3;26;0
WireConnection;22;4;13;0
WireConnection;5;3;11;0
WireConnection;5;4;13;0
WireConnection;53;0;35;1
WireConnection;53;1;54;0
WireConnection;9;3;11;0
WireConnection;9;4;13;0
WireConnection;29;0;5;0
WireConnection;29;1;22;0
WireConnection;29;2;53;0
WireConnection;7;3;11;0
WireConnection;7;4;13;0
WireConnection;21;3;26;0
WireConnection;21;4;13;0
WireConnection;24;3;26;0
WireConnection;24;4;13;0
WireConnection;46;12;18;0
WireConnection;20;0;21;1
WireConnection;16;3;11;0
WireConnection;16;4;13;0
WireConnection;47;0;46;26
WireConnection;47;1;29;0
WireConnection;47;2;49;0
WireConnection;25;3;26;0
WireConnection;25;4;13;0
WireConnection;17;0;7;1
WireConnection;31;0;9;0
WireConnection;31;1;24;0
WireConnection;31;2;53;0
WireConnection;8;8;12;0
WireConnection;8;3;11;0
WireConnection;8;4;13;0
WireConnection;23;3;26;0
WireConnection;23;4;13;0
WireConnection;33;0;17;0
WireConnection;33;1;20;0
WireConnection;33;2;53;0
WireConnection;30;0;8;0
WireConnection;30;1;23;0
WireConnection;30;2;53;0
WireConnection;44;0;31;0
WireConnection;44;1;47;0
WireConnection;32;0;16;1
WireConnection;32;1;25;1
WireConnection;32;2;53;0
WireConnection;0;0;29;0
WireConnection;0;1;30;0
WireConnection;0;2;44;0
WireConnection;0;3;32;0
WireConnection;0;4;33;0
WireConnection;0;10;46;0
ASEEND*/
//CHKSM=50E89C69E546DEBE531F87F180840B52BF657775