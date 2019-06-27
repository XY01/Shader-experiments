using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using EXPToolkit;

public class DataRacketIn : MonoBehaviour
{
    OSCListener _LoudnessOSC;
    OSCListener _PanningOSC;
    OSCListener _CentroidOSC;
    OSCListener _SpreadOSC;
    OSCListener _NoisinessOSC;
    OSCListener _FFTOSC;
    OSCListener _AttackAOSC;
    OSCListener _AttackBOSC;
    OSCListener _AttackCOSC;

    public static DataRacketIn Instance { get { return m_Instance; } }
    public static DataRacketIn m_Instance;

    float _Loudness;
    float _LoudnessSmooth;

    float _Panning;
    float _PanningSmooth;

    float _Centroid;
    float _CentroidSmooth;

    float _Spread;
    float _SpreadSmooth;

    float _Noisiness;
    float _NoisinessSmooth;

    float[] _FFTArray;
    float[] _FFTArraySmooth;

    float _AttackA;
    float _AttackASmooth;

    float _AttackB;
    float _AttackBSmooth;

    float _AttackC;
    float _AttackCSmooth;


    public Color _FFTHighCol = Color.white;
    public Color _FFTLowCol = Color.black;
    public Texture2D _FFTTexV;
    public Texture2D _FFTTexH;

    //public Renderer _RendererH;
    //public Renderer _RendererV;

    int _FFTBins = 32;
    float _Smoothing = 4;


    private void Awake()
    {
        m_Instance = this;
    }

    // Use this for initialization
    void Start ()
    {
        _FFTArray = new float[32];
        _FFTArraySmooth = new float[32];

        _LoudnessOSC = new OSCListener("/loudness");
        _PanningOSC = new OSCListener("/panning");
        _CentroidOSC = new OSCListener("/centroid/freq");
        _SpreadOSC = new OSCListener("/centroid/spread");
        _NoisinessOSC = new OSCListener("/noisiness");
        _FFTOSC = new OSCListener("/fft");
        _AttackAOSC = new OSCListener("/attacka");
        _AttackBOSC = new OSCListener("/attackb");
        _AttackCOSC = new OSCListener("/attackc");

        _FFTTexV = new Texture2D(_FFTBins, 1);
        _FFTTexV.filterMode = FilterMode.Point;
        _FFTTexH = new Texture2D(1, _FFTBins);
        _FFTTexH.filterMode = FilterMode.Point;
        

        //_RendererH.material.mainTexture = _FFTTexH;
        //_RendererV.material.mainTexture = _FFTTexV;
    }
	
	// Update is called once per frame
	void Update ()
    {
        if (_LoudnessOSC.Updated && _LoudnessOSC.DataAvailable)
            _Loudness = _LoudnessOSC.GetDataAsFloat();

        if (_PanningOSC.Updated && _PanningOSC.DataAvailable)
            _Panning = _PanningOSC.GetDataAsFloat();

        if (_CentroidOSC.Updated && _CentroidOSC.DataAvailable)
            _Centroid = _CentroidOSC.GetDataAsFloat();

        if (_SpreadOSC.Updated && _SpreadOSC.DataAvailable)
            _Spread = _SpreadOSC.GetDataAsFloat();

        if (_NoisinessOSC.Updated && _NoisinessOSC.DataAvailable)
            _Noisiness = _NoisinessOSC.GetDataAsFloat();

        if (_AttackAOSC.Updated && _AttackAOSC.DataAvailable)
            _AttackA = _AttackAOSC.GetDataAsFloat();

        if (_AttackBOSC.Updated && _AttackBOSC.DataAvailable)
            _AttackB = _AttackBOSC.GetDataAsFloat();

        if (_AttackCOSC.Updated && _AttackCOSC.DataAvailable)
            _AttackC = _AttackCOSC.GetDataAsFloat();

        print(_Loudness);

        // FFT
        if (_FFTOSC.Updated && _FFTOSC.DataAvailable)
        {
           List<object> fftObjs = _FFTOSC.GetAllData();

            for (int i = 0; i < fftObjs.Count; i++)
            {
                _FFTArray[i] = (float)fftObjs[i];

                if (_FFTArray[i] > _FFTArraySmooth[i]) _FFTArraySmooth[i] = _FFTArray[i];
                else _FFTArraySmooth[i] = Mathf.Lerp(_FFTArraySmooth[i], _FFTArray[i], Time.deltaTime * _Smoothing);
            }
        }
    }

    private void FixedUpdate()
    {
        for (int x = 0; x < _FFTBins; x++)
        {
            Color color = Color.Lerp(_FFTLowCol, _FFTHighCol, _FFTArray[x]);
            _FFTTexH.SetPixel(0, x, color);            
        }
        _FFTTexH.Apply();

        for (int x = 0; x < _FFTBins; x++)
        {
            Color color = Color.Lerp(_FFTLowCol, _FFTHighCol, _FFTArray[x]);
            _FFTTexV.SetPixel(x, 0, color);
        }
        _FFTTexV.Apply();

       // _RendererH.material.mainTexture = _FFTTexH;
       // _RendererV.material.mainTexture = _FFTTexV;
    }

    public float GetData(DataInType data)
    {
        switch (data)
        {
            case DataInType.DR_Loudness:                
                    return _Loudness;
            case DataInType.DR_Panning:
                return _Panning;
            case DataInType.DR_Centroid:
                return _Centroid;
            case DataInType.DR_Spread:
                return _Spread;
            case DataInType.DR_Noisiness:
                return _Noisiness;
            case DataInType.DR_AttackA:
                return _AttackA;
            case DataInType.DR_AttackB:
                return _AttackB;
            case DataInType.DR_AttackC:
                return _AttackC;    
        }

        return 0;
    }
}

public enum DataInType
{
    None,
    DR_Loudness,
    DR_Panning,
    DR_Centroid,
    DR_Spread,
    DR_Noisiness,
    DR_FFT,
    DR_AttackA,
    DR_AttackB,
    DR_AttackC,
}