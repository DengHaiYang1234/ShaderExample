Shader "Unity Shaders Book/ Chapter 12/BrightnessSaturationAndContrast"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_Brightness("Brightness",float) = 1
		_Saturation("Saturation",float) = 1
		_Contrast("Contrast",float) = 1
	}
	SubShader
	{
		// No culling or depth
		Cull Off ZWrite Off ZTest Always

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
			};
			sampler2D _MainTex;

			float _Brightness;
			float _Saturation;
			float _Contrast;

			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv;
				return o;
			}
			
			

			fixed4 frag (v2f i) : SV_Target
			{


				fixed4 col = tex2D(_MainTex, i.uv);

				//亮度调节
				fixed3 finalColor = col.rgb * _Brightness;

				//饱和度
				fixed luminance = 0.2125 * col.r + 0.7154 * col.g + 0.0721 * col.b;

				fixed3 luminanceColor = fixed3(luminance,luminance,luminance);
				//lerp : a + t*(b-a)
				finalColor = lerp(luminanceColor,finalColor,_Saturation);

				//对比度
				fixed3 avgColor = fixed3(0.5,0.5,0.5);
				finalColor = lerp(avgColor,finalColor,_Contrast);

				return fixed4(finalColor,col.a);
				
			}
			ENDCG
		}
	}
}
