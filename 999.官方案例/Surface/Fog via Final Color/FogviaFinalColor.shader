Shader "SurfaceShader - Examples/FogviaFinalColor" {
	Properties 
	{
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_FogColor("Fog Color",Color) = (0.3,0.4,0.7,1.0)
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		
		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf Lambert finalcolor:mycolor vertex:myvert

		sampler2D _MainTex;
		fixed4 _FogColor;

		struct Input 
		{
			float2 uv_MainTex;
			half fog;
		};

		void myvert(inout appdata_full v,out Input data)
		{
			UNITY_INITIALIZE_OUTPUT(Input,data);
			float4 hpos = UnityObjectToClipPos(v.vertex);
			hpos.xy /= hpos.w;
			data.fog = min(1,dot(hpos.xy,hpos.xy) * 0.5);
		}

		void mycolor(Input IN,SurfaceOutput o,inout fixed4 color)
		{
			fixed3 fogcolor = _FogColor.rgb;
			#ifdef UNITY_PASS_FORWARDADD
			fogcolor = 0;
			#endif

			color.rgb = lerp(color.rgb,fogcolor,IN.fog);
		}

		void surf (Input IN, inout SurfaceOutput o) 
		{
			o.Albedo = tex2D (_MainTex, IN.uv_MainTex).rgb;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
