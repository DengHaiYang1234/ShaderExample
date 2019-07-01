using UnityEngine;
using System.Collections;
using System.Collections.Generic;



//在unity中实现简单的程序纹理   10.3.1


//在编辑模式执行
[ExecuteInEditMode]
public class ProceduralTextureGeneration : MonoBehaviour
{
    //声明一个材质，这个材质将使用该脚本中生成的程序纹理
    public Material material = null;

    //声明程序纹理将使用的各种参数
    //使用插件SetProperty将参数显示在面板上，这使得当修改了材质属性时，可执行_UpdateMaterial函数来使用新的属性重新生成程序纹理
    #region Material properties
    [SerializeField, SetProperty("textureWidth")]
    //材质纹理宽度
    private int m_textureWidth = 512;
    public int textureWidth
    {
        get
        {
            return m_textureWidth;
        }
        set
        {
            m_textureWidth = value;
            _UpdateMaterial();
        }
    }
    //材质纹理背景颜色
    [SerializeField, SetProperty("backgroundColor")]
    private Color m_backgroundColor = Color.white;
    public Color backgroundColor
    {
        get
        {
            return m_backgroundColor;
        }
        set
        {
            m_backgroundColor = value;
            _UpdateMaterial();
        }
    }
    //材质纹理圆形颜色
    [SerializeField, SetProperty("circleColor")]
    private Color m_circleColor = Color.yellow;
    public Color circleColor
    {
        get
        {
            return m_circleColor;
        }
        set
        {
            m_circleColor = value;
            _UpdateMaterial();
        }
    }

    //材质纹理模糊因子
    [SerializeField, SetProperty("blurFactor")]
    private float m_blurFactor = 2.0f;
    public float blurFactor
    {
        get
        {
            return m_blurFactor;
        }
        set
        {
            m_blurFactor = value;
            _UpdateMaterial();
        }
    }
    #endregion

    //为了保存生成的程序纹理，声明一个Texture2D类型的纹理变量
    private Texture2D m_generatedTexture = null;


    //在start 函数中进行相应的检查，以得到需要使用该程序纹理的材质
    void Start()
    {
        //检查material是否为空
        if (material == null)
        {
            //如果为空尝试从使用该脚本所在的物体上得到相应材质
            Renderer renderer = gameObject.GetComponent<Renderer>();
            if (renderer == null)
            {
                Debug.LogWarning("Cannot find a renderer.");
                return;
            }

            material = renderer.sharedMaterial;
        }

        _UpdateMaterial();
    }

    //_UpdateMaterial函数代码
    private void _UpdateMaterial()
    {
        //确保material不会为空
        if (material != null)
        {
            // 调取_GenerateProceduralTexture函数来生成一张程序纹理给 m_generatedTexture变量
            m_generatedTexture = _GenerateProceduralTexture();
            //利用material.SetTexture函数把生成的纹理赋给材质，材质material中需要有一个名为_MainTex的纹理属性
            material.SetTexture("_MainTex", m_generatedTexture);
        }
    }

    private Color _MixColor(Color color0, Color color1, float mixFactor)
    {
        Color mixColor = Color.white;
        mixColor.r = Mathf.Lerp(color0.r, color1.r, mixFactor);
        mixColor.g = Mathf.Lerp(color0.g, color1.g, mixFactor);
        mixColor.b = Mathf.Lerp(color0.b, color1.b, mixFactor);
        mixColor.a = Mathf.Lerp(color0.a, color1.a, mixFactor);
        return mixColor;
    }


    //_GenerateProceduralTexture函数代码
    private Texture2D _GenerateProceduralTexture()
    {
        //初始化一张二维纹理，并且提前计算了一些生成纹理时需要的变量，
        Texture2D proceduralTexture = new Texture2D(textureWidth, textureWidth);

        // The interval between circles（定义圆与圆之间的间距）
        float circleInterval = textureWidth / 4.0f;

        // The radius of circles（定义圆的半径）
        float radius = textureWidth / 10.0f;

        // The blur factor（定义模糊系数）
        float edgeBlur = 1.0f / blurFactor;

        //
        for (int w = 0; w < textureWidth; w++)
        {
            for (int h = 0; h < textureWidth; h++)
            {
                // Initalize the pixel with background color（使用背景颜色进行初始化）
                Color pixel = backgroundColor;


                //使用两层嵌套的循环遍历纹理中的每个像素，并在纹理上依次绘制9个圆形
                // Draw nine circles one by one（依次画九个圆）
                for (int i = 0; i < 3; i++)
                {
                    for (int j = 0; j < 3; j++)
                    {
                        // Compute the center of current circle（计算当前所绘制的圆的圆心位置）
                        Vector2 circleCenter = new Vector2(circleInterval * (i + 1), circleInterval * (j + 1));

                        // Compute the distance between the pixel and the center（计算当前像素与圆心的距离）
                        float dist = Vector2.Distance(new Vector2(w, h), circleCenter) - radius;

                        // Blur the edge of the circle（模糊圆的边界）
                        Color color = _MixColor(circleColor, new Color(pixel.r, pixel.g, pixel.b, 0.0f), Mathf.SmoothStep(0f, 1.0f, dist * edgeBlur));

                        // Mix the current color with the previous color（与之前的到的颜色进行混合）
                        pixel = _MixColor(pixel, color, color.a);
                    }
                }

                proceduralTexture.SetPixel(w, h, pixel);
            }
        }

        //调用Texture2D.Apply函数来强制把像素值写入纹理中，
        proceduralTexture.Apply();
        //返回该程序纹理
        return proceduralTexture;
    }
}
