Shader "Hidden/Shader_1"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_MainColor("Color",Color) = (1,1,1,1)
	}
	//蓝色方块   在前方
	SubShader
	{

		// -------------------------******注意：******----------------

		//ZWrite可以取的值为：On/Off，默认值为On，代表是否要将像素的深度写入深度缓存中(同时还要看ZTest是否通过)。

		//ZTest可以取的值为：Greater/GEqual/Less/LEqual/Equal/NotEqual/Always/Never/Off，默认值为LEqual，代表通过比较深度来更改颜色缓存的值。
		//例如当取默认值的情况下，如果将要绘制的新像素的z值小于等于深度缓存中的值，则将用新像素的颜色值更新深度缓存中对应像素的颜色值。
		//需要注意的是，当ZTest取值为Off时，表示的是关闭深度测试，等价于取值为Always，而不是Never！Always指的是直接将当前像素颜色(不是深度)写进颜色缓冲区中；
		//而Never指的是不要将当前像素颜色写进颜色缓冲区中，相当于消失。


		//1.当ZWrite为On时，ZTest通过时，该像素的深度才能成功写入深度缓存，同时因为ZTest通过了，该像素的颜色值也会写入颜色缓存。

		//2.当ZWrite为On时，ZTest不通过时，该像素的深度不能成功写入深度缓存，同时因为ZTest不通过，该像素的颜色值不会写入颜色缓存。

		//3.当ZWrite为Off时，ZTest通过时，该像素的深度不能成功写入深度缓存，同时因为ZTest通过了，该像素的颜色值会写入颜色缓存。

		//4.当ZWrite为Off时，ZTest不通过时，该像素的深度不能成功写入深度缓存，同时因为ZTest不通过，该像素的颜色值不会写入颜色缓存。

		// -------------------------******注意：******----------------

		

		//////////////////////////// 测试1

		// //===============================Unity默认情况
		// //ZWrite默认为On ZTest默认为LEqual。根据距离相机的深度值来决定是否写入深度缓存，所以在前面的物体会先写入（颜色也会先输出），导致遮挡后面的物体
		// //结果：蓝色遮挡白色
		// Tags {"Queue" = "Transparent"}

		//////////////////////////// 测试2

		// //渲染队列+200.但是关闭了深度写入，ZTest还是默认为LEqual，所以根据深度还是进行颜色输出，但是不会将像素深度写入深度缓存中，ZTest通过了，颜色缓存中存放了蓝色的颜色值
		// //结果：白色遮挡白色
		// Tags {"Queue" = "Transparent+200"}
		// ZWrite Off

		//////////////////////////// 测试3

		// //根据当前像素的深度值与ZTest的结果写入深度缓存，那么颜色缓存中存放了蓝色颜色值
		// //结果：蓝色遮挡白色
		// Tags {"Queue" = "Transparent+200"}

		//////////////////////////// 测试4

		// //关闭ZWrite和ZTest。导致像素不会写入深度缓存，ZTest为Off，会将蓝色直接写入颜色缓冲中
		// //结果：白色遮挡白色
		// Tags {"Queue" = "Transparent+200"}
		// ZWrite Off
		// ZTest Off

		//////////////////////////// 测试5
		// //结果：白色遮挡蓝色
		// Tags {"Queue" = "Transparent+200"}

		//////////////////////////// 测试6

		// //像素根据深度值，会将像素深度值写入深度缓冲，通过深度缓冲来使用对应颜色缓冲的值
		// //结果：白色遮挡蓝色
		// Tags {"Queue" = "Transparent+200"}

		//////////////////////////// 测试7

		// //ZTest不通过，不会写入深度缓冲，但会像素颜色（蓝）写入颜色缓存
		// //结果：白色遮挡蓝色
		// Tags {"Queue" = "Transparent+200"}
		// ZTest off

		//////////////////////////// 测试8

		// //关闭深度写入，但会把颜色写入颜色缓存，修改颜色缓存中的值
		// //结果：白色遮挡蓝色
		// Tags {"Queue" = "Transparent+200"}
		// ZWrite Off
		// ZTest Off


		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
			};

			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv;
				return o;
			}
			fixed4 _MainColor;
			
			sampler2D _MainTex;

			fixed4 frag (v2f i) : SV_Target
			{
				fixed4 col = _MainColor;
				return col;
			}
			ENDCG
		}
	}
}
