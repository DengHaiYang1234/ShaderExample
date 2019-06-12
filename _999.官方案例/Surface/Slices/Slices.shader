Shader "SurfaceShader - Examples/Slices" {
	Properties {

		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_BumpTex("BumpTex",2D) = "" {}

	}
	SubShader {
		Tags { "RenderType"="Opaque" }

		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf Lambert

		sampler2D _MainTex;
		sampler2D _BumpTex;

		struct Input 
		{
			float2 uv_MainTex;
			float2 uv_BumpTex;
			float3 worldPos;
		};


		void surf (Input IN, inout SurfaceOutput o) 
		{
			//丢弃小于0.5的值 等于 if(x <0.3) discard;
			clip(frac((IN.worldPos.y + IN.worldPos.z * 0.1) * 5) - 0.5);
			o.Albedo = tex2D (_MainTex, IN.uv_MainTex).rgb;
			o.Normal = UnpackNormal(tex2D(_BumpTex,IN.uv_BumpTex));

		}
		ENDCG
	}
	FallBack "Diffuse"
}
