Shader "Hidden/Transparent"
{
	SubShader
	{
		Tags {"Queue" = "Transparent"}
		Pass
		{
			Blend SrcAlpha OneMinusSrcAlpha
			//此处关闭深度写入是因为，当有两个半透明物体存在的时候，有一方的颜色会被剔除
			ZWrite off
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

			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				return o;
			}
			

			fixed4 frag (v2f i) : SV_Target
			{
				fixed4 col = fixed4(1,1,1,0.5);
				return col;
			}
			ENDCG
		}
	}
}
