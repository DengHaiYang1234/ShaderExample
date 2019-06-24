Shader "Hidden/FixFunctionShader"
{
	//固定功能Shader
	Properties
	{
		_Color("Main Color",color) = (1,1,1,1)
		_Ambient("Ambient",color) = (1,1,1,1)
		_Sepcular("Sepcular",color) = (1,1,1,1)
		_Shininess("Shininess",Range(0,8)) = 4
		_Emission("Emission",color) = (1,1,1,1) 
		_MainTex("MainTex",2D) = "white" {}
		_STex("Second Tex",2D) = "white" {}
		_ConstantClolr("Constant Color",Color) = (1,1,1,0.3)
	}

	SubShader
	{
		Tags {"Queue" =   "Transparent"}
		Pass
		{
			Blend SrcAlpha OneMinusSrcAlpha
			Material
			{
				//漫反射
				diffuse[_Color]
				//环境光
				ambient[_Ambient]
				//镜面高光
				specular[_Sepcular]
				//镜面高光范围
				shininess[_Shininess]
				//自发光
				emission[_Emission]
			}
			//光照开关
			lighting on 
			//镜面高光开关
			separatespecular on

			settexture[_MainTex]
			{
				//当前纹理 * 顶点光照的结果
				combine texture * primary double //primary:代表了使用材质前，顶点计算的光照和材质的颜色
			}

			settexture[_STex]
			{	
				constantColor[_ConstantClolr]
				//逗号后面的参数，只是取了Alpha通道的值。使用当前纹理的alpha通道来设置alpha的值
				combine texture * previous double , texture  * constant//previous：当前采样的纹理 * 之前所有计算采样的结果
			}

		}
	}
}
