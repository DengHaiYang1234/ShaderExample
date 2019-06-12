Shader "Custom/WorldReflce1" {
	Properties {
		_Color ("Color", Color) = (1,1,1,1)
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_Cube("Cube",CUBE) = "" {}
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		
		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf Lambert

		sampler2D _MainTex;

		struct Input {
			float2 uv_MainTex;
			float3 worldRef1;
		};

		half _Glossiness;
		half _Metallic;
		fixed4 _Color;
		samplerCUBE _Cube;
		
		void surf (Input IN, inout SurfaceOutput o) {
			// Albedo comes from a texture tinted by color
			o.Albedo = tex2D (_MainTex, IN.uv_MainTex).rgb * 0.5;
			o.Emission = texCUBE(_Cube,IN.worldRef1).rgb;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
