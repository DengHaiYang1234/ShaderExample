Shader "Hidden/Shader"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_A("A",Range(0,1.0)) = 1
		_W("W",Range(0,10)) = 1
		_R("R",Range(0,1)) = 0.5
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

			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv;
				return o;
			}
			
			sampler2D _MainTex;
			float _A;
			float _W;
			float _R;

			fixed4 frag (v2f i) : SV_Target
			{
				float2 uv = i.uv;

				uv += 0.005 * sin(uv * 3.14 * _W + _Time.y);

				float2 dis_uv = uv - float2(0.5,0.5);

				float distance = sqrt(dot(dis_uv,dis_uv));

				float sacle = 0;
				//离半径越远，波越弱（衰减），振幅越小
				_A *= saturate(1 - distance / _R);
				
				sacle = _A * sin(-distance * 3.14 * _W + _Time.y * 2);

				uv += uv * sacle;

				//fixed4 col = (1,0,0,1) * distance;

				fixed4 col = tex2D(_MainTex, uv);// + fixed4(1,1,1,1) * saturate(sacle) * 100;

				return col;
			}
			ENDCG
		}
	}
}
