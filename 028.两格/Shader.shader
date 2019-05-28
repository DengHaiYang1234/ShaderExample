Shader "Hidden/Shader"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_OtherTex("OtherTex",2D) = "white" {}
		//移动半径
		_R("R",Range(0,0.25)) = 0.25
		//分格比例
		_Ratio("Ratio",Range(0,1)) = 0.5
	}



	SubShader
	{
		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
			};
			sampler2D _MainTex;
			sampler2D _OtherTex;
			float4 _MainTex_ST;
			//移动半径
			float _R;
			float _Ratio;
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);

				o.uv = v.uv;
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				//补像素
				_Ratio += 0.0001;

				//_Ratio += _R;
	
				float2 uv = i.uv;

				// float r = ((1- _Ratio) / 2) + _R;

				// r = lerp(r,0,_Ratio);

				//v的取值是与_Ratio成反比，与_R成正比
				float uv_ohter_y = uv.y + ((1- _Ratio) / 2) + _R;

				uv_ohter_y = lerp(uv_ohter_y,uv_ohter_y - _R,_Ratio);
				
				//v的取值是与_Ratio成正比，与_R成正比
				float uv_main_y = uv.y - (_Ratio - _Ratio / 2) + _R;
				//_Ratio越大，_OtherTex的采样越多，反之亦然
				uv_main_y = lerp(uv_main_y - _R,uv_main_y,_Ratio);

				float t = lerp(ceil(uv.y/ 1 - _Ratio),floor(uv.y / _Ratio),floor(_Ratio / 0.50));
				
				return lerp(tex2D(_OtherTex,float2(uv.x,uv_ohter_y)),tex2D(_MainTex,float2(uv.x,uv_main_y)),t);
			}
			ENDCG
		}
	}
}
