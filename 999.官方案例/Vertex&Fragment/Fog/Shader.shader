Shader "Hidden/Shader"
{

	SubShader
	{
		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			//编译雾效
			#pragma multi_compile_fog 
			
			#include "UnityCG.cginc"

			struct vertexInput
			{
				float4 vertex : POSITION;
				float2 texcoord0 : TEXCOORD0;
			};

			struct fragmentInput
			{
				float2 texcoord0 : TEXCOORD0;
				float4 position : SV_POSITION;
				//声明一个雾的变量 fogCoord : TEXCOORD1
				UNITY_FOG_COORDS(1)
			};

			fragmentInput vert (vertexInput v)
			{
				fragmentInput o;
				o.position = UnityObjectToClipPos(v.vertex);
				o.texcoord0 = v.texcoord0;
				//计算雾量
				UNITY_TRANSFER_FOG(o,o.position);
				return o;
			}
			
			sampler2D _MainTex;

			fixed4 frag (fragmentInput i) : SV_Target
			{
				fixed4 col = fixed4(i.texcoord0.xy,0,0);

				//应用雾
				//UNITY_APPLY_FOG(i.fogCoord,col)


				//Equls
				// #ifdef UNITY_PASS_FORWARDADD
				// 	UNITY_APPLY_FOG_COLOR(i.fogCoord,col,float4(0,0,0,0))
				// #else
				// 	fixed4 myCustomColor = fixed4(0,0,1,0);
				// 	UNITY_APPLY_FOG_COLOR(i.fogCoord,col,myCustomColor);
				// #endif		

				return col;
			}
			ENDCG
		}
	}
}
