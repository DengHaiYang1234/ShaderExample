Shader "SurfaceShader - Examples/CubeMap - WorldNormalMap" {
	Properties {
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_BumpTex("BumpTex",2D) = "bump" {}
		_Cube("CubeMap",CUBE) = "" {}
	}
	SubShader {
		Tags { "RenderType"="Opaque" }

		
		CGPROGRAM
		#pragma surface surf Lambert

		sampler2D _MainTex;
		sampler2D _BumpTex;
		samplerCUBE _Cube;

		struct Input 
		{
			float2 uv_MainTex;
			float2 uv_BumpTex;
			float3 worldRefl;
			INTERNAL_DATA
		};
		
		void surf (Input IN, inout SurfaceOutput o) 
		{
			o.Albedo = tex2D (_MainTex, IN.uv_MainTex).rgb;
			o.Normal = UnpackNormal(tex2D(_BumpTex,IN.uv_BumpTex));
			//WorldReflectionVector：计算每个像素的反射向量  世界空间的反射向量 ？
			o.Emission = texCUBE(_Cube,WorldReflectionVector(IN,o.Normal)).rgb;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
