Shader "Hidden/chongying"
{
	//对图片缩放的本质是取决与UV采样坐标
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		
		_CenterX("放大中心点X", Range(0, 1)) = 0.5
		_CenterY("放大中心点Y", Range(0, 1)) = 0.5
		_Scale("放大倍率", Range(1, 2)) = 1
		_ScaleOrig("底图放大倍率", Range(1, 1.5)) = 1
		_Opacity("重影最大透明度", Range(0, 1)) = 0
		
		_MultiplyColor("放大时偏向的颜色", Color) = (0, 0, 0, 1)	 	 
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

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				UNITY_FOG_COORDS(1)
				float4 vertex : SV_POSITION;
			};
			
			sampler2D _MainTex;
			float4 _MainTex_ST;

			float _CenterX;
		    float _CenterY;
		    float _Scale;
		    float _ScaleOrig;
		    fixed _Opacity;
		    
		    fixed4 _MultiplyColor;
			
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				UNITY_TRANSFER_FOG(o,o.vertex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
			    float2 uv;
				//采样坐标是根据_ScaleOrig的大小来决定的。例如_ScaleOrig = 0.5,那么采样的范围就是0.25 - 0.75
			    uv.x = _CenterX + (i.uv.x - _CenterX) * (1 / _ScaleOrig);
			    uv.y = _CenterY + (i.uv.y - _CenterY) * (1 / _ScaleOrig);
				// sample the texture
				fixed4 col = tex2D(_MainTex, uv);			

			    float2 uv1;
				//采样坐标是根据_Scale的大小来决定的
			    uv1.x = _CenterX + (i.uv.x - _CenterX) * (1 / _Scale);
			    uv1.y = _CenterY + (i.uv.y - _CenterY) * (1 / _Scale);			    
			    fixed4 mask = tex2D(_MainTex, uv1);
			    
				// apply fog
				UNITY_APPLY_FOG(i.fogCoord, col);
				
				fixed4 mid = lerp(mask, _MultiplyColor, 0.85);
				
				return lerp(col, mid, _Opacity * 1.5);
			}
			
			
			ENDCG
		}
	}
}
