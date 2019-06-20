using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CVControllerRotation : CVControllerBase
{
    // Start is called before the first frame update
    public override void Init(string oscprefix)
    {
        _ControlValues = new ControlValue[3];

        _ControlValues[0] = new ControlValue("x", 0, 0, 30, oscprefix);

        // Init all control values
        for (int i = 0; i < _ControlValues.Length; i++)
        {
            _ControlValues[i].Init(_OSCPrefix + "/" + _ControlValues[i]._Name);
        }
    }

    // Update is called once per frame
    protected override void Update()
    {
        for (int i = 0; i < _ControlValues.Length; i++)
            _ControlValues[i].UpdateValue();          

        transform.Rotate(_ControlValues[0].Value, _ControlValues[1].Value, _ControlValues[2].Value);
    }
}
