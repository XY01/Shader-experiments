using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CVControllerShader : CVControllerBase
{
    public Material _Mat;
    
    // Update is called once per frame
    protected override void UpdateControlValueEffects()
    {
        for (int i = 0; i < _ControlValues.Length; i++)
            _Mat.SetFloat(_ControlValues[i]._Name, _ControlValues[i].Value);
    }
}
