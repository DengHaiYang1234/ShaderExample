Shader "SurfaceShader - Examples/NormalExtrusion" {
	Properties {
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_Amount("Extrusion Amount",Range(-1,1)) = 0.5
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		
		CGPROGRAM
		
		//Fuck  :的前面或后面加空格都会识别不了
		#pragma surface surf Lambert vertex:vert

		struct Input 
		{
			float2 uv_MainTex;
		};

		float _Amount;
		sampler2D _MainTex;
		
		void vert (inout appdata_full v)
		{
			//顶点坐标沿法线拉伸
			v.vertex.xyz += v.normal * _Amount;
		}

		void surf (Input IN, inout SurfaceOutput o) 
		{
			o.Albedo = tex2D (_MainTex, IN.uv_MainTex).rgb;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
