// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "Unity Shaders Book/ Chapter 10/GlassRefraction"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_BumpTex("BumpTex",2D) = "" {}
		_CubeMap("CubeMap",CUBE) = "" {}
		//歪曲程度
		_Distortion("Distortion",Range(0,100)) = 10
		_RefractAmount("Refract Amount",Range(0.0,1.0)) = 1.0
	}

	SubShader
	{

		Tags {"Queue" = "Transparent" "RenderType" = "Opaque"}

		//定义一个抓取屏幕图像的Pass。将抓取的图像存在_RefractionTex纹理中
		GrabPass{"_RefractionTex"}

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			sampler2D _MainTex;
			float4 _MainTex_ST;
			sampler2D _BumpTex;
			float4 _BumpTex_ST;
			samplerCUBE _CubeMap;
			float _Distortion;
			fixed _RefractAmount;
			sampler2D _RefractionTex;
			//TexelSize可以得到该纹理的纹素大小。例如（256,512）的纹理，它的纹素大小为（1/256,1/512）
			float4 _RefractionTex_TexelSize;
			

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
				float3 normal : NORMAL;
				float4 tangent : TANGENT;
			};

			struct v2f
			{
				float4 pos : SV_POSITION;
				float4 srcPos : TEXCOORD0;
				float4 uv : TEXCOORD1;
				float4 T2W0 :TEXCOORD2;
				float4 T2W1 :TEXCOORD3;
				float4 T2W2 :TEXCOORD4;
			};

			v2f vert (appdata v)
			{
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				//被抓取的屏幕图像的采样坐标
				o.srcPos = ComputeGrabScreenPos(o.pos);	

				o.uv.xy = TRANSFORM_TEX(v.uv,_MainTex);
				o.uv.zw = TRANSFORM_TEX(v.uv,_BumpTex);

				float3 worldPos = mul(unity_ObjectToWorld,v.vertex).xyz;

				float3 worldNormal = UnityObjectToWorldNormal(v.normal);

				fixed3 worldTangent = UnityObjectToWorldDir(v.tangent.xyz);

				fixed3 worldBinormal = cross(worldNormal,worldTangent) * v.tangent.w;

				o.T2W0 = float4(v.tangent.x,worldBinormal.x,worldNormal.x,worldPos.x);
				o.T2W1 = float4(v.tangent.y,worldBinormal.y,worldNormal.y,worldPos.y);
				o.T2W2 = float4(v.tangent.z,worldBinormal.z,worldNormal.z,worldPos.z);

				return o;
			}
			
			

			fixed4 frag (v2f i) : SV_Target
			{
				float3 worldPos = float3(i.T2W0.w,i.T2W1.w,i.T2W2.w);
				fixed3 worldViewDir = normalize(UnityWorldSpaceViewDir(worldPos));
				//采样法线贴图，获取法线信息
				fixed3 bump = UnpackNormal(tex2D(_BumpTex,i.uv.zw));
				//模拟折射效果
				float2 offest = bump.xy * _Distortion * _RefractionTex_TexelSize.xy;

				i.srcPos.xy = offest + i.srcPos.xy;
				//采样_RefractionTex  i.srcPos.xy / i.srcPos.w：透视除法，得到真正的屏幕坐标     最后得到折射的颜色
				fixed3 refrCol = tex2D(_RefractionTex,i.srcPos.xy / i.srcPos.w).rgb;
				//将法线贴图的法线变换值世界空间下的切线空间中
				bump = normalize(half3(dot(i.T2W0.xyz,bump),dot(i.T2W1.xyz,bump),dot(i.T2W2.xyz,bump)));
				//反射方向
				fixed3 reflDir = reflect(-worldViewDir,bump);
				//采样主纹理
				fixed4 texColor = tex2D(_MainTex,i.uv.xy);
				//采样CubeMap  并混合与主纹理的颜色
				fixed3 reflColor = texCUBE(_CubeMap,reflDir).rgb * texColor.rgb;
				//反射强度成反比的颜色 + 抓取图像成正比的颜色
				fixed3 finalColor = reflColor * (1 - _RefractAmount) + refrCol * _RefractAmount;

				return fixed4(finalColor,1.0);
			}
			ENDCG
		}
	}
}
