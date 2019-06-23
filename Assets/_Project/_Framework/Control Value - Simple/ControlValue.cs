using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[System.Serializable]
public class ControlValue
{
    public string _Name = "/Test/Value";

    [Range(0,1)] public float _NormalizedValue = 0;
    public Vector2 _Range = new Vector2(0, 1);
    public float Value { get { return _NormalizedValue.ScaleFrom01(_Range.x, _Range.y); } }

    OSCListener _OSCListener;

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

    public void UpdateValue()
    {
        if (_OSCListener.DataAvailable)
            _NormalizedValue = _OSCListener.GetDataAsFloat();
    }
}
