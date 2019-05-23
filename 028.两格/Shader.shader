Shader "Hidden/Shader"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_OtherTex("OtherTex",2D) = "White" {}
		_R("R",Range(0,0.5)) = 0.25
	}



	SubShader
	{
		Pass
		{
			//Blend SrcAlpha OneMinusSrcAlpha

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
			float4 _MainTex_ST;

			sampler2D _OtherTex;

			sampler2D _OtherTex_1;

			float _R;

			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv;
				return o;
			}
			


			fixed4 frag (v2f i) : SV_Target
			{
				float2 uv = i.uv;

				float  uv_y_2 =  uv.y - _R;

				float uv_y_1 = uv.y + (0.5 - _R);

				float t = floor(uv.y / 0.5);

				//return tex2D(_MainTex,float2(uv.x,uv_y_1));

				return lerp(tex2D(_MainTex,float2(uv.x,uv_y_1)),tex2D(_OtherTex,float2(uv.x,uv_y_2)),t);
			}
			ENDCG
		}
	}
}
