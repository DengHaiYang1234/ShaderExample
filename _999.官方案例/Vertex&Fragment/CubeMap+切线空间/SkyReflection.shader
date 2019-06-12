// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

//作用：反射天空盒
Shader "Unlit/SkyReflection"
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

			struct appdata
			{
				float4 vertex : POSITION;
				float3 normal : NORMAL;
			};

			struct v2f
			{
				float4 vertex : SV_POSITION;
				float3 normal : TEXCOORD1;
				float4 pos : TEXCOORD2;
			};

			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.normal = normalize(mul(unity_ObjectToWorld,v.normal));
				o.pos = v.vertex;

				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				//求得入射的反向量
				float3 worldViewDir = normalize(WorldSpaceViewDir(i.pos).xyz);
				//求的反射向量
				float3 reflecDir = reflect(-worldViewDir,i.normal);	

				//UNITY_SAMPLE_TEXCUBE：可以理解为采样cubemap
				half4 skyData = UNITY_SAMPLE_TEXCUBE(unity_SpecCube0,reflecDir);
				half3 skyColor = DecodeHDR(skyData,unity_SpecCube0_HDR);
				fixed4 col = 0;
				col.rgb = skyColor;
				return col;
			}
			ENDCG
		}
	}
}
