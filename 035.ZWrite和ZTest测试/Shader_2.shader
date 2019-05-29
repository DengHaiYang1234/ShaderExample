Shader "Hidden/Shader_2"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_MainColor("Color",Color) = (1,1,1,1)
	}
	//白色方块  在后面
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
		// //ZWrite默认为On ZTest默认为LEqual。根据距离相机的深度值来决定是否写入深度缓存，所以在前面的物体会先写入，导致遮挡后面的物体
		// //结果：蓝色遮挡白色
		// Tags {"Queue" = "Transparent"}

		//////////////////////////// 测试2

		// //渲染队列+300.较蓝色物体靠后渲染，但是ZWrite：On，ZTest：LEqual。所以为输出颜色，并且会根据深度值的比较，会将像素写入深度缓存中，ZTest通过，颜色的缓存修改为白色
		// //所以，由于该物体后渲染，并且会写入深度缓存，那么必定该物体某些部位会遮挡前面的物体
		// //结果：白色遮挡蓝色
		// Tags {"Queue" = "Transparent+300"}

		//////////////////////////// 测试3

		// //该像素的深度值是要小于蓝色像素的深度值，ZTest不通过，所以在深度缓存中，已经存在蓝色，输出为蓝色。结果为蓝色遮挡白色
		// //结果：蓝色遮挡白色
		// Tags {"Queue" = "Transparent+300"}	

		//////////////////////////// 测试4
		// //ZWrite和ZTest默认开启，由于之前的深度缓存没有被写入，那么该像素ZTest通过，深度缓存中的颜色值会修改为白色
		// //结果：白色遮挡蓝色
		// Tags {"Queue" = "Transparent+300"}

		//////////////////////////// 测试5
		// //ZWrite默认为On，ZTest：Off，关闭深度测试，等价于Always，指的是直接将当前像素颜色（不是深度）写入颜色缓冲区，而Never指的是不要将当前像素颜色写进颜色缓冲区中，相当于消失。
		// //所以会将颜色缓冲区的部分蓝色修改为白色
		// //结果：白色遮挡蓝色
		// Tags {"Queue" = "Transparent+300"}
		// ZTest Off

		//////////////////////////// 测试6
		// //白色不会将像素写进深度缓冲中，但是会直接将当前像素颜色写入颜色缓冲中，所以部分蓝色会直接修改为白色
		// //结果：白色遮挡蓝色
		// Tags {"Queue" = "Transparent+300"}
		// ZWrite Off
		// ZTest Off

		//////////////////////////// 测试7

		// //ZTest不通过，不会写入深度缓冲，但会像素颜色（白）写入颜色缓存，导致前面的某些蓝色部分被修改
		// //结果：白色遮挡蓝色
		// Tags {"Queue" = "Transparent+300"}
		// ZTest off

		//////////////////////////// 测试8

		// //关闭深度写入，但会把颜色写入颜色缓存，修改颜色缓存中的值
		// //结果：白色遮挡蓝色
		// Tags {"Queue" = "Transparent+300"}
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
