using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CVControllerLighting : CVControllerBase
{
    public Transform _LightingParent;

    // Start is called before the first frame update
    protected override void SetupControlValues()
    {
        _ControlValues = new ControlValue[2];

        _ControlValues[0] = new ControlValue("Y ROT", 0, 0, 360, OSCAddress);
        _ControlValues[1] = new ControlValue("X ROT", .65f, -85, 85, OSCAddress);
    }

    // Update is called once per frame
    protected override void UpdateControlValueEffects()
    {
        _LightingParent.SetLocalRotX(_ControlValues[1].Value);
        _LightingParent.SetLocalRotY(_ControlValues[0].Value);
        //_LightingParent.Rotate(_ControlValues[0].Value * Time.deltaTime, _ControlValues[1].Value * Time.deltaTime, 0);
    }
}
