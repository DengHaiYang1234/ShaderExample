// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "Unlit/WorlSpaceNormal"
{
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

			struct v2f
			{
				float3 worldNormal: TEXCOORD0;
				
				float4 vertex : SV_POSITION;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			
			v2f vert (float4 vertex : POSITION,float3 normal : NORMAL)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(vertex);
				o.worldNormal = mul(unity_ObjectToWorld,normal);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				fixed4 col = 0;
				col.rgb = i.worldNormal*0.5+0.5;
				return col;
			}
			ENDCG
		}
	}
}
