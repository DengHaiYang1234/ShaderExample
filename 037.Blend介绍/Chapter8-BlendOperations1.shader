// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Unity Shaders Book/Chapter 8/Blend Operations 11" {
	Properties {
		_Color ("Color Tint", Color) = (1, 1, 1, 1)
		_MainTex ("Main Tex", 2D) = "white" {}
		_AlphaScale ("Alpha Scale", Range(0, 1)) = 1
	}
	SubShader {
		Tags {"Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent"}
		
		Pass {
			Tags { "LightMode"="ForwardBase" }
			
			ZWrite Off
			
//			// Normal 正常
			// 混合区域颜色： O（rgb） = SrcAlpha * Src（rgb） + （1-SrcAlpha） * Dst（rgb） 
//			Blend SrcAlpha  OneMinusSrcAlpha
//			
//			// Soft Additive 柔性相加 混合区域会稍微变亮
			// 混合区域颜色：O（rgb） = （1 - DstColor） * Src（rgb） + 1 * Dst（rgb）
//			Blend OneMinusDstColor One
//			
//			// Multiply 正片叠低 稍微变淡
			// 混合区域颜色：O（rgb） = DstColor * Src（rgb） + 0
//			Blend DstColor Zero
//			
//			// 2x Multiply 混合区域会加倍与源颜色混合
			// 混合区域颜色：O（rgb） = DstColor * Src（rgb） + SrcColor * Dst（rgb） 
//			Blend DstColor SrcColor
//			
//			// Darken 混合区域必定变暗
			// 混合区域颜色：O(rgb) = (min(S(r),D(r)),min(S(g),D(g)),min(S(b),D(g)),min(S(a),D(a)))
//			BlendOp Min
//			Blend One One	// When using Min operation, these factors are ignored
//			
//			//  Lighten 混合区域必定变亮
			// 混合区域颜色：O(rgb) = (max(S(r),D(r)),max(S(g),D(g)),max(S(b),D(g)),max(S(a),D(a)))
//			BlendOp Max
//			Blend One One // When using Max operation, these factors are ignored
//			
//			// Screen
			// 混合区域颜色：O（rgb） = （1 - DstColor） * Src（rgb） + 1 * Dst（rgb）
//			Blend OneMinusDstColor One
			// Or
//			Blend One OneMinusSrcColor
//			
//			// Linear Dodge 混合区域必定变亮
			// 混合区域颜色：O（rgb） = Src（rgb） + Dst（rgb）
			Blend One One
			
			CGPROGRAM
			
			#pragma vertex vert
			#pragma fragment frag
			
			#include "Lighting.cginc"
			
			fixed4 _Color;
			sampler2D _MainTex;
			float4 _MainTex_ST;
			fixed _AlphaScale;
			
			struct a2v {
				float4 vertex : POSITION;
				float3 normal : NORMAL;
				float4 texcoord : TEXCOORD0;
			};
			
			struct v2f {
				float4 pos : SV_POSITION;
				float2 uv : TEXCOORD0;
			};
			
			v2f vert(a2v v) {
			 	v2f o;
			 	o.pos = UnityObjectToClipPos(v.vertex);

			 	o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);
			 	
			 	return o;
			}
			
			fixed4 frag(v2f i) : SV_Target {				
				fixed4 texColor = tex2D(_MainTex, i.uv);
			 	
				return fixed4(texColor.rgb * _Color.rgb, texColor.a * _AlphaScale);
			}
			
			ENDCG
		}
	} 
	FallBack "Transparent/VertexLit"
}
