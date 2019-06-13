﻿using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
[RequireComponent(typeof(Camera))]
public class PostEffectsBase : MonoBehaviour
{

    protected void CheckResource()
    {
        bool isSupported = CheckSupport();

        if (!isSupported)
        {
            NotSupport();
        }
    }

    protected bool CheckSupport()
    {
        if (!SystemInfo.supportsImageEffects || !SystemInfo.supportsRenderTextures)
        {
            Debug.LogError("This platform dos not support image effects or render textures.");
            return false;
        }
            
        return true;
    }

    protected void NotSupport()
    {
        enabled = false;
    }

    // Use this for initialization
    protected void Start ()
    {
        CheckResource();
    }

    protected Material CheckShaderAndCreateMaterial(Shader shader,Material material)
    {
        if (shader == null)
            return null;

        if (shader.isSupported && material && material.shader == shader)
            return material;

        if (!shader.isSupported)
            return null;
        else
        {
            material = new Material(shader);
            material.hideFlags = HideFlags.DontSave;
            if (material)
                return material;
            else
                return null;
        }
    }
}
