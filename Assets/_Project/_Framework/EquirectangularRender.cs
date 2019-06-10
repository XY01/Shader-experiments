using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Rendering;
using Klak.Ndi;

[RequireComponent(typeof(Camera))]
public class EquirectangularRender : MonoBehaviour
{
    public int _CubemapRes = 1024;
    public int _EquiRectRest = 1024;

    public RenderTexture _CubemapRT;
    public RenderTexture _EquiRectRT;
    Camera _Cam;

    //Hax
    public Klak.Ndi.NdiSender _NDISender;
    public float _Test;

    void Start()
    {
        _CubemapRT = new RenderTexture(_CubemapRes, _CubemapRes, 24, RenderTextureFormat.ARGB32);
        _CubemapRT.dimension = TextureDimension.Cube;
        //equirect height should be twice the height of cubemap
        _EquiRectRT = new RenderTexture(_EquiRectRest, _EquiRectRest, 24, RenderTextureFormat.ARGB32);

        _Cam = GetComponent<Camera>();

        if(_NDISender != null)
            _NDISender.sourceTexture = _EquiRectRT;
    }

    void LateUpdate()
    {
        _Cam.RenderToCubemap(_CubemapRT, 63, Camera.MonoOrStereoscopicEye.Mono);
        _CubemapRT.ConvertToEquirect(_EquiRectRT, Camera.MonoOrStereoscopicEye.Mono);

        if (_NDISender != null)
            _NDISender.sourceTexture = _EquiRectRT;
    }
}

