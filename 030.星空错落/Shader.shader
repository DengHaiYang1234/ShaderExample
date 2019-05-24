Shader "Hidden/Shader"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_W("W",Range(0,10)) = 0.5
		_A("A",Range(0,0.5)) = 0.05
	}
	SubShader
	{
		Pass
		{
			//颜色遮罩  只输出那种颜色  有三种：R，G，B
			colormask rg

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
			float _A;
			float _W;

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

				float Offest_UV = _A * sin(i.uv * _W  + _Time.x * 2);

				uv += Offest_UV;

				fixed4 color_1 = tex2D(_MainTex, uv);

				uv = i.uv;
				uv -= Offest_UV;

				fixed4 color_2 = tex2D(_MainTex, uv);


				return (color_1 + color_2) /2;
			}
			ENDCG
		}
	}
}
