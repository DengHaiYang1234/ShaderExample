// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'

Shader "Custom/CarColor" {
	Properties {
		_Color ("Color", Color) = (1,1,1,1)
		_SecondColor("SecondColor",Color) = (1,1,1,1)
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_Glossiness ("Smoothness", Range(0,1)) = 0.5
		_Metallic ("Metallic", Range(0,1)) = 0.0
		_Ratio("Ratio",Range(-3.9,3.9)) = 0
		//颜色融合半径
		_R("R",Range(0,1)) = 0.2

		_MainCubeMap("CubeMap",Cube) = "White" {}
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		//**********************要在Srufaceshader中使用vert，一定要事先声明**********************
		#pragma surface surf Standard vertex:vert

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0

		sampler2D _MainTex;
		fixed4 _SecondColor;
		float _Ratio;

		struct Input {
			float2 uv_MainTex;
			float posX;
			float3 worldRefl;
		};

		void vert (inout appdata_full v, out Input o)
		 {
          UNITY_INITIALIZE_OUTPUT(Input,o);
          o.uv_MainTex = v.texcoord.xy;
		  o.posX = v.vertex.z;
		  float3 viewDir = normalize(UnityObjectToViewPos(v.vertex));
		  float3 normal = normalize(mul(float4(v.normal,0),unity_WorldToObject).xyz);
		  o.worldRefl = reflect(-viewDir,normal);
      }

		half _Glossiness;
		half _Metallic;
		fixed4 _Color;
		float _R;

		samplerCUBE _MainCubeMap;

		// Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
		// See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
		// #pragma instancing_options assumeuniformscaling
		UNITY_INSTANCING_CBUFFER_START(Props)
			// put more per-instance properties here
		UNITY_INSTANCING_CBUFFER_END

		void surf (Input IN, inout SurfaceOutputStandard o) 
		{
			float4 c = texCUBE (_MainCubeMap, IN.worldRefl);
			float4 d = tex2D(_MainTex,IN.uv_MainTex);
			o.Albedo = c.rgb;
			//o.Emission = texCUBE (_MainCubeMap, IN.worldRefl);
			// Metallic and smoothness come from slider variables
			o.Metallic = _Metallic;
			o.Smoothness = _Glossiness;
			o.Alpha = c.a;


			float t = IN.posX - _Ratio;

			float abs_t = abs(t);

			t = t / abs_t;

			t *=  abs_t / _R;

			t = t / 2 +0.5;

			o.Albedo *= lerp(_Color,_SecondColor,t);

		}
		ENDCG
	}
	FallBack "Diffuse"
}
