using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System;

public class CreatNormalMap : MonoBehaviour 
{
	public Texture2D srcTex;

	public Texture2D normalMapTex;


	//注意：1.图片要开启读写  2.图片压缩格式为：RGBA32 或 RGB24 或 ARGB32
	void Start () 
	{
		for(int w = 1; w < srcTex.width;w++)
		{
			for(int h = 1;h < srcTex.height;h++)
			{
				//计算该像素点左右两个像素的灰度差值	
				float right_u = GetGray(w-1,h);
				//计算该像素点上下两个像素的灰度差值
				float left_u = GetGray(w+1,h);

				float u = right_u - left_u;

				float bottom_u = GetGray(w,h-1);
				float up_u = GetGray(w,h+1);

				float v = bottom_u - up_u;
				//建立横向差分向量
				Vector3 vector_u = new Vector3(1,0,u);
				//建立纵向差分向量
				Vector3 vector_v = new Vector3(0,1,v);
				//根据两个向量的叉乘得到法向量
				Vector3 normal = Vector3.Cross(vector_u,vector_v).normalized;
				//限定【0，1】
				float r = normal.x * 0.5f + 0.5f;
				float g = normal.y * 0.5f + 0.5f;
				float b = normal.z * 0.5f + 0.5f;
				//若采用默认Legacy Shaders/Bumped Diffuse。那么使用该方法,参考UnityCG.cginc对应的UnpackNormal方法
				normalMapTex.SetPixel(w,h,new Color(0,g,0,r));
				//其他的使用
				//normalMapTex.SetPixel(w,h,new Color(r,g,b))；
			}
		}
		normalMapTex.Apply();
	}

	float GetGray(int w,int h)
	{
		return srcTex.GetPixel(w,h).r * 0.3f + srcTex.GetPixel(w,h).g * 0.59f + srcTex.GetPixel(w,h).b * 0.11f;
	}
	

	void Update () 
	{
		
	}
}
