// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "Unity Shaders Book/ Chapter 10/Reflection"
{
	Properties
	{
		_Color("Color Tint",Color) = (1,1,1,1)
		//反射颜色
		_ReflecColor("Reflect Color",Color) = (1,1,1,1)
		//反射程度
		_ReflectAmount("Reflect Amount",Range(0,1)) = 1
		_CubeMap("Cube Map",CUBE) = "_Skybox" {}
	}

	SubShader
	{
		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			#include "AutoLight.cginc"
			
			#include "UnityCG.cginc"
			#include "Lighting.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
				float3 normal : NORMAL;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 pos : SV_POSITION;
				float3 worldNormal : TEXCOORD1;
				float3 worldPos : TEXCOORD2;
				float3 worldViewDir : TEXCOORD3;
				float3 worldReflect : TEXCOORD4;
			};

			v2f vert (appdata v)
			{
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);

				o.worldNormal = UnityObjectToWorldNormal(v.normal);

				o.worldPos = mul(unity_ObjectToWorld,v.vertex).xyz;

				o.worldViewDir = normalize(UnityWorldSpaceViewDir(o.worldPos));


				o.worldReflect = reflect(-o.worldViewDir,o.worldNormal);

				o.uv = v.uv;
				return o;
			}
			
			fixed4 _Color;
			fixed4 _ReflecColor;
			float _ReflectAmount;
			samplerCUBE _CubeMap;

			fixed4 frag (v2f i) : SV_Target
			{
				fixed3 worldNormal = i.worldNormal;
				fixed3 worldLightDir = normalize(UnityWorldSpaceLightDir(i.worldPos));
				fixed3 worldViewDir = i.worldViewDir;

				fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz;

				fixed3 diffuse = _LightColor0.rgb * _Color.rgb * max(0,dot(worldNormal,worldLightDir));

				fixed3 reflection = texCUBE(_CubeMap,i.worldReflect).rgb * _ReflecColor.rgb;

				//AutoLight.cginc
				UNITY_LIGHT_ATTENUATION(atten,i,i.worldPos);

				fixed3 color = ambient + lerp(diffuse,reflection,_ReflectAmount) * atten;

				return fixed4(color,1.0);
			}
			ENDCG
		}
	}
}
