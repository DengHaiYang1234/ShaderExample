Shader "Hidden/ReceivingShadow"
{
	Properties
	{
		[NoScaleOffest]_MainTex ("Texture", 2D) = "white" {}
	}
	SubShader
	{
		Pass
		{
			Tags {"LightMode" = "ForwardBase"}

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			#include "Lighting.cginc"

			#pragma multi_compile_fwdbase nolightmap nodirlightmap nodynlightmap novertexlight

			#include "AutoLight.cginc"


			struct v2f
			{
				float2 uv : TEXCOORD0;
				//声明阴影变量
				SHADOW_COORDS(1) 
				float4 pos : SV_POSITION;
				fixed3 diff : COLOR0;
				fixed3 ambient : COLOR1;

			};

			v2f vert (appdata_base v)
			{
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.uv = v.texcoord.xy;
				half3 worldNormal = UnityObjectToWorldNormal(v.normal);
				half nl = max(0,dot(worldNormal,_WorldSpaceLightPos0.xyz));
				o.diff = nl * _LightColor0.rgb;
				o.ambient = ShadeSH9(half4(worldNormal,1));
				//计算阴影数据
				TRANSFER_SHADOW(o)
				return o;
			}
			
			sampler2D _MainTex;

			fixed4 frag (v2f i) : SV_Target
			{
				fixed4 col = tex2D(_MainTex,i.uv);
				//计算阴影衰减（1:最亮 0:只有阴影）
				fixed4 shadow = SHADOW_ATTENUATION(i);

				fixed3 lighting = i.diff * shadow + i.ambient;
				col.rgb *= lighting;

				return col;
			}
			ENDCG
		}
		 // shadow casting support
        UsePass "Legacy Shaders/VertexLit/SHADOWCASTER"
	}
}
