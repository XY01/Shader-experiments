using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[System.Serializable]
public class ControlColour
{
    public string _Name = "/Test/Value";
    public Color _Col;
    HSBColor _HSBCol;
    HSBColor _TargetHSBCol;
    public float _SmoothingSpeed = 0;
    OSCListener _OSCListener;

    public ControlColour(string name, Color col, string oscAddressPrefix)
    {
        _Name = name;       
        _TargetHSBCol = _HSBCol;
        Init(oscAddressPrefix);
    }

    public void Init(string oscAddress)
    {
        // Init osc listener
        _OSCListener = new OSCListener(oscAddress + _Name);
        _HSBCol = HSBColor.FromColor(_Col);
        _TargetHSBCol = _HSBCol;

    }

    public void UpdateValue(float delta)
    {
        if (_OSCListener.Updated)
        {

        }

        if (_OSCListener.DataAvailable)
        {
            //_NormalizedValue = _OSCListener.GetDataAsFloat();
        }

        if (_SmoothingSpeed > 0)
            _Col = HSBColor.Lerp(_HSBCol, _TargetHSBCol, delta * _SmoothingSpeed).ToColor();
        else
        {
            _HSBCol = _TargetHSBCol;
            _Col = _HSBCol.ToColor();
        }

        //Debug.Log(_Name + " col " + _Col.ToString() + "  " + _HSBCol.ToColor().ToString());
    }

    public void SetColour(HSBColor col)
    {
        _TargetHSBCol = col;

        if (_SmoothingSpeed == 0)
        {
            _TargetHSBCol = col;
            _HSBCol = col;
            _Col = _HSBCol.ToColor();
        }          
    }
}
