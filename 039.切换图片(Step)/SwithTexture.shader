Shader "Hidden/SwithTexture"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_Tex1("Texture 1",2D) = "white" {}
		_Tex2("Texture 2",2D) = "white" {}
		_Speed("Speed",Range(1,10)) =  1	
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
			sampler2D _Tex1;
			sampler2D _Tex2;
			float _Speed;

			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv;
				return o;
			}
			
			

			fixed4 frag (v2f i) : SV_Target
			{

				float time = frac(_Time.y * _Speed);
				float t = floor(time / 0.3);
				
				float t_1 = step(t,0.9); // t < 0.9 return 1 else return 0
				float t_2 = step(t,1.9); // t < 1.9 return 1 else return 0
				float t_3 = step(2,t); // t >= 2 return 1 else return 0
				
				//为0表示 t>1 为1表示t<1
				//float t = t_1 * t_2;
				
				float4 col_1 = tex2D(_MainTex,i.uv);
				float4 col_2 = tex2D(_Tex1,i.uv);
				float4 col_3 = tex2D(_Tex2,i.uv);

				//当t_1 和 t_2 为1时，必定是在 0 <= t < 1
				//当t_2为1时，t_3 必定为0，所以取反，必定是在 1 <= t < 2
				//当t_3>=2时，必定是在 t >= 2
				return  (t_1 * t_2  * col_1) + ((1 - (t_1 * t_2)) * (1 - t_3) * col_2) + (t_3 * col_3);

				//Equlas 上面
				//fixed4 col;
				//if(t >= 0 && t <1)
				//{
					//col = tex2D(_MainTex,i.uv);
				//}
				//else if(t >= 1 && t <2)
				//{
					//col = tex2D(_Tex1,i.uv);
				//}
				//else
				//{
				//	col = tex2D(_Tex2,i.uv);
				//}

				//return col;
			}
			ENDCG
		}
	}
}
