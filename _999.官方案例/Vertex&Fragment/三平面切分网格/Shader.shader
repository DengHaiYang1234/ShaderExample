//Tri-Planar 目的是为了比较均匀地把整张图映射到不规则的模型上，用起来还是非常方便的。
Shader "Hidden/Shader"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_OcclusionMap("OcclusionMap",2D) = "white" {}
		_Tiling("Tiling",float) = 1.0 
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
				float3 normal : NORMAL;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
				float3 objectNormal : TEXCOORD1;
				float3 coords : TEXCOORD2;
			};

			float _Tiling;
			sampler2D _OcclusionMap;
			sampler2D _MainTex;

			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.coords = v.vertex.xyz * _Tiling;
				o.objectNormal = v.normal;
				o.uv = v.uv;
				return o;
			}
			
			

			fixed4 frag (v2f i) : SV_Target
			{
				//[0，1]
				half3 blend = abs(i.objectNormal);
				//还是将值归在[0,1]
				blend /= dot(blend,1.0);

				//从顶点坐标采样
				fixed4 cx = tex2D(_MainTex,i.coords.yz);
				fixed4 cy = tex2D(_MainTex,i.coords.xz);
				fixed4 cz = tex2D(_MainTex,i.coords.xy);
				//利用法线，使采样的结果有凹凸感
				fixed4 c = cx * blend.x + cy * blend.y + cz * blend.z;

				c *= tex2D(_OcclusionMap,i.uv);

				return c;
			}
			ENDCG
		}
	}
}
