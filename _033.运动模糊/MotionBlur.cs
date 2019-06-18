using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MotionBlur : PostEffectsBase
{
    public Shader motionBlurShader;
    private Material motionBlurMaterial = null;

    public Material material
    {
        get
        {
            motionBlurMaterial = CheckShaderAndCreateMaterial(motionBlurShader,motionBlurMaterial);
            return motionBlurMaterial;
        }
    }

    [Range(0.0f, 0.9f)] public float blurAmount = 0.5f;

    private RenderTexture accumulationTexture;

    private void OnDisable()
    {
        DestroyImmediate(accumulationTexture);
    }


    private void OnRenderImage(RenderTexture src, RenderTexture dest)
    {
        if (material != null)
        {
            //若不满足当前分辨率，还需要重新创建一个跟当前分辨率相同的texture
            if (accumulationTexture == null || accumulationTexture.width != src.width ||
                accumulationTexture.height != src.height)
            {
                DestroyImmediate(accumulationTexture);
                accumulationTexture = new RenderTexture(src.width, src.height, 0);
                //该texture不会显示在Hierarchy中
                accumulationTexture.hideFlags = HideFlags.HideAndDontSave;
                //使用当前的图像来初始化accumulationTexture
                Graphics.Blit(src, accumulationTexture);
            }

            //对纹理进行恢复操作（发生在渲染到纹理而该纹理又没有被提前清空或销毁的情况）
            accumulationTexture.MarkRestoreExpected();
            material.SetFloat("_BlurAmount", 1.0f - blurAmount);
            //将当前的帧图像叠加到accumulationTexture
            Graphics.Blit(src, accumulationTexture, material);
            //最后将图像显示在屏幕上
            Graphics.Blit(accumulationTexture, dest);
        }
        else
            Graphics.Blit(src,dest);
    }

}
