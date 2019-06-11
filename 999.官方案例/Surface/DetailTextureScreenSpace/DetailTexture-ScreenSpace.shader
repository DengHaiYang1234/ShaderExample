Shader "SurfaceShader - Examples/DetailTexture-ScreenSpace" {
	Properties 
	{
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_BumpTex("BumpTex",2D) = "white" {}
		_DetialTex("DetailTex",2D) = "white" {}
	}

	SubShader {
		Tags { "RenderType"="Opaque" }
		
		CGPROGRAM
		#pragma surface surf Lambert

		sampler2D _MainTex;
		sampler2D _BumpTex;
		sampler2D _DetialTex;

		struct Input 
		{
			float2 uv_MainTex;
			float2 uv_BumpTex;
			float2 uv_DetialTex;
			float4 screenPos;

		};

		
		void surf (Input IN, inout SurfaceOutput o) 
		{
			o.Albedo = tex2D (_MainTex, IN.uv_MainTex).rgb;

			float2 screenUV = IN.screenPos.xy / IN.screenPos.w;
			screenUV *= float2(8,6);
			//使用屏幕uv来采样
			o.Albedo *= tex2D (_DetialTex, screenUV).rgb;

			o.Normal = UnpackNormal(tex2D(_BumpTex,IN.uv_BumpTex));

		}
		ENDCG
	}
	FallBack "Diffuse"
}
