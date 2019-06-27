using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CameraRenderTexToNDI : MonoBehaviour
{
    public RenderTexture _TempRT;

    public Klak.Ndi.NdiSender _Sender;

    public int _RenderRes = 2048;
    // Start is called before the first frame update
    void Start()
    {
        Camera _Cam = GetComponent<Camera>();
        _TempRT = new RenderTexture((int)_RenderRes, (int)_RenderRes, 0, RenderTextureFormat.ARGB32);
        _TempRT.antiAliasing = 1;
        _TempRT.filterMode = FilterMode.Bilinear;
        _TempRT.anisoLevel = 0;
        _TempRT.autoGenerateMips = false;
        _TempRT.useMipMap = false;

        _Cam.targetTexture = _TempRT;

        _Sender._Source = Klak.Ndi.NdiSender.Source.RenderTexture;
        _Sender.sourceTexture = _TempRT;
    }

    // Update is called once per frame
    void Update()
    {

    }

   
}
