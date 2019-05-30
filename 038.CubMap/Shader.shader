Shader "Hidden/Shader"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
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
				
			};

			struct v2f
			{
				float4 vertex : SV_POSITION;
				float pos : TEXCOORD0;
				fixed4 color : TEXCOORD1;
			};

			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.pos = v.vertex.z;

				return o;
			}
			
			sampler2D _MainTex;

			fixed4 frag (v2f i) : SV_Target
			{
				float4 col;
				if(i.pos > 0)
					 col = fixed4(1,0,0,1);
				else if(i.pos < 0)
					 col = fixed4(0,0,1,1);
				return col;
			}
			ENDCG
		}
	}
}
