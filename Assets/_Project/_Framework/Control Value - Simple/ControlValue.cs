using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[System.Serializable]
public class ControlValue
{
    public string _Name = "/Test/Value";
    [Range(0,1)] public float _NormalizedValue = 0;
    public Vector2 _Range = new Vector2(0, 1);
    public float Value { get; private set; }

    [Header("Optional")]
    // Used to maintain a value that accumulates by the output value each frame
    // Used for things like timers in shaders
    public bool _Culumlative = false;
    public float CumulativeValue { private set; get; }
    public float _SmoothingSpeed = 0;
    public bool _Master = false;
    public ControlValue _LinkedControlValue;

    OSCListener _OSCListener;

    // Hax
    public DataInType _DataRacketType = DataInType.None;

    public ControlValue(string name, float normVal, float minRange, float maxRange, string oscAddressPrefix)
    {
        _Name = name;
        _NormalizedValue = normVal;
        _Range.x = minRange;
        _Range.y = maxRange;
        Init(oscAddressPrefix);
    }

    public void Init(string oscAddress)
    {
        // Init osc listener
        _OSCListener = new OSCListener(oscAddress+_Name);
    }

    public void UpdateValue(float delta)
    {
        // CUMULATIVE VALUES - Accumulate value over time for things like offsets in shaders
        if (_Culumlative)
            CumulativeValue += delta * Value;

        if (_DataRacketType != DataInType.None)
        {
            if (_DataRacketType == DataInType.Beat)
                _NormalizedValue = EXPToolkit.BPMCounter.Instance._CurvedBeatNorm;
            else
                _NormalizedValue = DataRacketIn.Instance.GetData(_DataRacketType);

            //Debug.Log("Here   " + _NormalizedValue);
        }
        
        
        // SMOOTHING - Add smoothign if smoothing speed set higher than 0
        if (_SmoothingSpeed == 0)
            Value = _NormalizedValue.ScaleFrom01(_Range.x, _Range.y);
        else
            Value = Mathf.Lerp(Value, _NormalizedValue.ScaleFrom01(_Range.x, _Range.y), _SmoothingSpeed * delta);
        

        if (_OSCListener.Updated)
        {
            
        }

        if (_OSCListener.DataAvailable)
        {
            _NormalizedValue = _OSCListener.GetDataAsFloat();
        }

        if (_LinkedControlValue != null)
        {
            _LinkedControlValue._NormalizedValue = _NormalizedValue;
        }
    }
}
