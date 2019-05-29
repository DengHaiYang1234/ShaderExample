Shader "Hidden/Shader"
{
	SubShader
	{
		Tags {"Queue" = "Transparent"}
		Pass
		{
			// //情况1:Pass1开启深度写入并ZTest使用Greater，那么就会将大于深度缓存的值写入深度缓存中，并取得该深度缓存对应的颜色缓存中的颜色值

			// //深度写入开启  取决于物体与相机的深度值  来写入深度缓存
			// ZWrite On
			// //深度缓存的深度值若比像素的深度值大，那么就取得该深度在颜色缓存中的颜色值
			// ZTest Greater

			// //情况2:关闭写入，开启ZTest Greater，当深度值通过ZTest时，会直接修改颜色缓存的值
			// ZWrite Off
			// ZTest Greater

			//情况3: 开始写入和ZTest，但是只写入像素深度值大于深度缓存值的部分
			ZWrite On
			ZTest Greater

			//Blend SrcAlpha OneMinusSrcAlpha

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
			};

			struct v2f
			{
				float4 vertex : SV_POSITION;
			};

			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				return o;
			}
			

			fixed4 frag (v2f i) : SV_Target
			{
				fixed4 col = fixed4(1,0,0,0.5);
				return col;
			}
			ENDCG
		}

		Pass
		{
			// //情况1:Pass2开启深度写入并ZTest使用LEqual，由于在Pass1深度缓存中已经存了部分值（大于深度的值），而该Pass是取小于等于当前深度的值，并修改深度缓存中的值，
			// //但是该情况存在一个错误，就是使用小于等于时，等于的那个部分就会修改已经在Pass1中写入的深度缓存值。
			// ZWrite On
			// ZTest LEqual


		
			// //情况2:开启ZWrite和ZTest，使得像素的深度值小于等于深度缓存中的值时，写入该深度值并使用对应的颜色值
			// ZWrite On
			// ZTest LEqual

			//情况3: 开始写入和ZTest，但是只写入像素深度值小于深度缓存值的部分
			ZWrite On
			ZTest Less

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
			};

			struct v2f
			{
				float4 vertex : SV_POSITION;
			};

			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				return o;
			}
			

			fixed4 frag (v2f i) : SV_Target
			{
				fixed4 col = fixed4(0,0,1,1);
				return col;
			}
			ENDCG
		}
	}
}
