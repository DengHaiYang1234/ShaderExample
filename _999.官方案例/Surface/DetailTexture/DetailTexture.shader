Shader "SurfaceShader - Examples/DetailTexture" {
	Properties 
	{
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_BumpTex("BumpTex",2D) = "bump" {}
		_DetialTex("DetialTex",2D) = "gray" {}

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
		};


		void surf (Input IN, inout SurfaceOutput o) 
		{
			o.Albedo = tex2D (_MainTex, IN.uv_MainTex).rgb ;
			o.Albedo *= tex2D(_DetialTex,IN.uv_DetialTex).rgb * 2;
			o.Normal = UnpackNormal(tex2D(_BumpTex,IN.uv_BumpTex));
		}
		ENDCG
	}
	FallBack "Diffuse"
}
