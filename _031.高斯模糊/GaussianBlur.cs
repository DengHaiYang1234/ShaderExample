using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GaussianBlur : PostEffectsBase
{
    public Shader gaussianBlurShader;
    private Material gaussianBlurMaterial = null;

    public Material material
    {
        get { gaussianBlurMaterial = CheckShaderAndCreateMaterial(gaussianBlurShader, gaussianBlurMaterial);
            return gaussianBlurMaterial;
        }
    }

    [Range(0, 4)] public int iterations = 3;

    [Range(0.2f, 3.0f)] public float blurSpread = 0.6f;

    [Range(1, 8)] public int downSample = 2;


    //private void OnRenderImage(RenderTexture src, RenderTexture dest)
    //{
    //    if (material != null)
    //    {
    //        int rtW = src.width;
    //        int rtH = src.height;

    //        //分配一块与屏幕大小相等的缓冲区
    //        RenderTexture buffer = RenderTexture.GetTemporary(rtW, rtH, 0);
    //        //第一次Pass处理完毕后的结果存储在buffer中
    //        Graphics.Blit(src, buffer, material, 0);
    //        //第二次Pass处理完毕后的结果存储在dest中
    //        Graphics.Blit(buffer, dest, material, 1);
    //        //释放缓冲区
    //        RenderTexture.ReleaseTemporary(buffer);
    //    }
    //    else
    //        Graphics.Blit(src,dest);
    //}


    //提高性能。尺寸小于原有屏幕尺寸，渲染纹理的滤波模式设置为双线性。那么需要处理的像素个数就是原来的几分之一，并且可以减少采样
    //void OnRenderImage(RenderTexture src, RenderTexture dest)
    //{
    //    if (material != null)
    //    {


    //        int rtW = src.width/downSample;
    //        int rtH = src.height/downSample;

    //        RenderTexture buffer = RenderTexture.GetTemporary(rtW, rtH, 0);
    //        buffer.filterMode = FilterMode.Bilinear;

    //        Graphics.Blit(src, buffer, material, 0);
    //        Graphics.Blit(buffer, dest, material, 0);

    //        RenderTexture.ReleaseTemporary(buffer);
    //    }
    //    else
    //        Graphics.Blit(src,dest);
    //}


    //两个缓冲区迭代运行
    private void OnRenderImage(RenderTexture src, RenderTexture dest)
    {
        if (material != null)
        {


            int rtW = src.width/downSample;
            int rtH = src.height/downSample;

            RenderTexture buffer0 = RenderTexture.GetTemporary(rtW, rtH, 0);
            buffer0.filterMode = FilterMode.Bilinear;

            Graphics.Blit(src, buffer0);

            for (int i = 0; i < iterations; i++)
            {
                material.SetFloat("_BlurSize", 1.0f + i*blurSpread);

                RenderTexture buffer1 = RenderTexture.GetTemporary(rtW, rtH, 0);

                Graphics.Blit(buffer0, buffer1, material, 0);

                RenderTexture.ReleaseTemporary(buffer0);
                buffer0 = buffer1;
                buffer1 = RenderTexture.GetTemporary(rtW, rtH, 0);

                Graphics.Blit(buffer0, buffer1, material, 1);

                RenderTexture.ReleaseTemporary(buffer0);
                buffer0 = buffer1;
            }

            Graphics.Blit(buffer0, dest);
            RenderTexture.ReleaseTemporary(buffer0);
        }
        else
            Graphics.Blit(src, dest);
    }




}
