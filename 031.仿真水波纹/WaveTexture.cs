using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System.Threading;

public class WaveTexture : MonoBehaviour
{
    
    public int width;
    public int heigth;
    public int r = 20;
    public float decay = 0.05f;

    private float[,] waveA;
    private float[,] waveB;

    private Texture2D tex_uv;

    private bool isRun = true;

    private int sleepTime = 0;

    private Color[] colorBuffer;
    

	// Use this for initialization
	void Start ()
	{
	    width = 128;
	    heigth = 128;
        waveA = new float[width, heigth];
	    waveB = new float[width, heigth];
	    colorBuffer = new Color[width*heigth];

        tex_uv = new Texture2D(width, heigth);
	    GetComponent<Renderer>().material.SetTexture("_WaveTex", tex_uv);
        //PutDrop(64,64);

        //开启多线程处理 优化内存  
	    Thread th = new Thread(new ThreadStart(ComputeUV));
	    th.Start();

	}

    void InitValue()
    {
        waveA[width/2, heigth/2] = 1;
        waveA[width / 2 - 1, heigth / 2 + 1] = 1;
        waveA[width / 2, heigth / 2 + 1] = 1;
        waveA[width / 2 - 1, heigth / 2 + 1] = 1;
        waveA[width / 2 - 1, heigth / 2] = 1;
        waveA[width / 2 + 1, heigth / 2] = 1;
        waveA[width / 2 + 1, heigth / 2 - 1] = 1;
        waveA[width / 2, heigth / 2 - 1] = 1;
        waveA[width / 2 + 1, heigth / 2 - 1] = 1;
    }

    void PutDrop(int x,int y)
    {
        //int r = 20;
        float dist;

        for (int i = -r; i <= r; i++)
        {
            for (int j = -r; j <= r; j++)
            {
                if (((x + 1 >= 0) && (x + i < width - 1)) && (y + j >= 0) && (y + j < heigth - 1))
                {
                    dist = Mathf.Sqrt(i*i + j*j);
                    if (dist < r)
                    {
                        waveA[x + i, y + j] = Mathf.Cos(dist*Mathf.PI/r);
                    }
                }
            }
        }
    }
	
	// Update is called once per frame
	void Update ()
	{
	    sleepTime = (int)(Time.deltaTime*1000);
	    tex_uv.SetPixels(colorBuffer);
	    tex_uv.Apply();

        if (Input.GetMouseButton(0))
	    {
	        RaycastHit hit;
	        Ray ray = Camera.main.ScreenPointToRay(Input.mousePosition);
	        if (Physics.Raycast(ray, out hit))
	        {
	            Vector3 pos = hit.point;
	            pos = transform.worldToLocalMatrix.MultiplyPoint(pos);

	            int w = (int)((pos.x + 0.5)*width);
                int h = (int)((pos.y + 0.5) * heigth);

	            Debug.LogError(w + "            " + h    );
	            PutDrop(w, h);

	        }
	    }


	    //ComputeUV();
	}


    private void ComputeUV()
    {

        while (isRun)
        {
            for (int i = 1; i < width - 1; i++)
            {
                for (int j = 1; j < heigth - 1; j++)
                {
                    waveB[i, j] = (
                        //左
                        waveA[i + 1, j] +
                        //右
                        waveA[i - 1, j] +
                        //下
                        waveA[i, j - 1] +
                        //上
                        waveA[i, j + 1] +
                        //左下
                        waveA[i - 1, j - 1] +
                        //右下
                        waveA[i + 1, j - 1] +
                        //左上
                        waveA[i - 1, j + 1] +
                        //右上
                        waveA[i + 1, j + 1]
                        )/4 - waveB[i, j];


                    float value = waveB[i, j];

                    if (value > 1)
                        waveB[i, j] = 1;

                    if (value < -1)
                        waveB[i, j] = -1;

                    float offest_u = (waveB[i - 1, j] - waveB[i + 1, j])/2;
                    float offest_v = (waveB[i, j - 1] - waveB[i, j + 1])/2;
                    float r = offest_u/2f + 0.5f;
                    float g = offest_v/2f + 0.5f;

                    //tex_uv.SetPixel(i, j, new Color(r, g, 0));

                    colorBuffer[i + width*j] = new Color(r, g, 0);

                    waveB[i, j] -= waveB[i, j]* decay;
                }
            }

            //tex_uv.Apply();
            var temp = waveA;
            waveA = waveB;
            waveB = temp;

            Thread.Sleep(sleepTime);
        }
    }


    private void OnDestroy()
    {
        isRun = false;
    }
}
