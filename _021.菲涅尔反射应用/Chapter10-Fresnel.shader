// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "HUnity Shaders Book/ Chapter 10Fresnel"
{
	Properties
	{
		_Color("Color Tint",Color) = (1,1,1,1)
		_FresnelScale("Fresnel Scale",Range(0,1)) = 0.5
		_CubeMap("CubeMap",CUBE) = "_SkyBox" {}
	}
	SubShader
	{
		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "AutoLight.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float3 normal : NORMAL;
			};

			struct v2f
			{
				float4 pos : SV_POSITION;
				float3 worldNormal : TEXCOORD0;
				float3 worldPos : TEXCOORD1;
				float3 worldViewDir : TEXCOORD2;
				float3 worldRefl : TEXCOORD3;
			};

			float _FresnelScale;
			fixed4 _Color;
			samplerCUBE _CubeMap;

			v2f vert (appdata v)
			{
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);

				o.worldNormal = UnityObjectToWorldNormal(v.normal);

				o.worldPos = mul(unity_ObjectToWorld,v.vertex).xyz;

				o.worldViewDir = normalize(UnityWorldSpaceViewDir(o.worldPos));

				o.worldRefl = reflect(-o.worldViewDir,o.worldNormal);

				return o;
			}
			


			fixed4 frag (v2f i) : SV_Target
			{
				fixed3 worldNormal = i.worldNormal;
				fixed3 worldLightDir = normalize(UnityWorldSpaceLightDir(i.worldPos));
				fixed3 worldViewDir = i.worldViewDir;

				fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz;

				UNITY_LIGHT_ATTENUATION(atten,i,i.worldPos);

				fixed3 reflection = texCUBE(_CubeMap,i.worldRefl).xyz;

				//公式：F = F + （1- F） * （1 - dot（v，n），5）
				fixed fresnel = _FresnelScale + (1 - _FresnelScale) * pow(1 - dot(worldViewDir,worldNormal),5);

				fixed3 diffuse = _LightColor0.rgb * _Color.rgb * max(0,dot(worldNormal,worldLightDir));

				fixed3 color = ambient + lerp(diffuse,reflection,saturate(fresnel)) *atten;

				return fixed4(color,1.0);
			}
			ENDCG
		}
	}
}
