// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'

Shader "Hidden/Shader"
{

	Properties
	{
		_MainColor("MainColor",Color) = (1,1,1,1)
		_Scale("Scale",Range(1,10)) = 2
		//边缘光半径
		_R("R",Range(0.1,1)) = 2

		_Narrow("Narrow",Range(0,1)) = 0.5
	}

	SubShader
	{
		Tags {"Queue" = "Transparent"}

		//主要用来渲染边缘半径强度泛光
		Pass
		{

			Blend SrcAlpha OneMinusSrcAlpha
			ZWrite Off
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"

			float _R;

			struct appdata
			{
				float4 vertex : POSITION;
			};

			struct v2f
			{
				float4 vertex : SV_POSITION;
				float3 normal : TEXCOORD0;
				float4 pos : TEXCOORD1;
			};


			v2f vert (appdata_base v)
			{
				v.vertex += float4(v.normal,0) * _R;
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.normal = normalize(mul(float4(v.normal,0),unity_WorldToObject).xyz);
				o.pos = v.vertex;
				return o;
			}

			float _Scale;
			fixed4 _MainColor;

			
			fixed4 frag (v2f i) : SV_Target
			{

				float3 N = i.normal;

				float3 V = normalize(WorldSpaceViewDir(i.pos));

				float dot_NV =saturate(dot(N,V));

				dot_NV = pow(dot_NV,_Scale);

				fixed4 col = _MainColor;
				col.a *= dot_NV;
				
				return col;
			}
			ENDCG
		}

		//主要用来渲染中间透明部分
		Pass
		{

			Blendop RevSub
			//1 * dst(rgb) - dstAlpha * src(rgb) 
			Blend dstAlpha one
			ZWrite Off
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
			};

			struct v2f
			{
				float4 vertex : SV_POSITION;

			};


			v2f vert (appdata_base v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);

				return o;
			}

			fixed4 _MainColor;

			fixed4 frag (v2f i) : SV_Target
			{
				fixed4 col = _MainColor;
				
				return col;
			}
			ENDCG
		}

		//主要用来渲染透明+边缘淡光
		Pass
		{
			Blend SrcAlpha OneMinusSrcAlpha
			ZWrite Off
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
			};

			struct v2f
			{
				float4 vertex : SV_POSITION;
				float3 normal : TEXCOORD0;
				float4 pos : TEXCOORD1;
			};


			v2f vert (appdata_base v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.normal = normalize(mul(float4(v.normal,0),unity_WorldToObject).xyz);
				o.pos = v.vertex;
				return o;
			}

			float _Scale;
			fixed4 _MainColor;

			
			fixed4 frag (v2f i) : SV_Target
			{

				float3 N = i.normal;

				float3 V = normalize(WorldSpaceViewDir(i.pos));

				float dot_NV = 1 -  saturate(dot(N,V));

				dot_NV = pow(dot_NV,_Scale);

				fixed4 col = _MainColor * dot_NV;
				
				
				return col;
			}
			ENDCG
		}

	}
}
