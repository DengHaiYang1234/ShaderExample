Shader "SurfaceShader - Examples/CustomVertexData" {
	Properties 
	{
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		
		CGPROGRAM
		#pragma surface surf Lambert vertex:vert

		sampler2D _MainTex;

		struct Input 
		{
			float2 uv_MainTex;
			float3 customColor;
		};

		void vert(inout appdata_full v,out Input o)
		{
			UNITY_INITIALIZE_OUTPUT(Input,o);
			//自定义颜色值范围【0，1】
			o.customColor = abs(v.normal);
		}

		void surf (Input IN, inout SurfaceOutput o) 
		{
			o.Albedo = tex2D (_MainTex, IN.uv_MainTex).rgb;
			//取每个顶点对应法线值
			o.Albedo *= IN.customColor;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
