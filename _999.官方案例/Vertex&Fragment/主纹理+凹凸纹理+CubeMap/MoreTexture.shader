// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "Hidden/Shader"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_BumpTex("Bump",2D) = "" {}
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
				float4 tangent : TANGENT;
				float3 normal : NORMAL;
				float4 uv_pos : TEXCOORD0;
			};

			struct v2f
			{
				float4 vertex : SV_POSITION;
				float3 worldPos : TEXCOORD0;
				float3 x_wTangent : TEXCOORD1;
				float3 y_wTangent : TEXCOORD2;
				float3 z_wTangent : TEXCOORD3;
				float2 uv : TEXCOORD4;
			};

			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);

				o.worldPos = mul(unity_ObjectToWorld,v.vertex).xyz;

				float3 wTangent = normalize(mul(unity_ObjectToWorld,v.tangent).xyz);

				float3 wNormal = normalize(UnityObjectToWorldNormal(v.normal));

				float tangentSign = v.tangent.w * unity_WorldTransformParams.w;

				float3 w_bTangent = cross(wTangent,wNormal) * tangentSign;
				//确立切线空间坐标系
				o.x_wTangent = float3(wTangent.x,w_bTangent.x,wNormal.x);

				o.y_wTangent = float3(wTangent.y,w_bTangent.y,wNormal.y);

				o.z_wTangent = float3(wTangent.z,w_bTangent.z,wNormal.z);

				o.uv = v.uv_pos.xy;

				return o;
			}
			
			sampler2D _MainTex;
			sampler2D _BumpTex;

			fixed4 frag (v2f i) : SV_Target
			{
				//法线贴图存储的法线是属于模型空间的
				float3 normal = UnpackNormal(tex2D(_BumpTex,i.uv));

				float3 worldViewDir = normalize(UnityWorldSpaceViewDir(i.worldPos).xyz);

				//将世界空间的视图方向变换到切线空间
				float3 wNormal;
				wNormal.x = dot(i.x_wTangent,normal);
				wNormal.y = dot(i.y_wTangent,normal);
				wNormal.z = dot(i.z_wTangent,normal);

				wNormal = normalize(wNormal);

				float3 worldReflect = reflect(-worldViewDir,wNormal);

				half4 skyData = UNITY_SAMPLE_TEXCUBE(unity_SpecCube0,worldReflect);

				half3 skyColor = DecodeHDR(skyData,unity_SpecCube0_HDR);

				fixed4 col = fixed4(skyColor,0);

				fixed3 baseColor = tex2D(_MainTex,i.uv).rgb;

				col.rgb *= baseColor;

				return col;
			}
			ENDCG
		}
	}
}
