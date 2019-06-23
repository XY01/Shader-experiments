using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CVControllerRotation : CVControllerBase
{
    // Start is called before the first frame update
    protected override void SetupControlValues()
    {
        _ControlValues = new ControlValue[3];

        _ControlValues[0] = new ControlValue("x", 0, 0, 30, OSCAddress);
        _ControlValues[1] = new ControlValue("y", 0, 0, 30, OSCAddress);
        _ControlValues[2] = new ControlValue("z", 0, 0, 30, OSCAddress);
    }

    // Update is called once per frame
    protected override void UpdateControlValueEffects()
    {
        transform.Rotate(_ControlValues[0].Value, _ControlValues[1].Value, _ControlValues[2].Value);
    }
}
