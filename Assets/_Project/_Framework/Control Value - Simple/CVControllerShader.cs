using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CVControllerShader : CVControllerBase
{
    public Material _Mat;

    protected override void SetupControlValues()
    {
        base.SetupControlValues();

        for (int i = 0; i < _ControlValues.Length; i++)
        {
            if (!_Mat.HasProperty(_ControlValues[i]._Name))
                Debug.LogError(name + " doesnt contain property " + _ControlValues[i]._Name);
        }
    }

    // Update is called once per frame
    protected override void UpdateControlValueEffects()
    {       
        for (int i = 0; i < _ControlValues.Length; i++)
        {
            if(_ControlValues[i]._Culumlative)
                _Mat.SetFloat(_ControlValues[i]._Name, _ControlValues[i].CumulativeValue);
            else
                _Mat.SetFloat(_ControlValues[i]._Name, _ControlValues[i].Value);
        }

        for (int i = 0; i < _ControlColours.Length; i++)
        {
            _Mat.SetColor(_ControlColours[i]._Name, _ControlColours[i]._Col);
        }

        // Set manual time in the shader
        _Mat.SetFloat("_ManualTime", Time.time);
    }
}
