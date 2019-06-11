Shader "SurfaceShader - Examples/RimLight" {
	Properties {
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_BumpTex("BumpTex",2D) = "white" {}
		_RimColor("RimColor",Color) = (1,1,1,1)
		_RimPower("RimPower",Range(0.5,8.0)) = 0.2
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		
		CGPROGRAM
		#pragma surface surf Lambert

		sampler2D _MainTex;
		sampler2D _BumpTex;
		fixed4 _RimColor;
		float _RimPower;

		struct Input 
		{
			float2 uv_MainTex;
			float2 uv_BumpTex;
			float3 viewDir;
		};
		
		void surf (Input IN, inout SurfaceOutput o) 
		{
			o.Albedo = tex2D (_MainTex, IN.uv_MainTex).rgb;
			o.Normal = UnpackNormal(tex2D(_BumpTex,IN.uv_BumpTex));
			//计算边缘光 视角方向与法线的叉积。为0就是边缘
			float rim_dot = 1 -  saturate(dot(normalize(IN.viewDir),o.Normal));
			//Emission：模型自发光
			o.Emission = _RimColor.rgb * pow(rim_dot,_RimPower);
		}
		ENDCG
	}
	FallBack "Diffuse"
}
