Shader "Hidden/Shader"
{

	Properties
	{
		_NormalTex("NormalTex",2D) = "white" {}
	}

	SubShader
	{
		Tags {"Queue" = "Geometry"}
		Pass
		{
			Tags {"LightMode" = "ForwardBase"}
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			#include "Lighting.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				
			};

			struct v2f
			{
				float4 vertex : SV_POSITION;
				float3 worldPos : TEXCOORD0;
				float2 uv : TEXCOORD1;
				float3 lightDir : TEXCOORD2;
			};

			sampler2D _NormalTex;

			v2f vert (appdata_tan v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.worldPos = mul(unity_ObjectToWorld,v.vertex).xyz;
				o.uv = v.texcoord.xy;

				// 通过切线与法线的叉乘得到副切线，构成纹理空间坐标系 X：切线 Y：副切线 Z：法线 
				//这样做是因为使用法线贴图的时候，法线贴图中存储的不同面顶点的法线方向可能相同，那么不同面的光照强弱就会存在问题。使用该纹理切线空间，能够避免这种问题
				// float3 bNormal = cross(v.tangent.xyz,v.normal);
				// //纹理空间矩阵
				// float3x3 rotation = float3x3(v.tangent.xyz,bNormal,v.normal);

				//Unity内置的方法
				TANGENT_SPACE_ROTATION;

				o.lightDir = mul(rotation,_WorldSpaceLightPos0.xyz);



				return o;
			}
			

			fixed4 frag (v2f i) : SV_Target
			{
				float3 L = normalize(i.lightDir);

				float3 N = UnpackNormal(tex2D(_NormalTex,i.uv));
				N = normalize(N);

				float NL_DOt = saturate(dot(L,N));

				fixed4 col = _LightColor0 * NL_DOt;

				col.rgb += Shade4PointLights(
					unity_4LightPosX0, unity_4LightPosY0, unity_4LightPosZ0,
					unity_LightColor[0].rgb,unity_LightColor[1].rgb,unity_LightColor[2].rgb,unity_LightColor[3].rgb,
					unity_4LightAtten0,
					i.worldPos,N
				);

				return col + UNITY_LIGHTMODEL_AMBIENT;
			}
			ENDCG
		}


		//处理点光源
		Pass
		{
			Tags {"LightMode" = "ForwardAdd"}

			//即输出平行光又输出点光源
			Blend One One
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			#include "Lighting.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				
			};

			struct v2f
			{
				float4 vertex : SV_POSITION;
				float3 worldPos : TEXCOORD0;
				float2 uv : TEXCOORD1;
				float3 lightDir : TEXCOORD2;
			};

			sampler2D _NormalTex;

			v2f vert (appdata_tan v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.worldPos = mul(unity_ObjectToWorld,v.vertex).xyz;
				o.uv = v.texcoord.xy;

				// 通过切线与法线的叉乘得到副切线，构成纹理空间坐标系 X：切线 Y：副切线 Z：法线 
				//这样做是因为使用法线贴图的时候，法线贴图中存储的不同面顶点的法线方向可能相同，那么不同面的光照强弱就会存在问题。使用该纹理切线空间，能够避免这种问题
				// float3 bNormal = cross(v.tangent.xyz,v.normal);
				// //纹理空间矩阵
				// float3x3 rotation = float3x3(v.tangent.xyz,bNormal,v.normal);

				//Unity内置的方法
				TANGENT_SPACE_ROTATION;

				//若是平行光 _WorldSpaceLightPos0.xyz记录的是个方向 若是点光源：_WorldSpaceLightPos0.xyz记录的仅是个位置信息
				o.lightDir = mul(rotation,_WorldSpaceLightPos0.xyz);



				return o;
			}
			

			fixed4 frag (v2f i) : SV_Target
			{
				float3 L = normalize(i.lightDir);

				float3 N = UnpackNormal(tex2D(_NormalTex,i.uv));
				N = normalize(N);

				float NL_DOt = saturate(dot(L,N));

				float atten = 1;

				//简单的光照衰减系数
				if(_WorldSpaceLightPos0.w != 0)
					atten = 1.0 / length(i.lightDir);

				fixed4 col = _LightColor0 * NL_DOt * atten;


				return col + UNITY_LIGHTMODEL_AMBIENT;
			}
			ENDCG
		}
	}
}
