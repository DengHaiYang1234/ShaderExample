// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'

Shader "Hidden/Shader"
{
	Properties
	{
		_Cube("CubMap", Cube) = "white" {}
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
				float3 normal : NORMAL;
			};

			struct v2f
			{
				float4 vertex : SV_POSITION;
				float3 normal : TEXCOORD0;
				float3 viewDir : TEXCOORD1;
			};

			samplerCUBE _Cube;

			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.normal = normalize(mul(float4(v.normal,0),unity_WorldToObject).xyz);
				o.viewDir = normalize(UnityObjectToViewPos(v.vertex));
				return o;
			}
			

			fixed4 frag (v2f i) : SV_Target
			{
				float3 reflect_pos = reflect(-i.viewDir,i.normal);

				fixed4 col = texCUBE(_Cube,reflect_pos);

				return col;
			}
			ENDCG
		}
	}
}
