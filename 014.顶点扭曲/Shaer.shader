// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Hidden/Shaer"
{
	Properties
	{
		
	}
	SubShader
	{
		// No culling or depth
		Cull Off ZWrite Off ZTest Always

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
				float4 color : TEXCOORD0;
				float4 vertex : SV_POSITION;
			};

			v2f vert (appdata v)
			{
				float2 dVir = (v.vertex.zw - float2(0,0)) * _SinTime.w;

				float theta = sqrt(dot(dVir,dVir));

				//float theta = length(v.vertex) * _SinTime.w;

				float4x4 rotation = 
				{
					float4(cos(theta),0,sin(theta),0),
					float4(0,1,0,0),
					float4(-sin(theta),0,cos(theta),0),
					float4(0,0,0,1)
				};

				v.vertex = mul(rotation,v.vertex);

				v2f o;

				o.vertex = UnityObjectToClipPos(v.vertex);

				o.color = float4(0,1,1,1);
				
				return o;
			}
			

			fixed4 frag (v2f i) : SV_Target
			{
				return i.color;
			}
			ENDCG
		}
	}
}
