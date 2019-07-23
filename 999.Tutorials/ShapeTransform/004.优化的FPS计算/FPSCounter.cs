using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class FPSCounter : MonoBehaviour 
{

	public int FPS{get;private set;}
	public int frameRange = 60;
	public int AveragePFS{get;private set;}

	public int HighestFPS{get;private set;}
	public int LowestFPS{get;private set;}
	int[] fpsBuffer;

	int fpsBufferIndex;


	void InitializeBuffer()
	{
		if(frameRange <= 0)
		{
			frameRange = 1;
		}

		fpsBuffer = new int[frameRange];
		fpsBufferIndex = 0;
	}

	
	// Update is called once per frame
	void Update () 
	{
		if(fpsBuffer == null || fpsBuffer.Length != frameRange)
			InitializeBuffer();
		UpdateBuffer();
		CalculateFPS();
	}

	void UpdateBuffer()
	{
		fpsBuffer[fpsBufferIndex++] = (int)(1f / Time.unscaledDeltaTime);
		if(fpsBufferIndex >= frameRange)
			fpsBufferIndex = 0;
	}
	
	void CalculateFPS()
	{
		int sum = 0;
		int hightest = 0;
		int lowest = int.MaxValue;
		for(int i = 0; i < frameRange;i++)
		{
			int _fps = fpsBuffer[i];
			sum += _fps;

			if(sum > hightest)
				hightest = _fps;

			if(_fps < lowest)
				lowest = _fps;
		}
		AveragePFS = sum / frameRange;
		HighestFPS = hightest;
		LowestFPS = lowest;
	}
}
