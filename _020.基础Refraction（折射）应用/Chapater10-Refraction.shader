// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "Unity Shaders Book/ Chapter 10/Refraction"
{
	Properties
	{
		_Color("Color Tint",Color) = (1,1,1,1)
		_RefractColor("Refraction Color",Color) = (1,1,1,1)
		_RefractAmount("Refraction Amount",Range(0,1)) = 1
		_RefractionRatio("Refraction Ratio",Range(0.1,1)) = 0.5
		_CubeMap("Refraction CubeMap",CUBE) = "_SkyBox" {}
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
				float3 worldRefr : TEXCOORD3;
			};

			float _RefractionRatio;
			float _RefractAmount;
			fixed4 _RefractColor;
			fixed4 _Color;
			samplerCUBE _CubeMap; 


			v2f vert (appdata v)
			{
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);

				o.worldNormal = UnityObjectToWorldNormal(v.normal);

				o.worldPos = mul(unity_ObjectToWorld,v.vertex).xyz;

				o.worldViewDir = normalize(UnityWorldSpaceViewDir(o.worldPos));
				//反射公式
				o.worldRefr = refract(-o.worldViewDir,o.worldNormal,_RefractionRatio);

				return o;
			}
			


			fixed4 frag (v2f i) : SV_Target
			{
				fixed3  worldNormal = i.worldNormal;
				fixed3 worldLightDir = normalize(UnityWorldSpaceLightDir(i.worldPos));
				fixed3 worldViewDir = i.worldViewDir;

				fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz;

				fixed3 diffuse =_LightColor0.rgb * _Color.rgb * max(0,dot(worldNormal,worldLightDir));

				//反射坐标采样
				fixed3 refration = texCUBE(_CubeMap,i.worldRefr).rgb * _RefractColor.rgb;

				UNITY_LIGHT_ATTENUATION(atten,i,i.worldPos);

				fixed3 color = ambient + lerp(diffuse,refration,_RefractAmount) * atten;

				return fixed4(color,1.0);
			}
			ENDCG
		}
	}
}
