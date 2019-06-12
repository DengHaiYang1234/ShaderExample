// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

//通过切线空间来进行反射
Shader "Unlit/SkyReflectionTangentSpace"
{
	Properties
	{
		_BumpTex("BumpTex",2D) = "white" {}
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }
		LOD 100

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"


			struct v2f
			{
				float4 vertex : SV_POSITION;
				float3 tanSpa0 : TEXCOORD0;
				float3 tanSpa1 : TEXCOORD1;
				float3 tanSpa2 : TEXCOORD2;
				float3 worldPos : TEXCOORD3;
				float2 uv : TEXCOORD4;
			};



			sampler2D _MainTex;
			float4 _MainTex_ST;
			
			v2f vert (float4 vertex : POSITION,float3 normal : NORMAL,float4 tangent : TANGENT,float2 uv : TEXCOORD0)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(vertex);
				float3 v_normal = normalize(mul(unity_ObjectToWorld,normal));
				float3 v_tangent = normalize(mul(unity_ObjectToWorld,tangent.xyz));
				o.worldPos = mul(unity_ObjectToWorld,vertex).xyz;

				half tangentSign = tangent.w * unity_WorldTransformParams;

				float3 btangent = cross(v_tangent,v_normal) * tangentSign;

				o.tanSpa0 = (v_tangent.x,btangent.x,v_normal.x);
				o.tanSpa1 = (v_tangent.y,btangent.y,v_normal.y);
				o.tanSpa2 = (v_tangent.z,btangent.z,v_normal.z);

				o.uv = uv;
				return o;
			}

			sampler2D _BumpTex;
			
			fixed4 frag (v2f i) : SV_Target
			{
				// sample the texture
				float3 tnormal = UnpackNormal(tex2D(_BumpTex,i.uv));
				float3 worldNormal;

				worldNormal.x = dot(i.tanSpa0,tnormal);
				worldNormal.y = dot(i.tanSpa1,tnormal);
				worldNormal.z = dot(i.tanSpa2,tnormal);

				float3 worldViewDir = normalize(UnityWorldSpaceViewDir(i.worldPos));

				float3 reflectDir = reflect(-worldViewDir,worldNormal);

				float4 shydata = UNITY_SAMPLE_TEXCUBE(unity_SpecCube0,reflectDir);
				float3 skyColor = DecodeHDR(shydata,unity_SpecCube0_HDR);

				fixed4 col = 0;
				col.rgb = skyColor;


				return col;
			}
			ENDCG
		}
	}
}
