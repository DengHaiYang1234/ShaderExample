Shader "SurfaceShader - Examples/TintFinalColor" {
	Properties 
	{
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_ColorTint("Clolr Tint",Color) = (1.0,0.6,0.6,1.0)
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		
		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf Lambert finalcolor:mycolor



		sampler2D _MainTex;
		fixed4 _ColorTint;

		struct Input {
			float2 uv_MainTex;
		};

		void mycolor(Input IN,SurfaceOutput o,inout fixed4 color)
		{
			//最终输出颜色
			color *= _ColorTint;
		}



		void surf (Input IN, inout SurfaceOutput o) 
		{
			o.Albedo = tex2D (_MainTex, IN.uv_MainTex).rgb;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
