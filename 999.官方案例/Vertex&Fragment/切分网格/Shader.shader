//用UV值来划分网格
Shader "Hidden/Shader"
{
	Properties
	{
		_Density("Density",Range(2,50)) = 30
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

			float _Density;

			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv * _Density;
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				fixed2 c = i.uv;
				//UV坐标向下取整  所以取值肯定为整数或xx.5
				c = floor(c) / 2;
				//取小数部分，那么最后结果肯定为0或0.5
				float checker = frac(c.x + c.y) * 2;  

				return checker;
			}
			ENDCG
		}
	}
}
