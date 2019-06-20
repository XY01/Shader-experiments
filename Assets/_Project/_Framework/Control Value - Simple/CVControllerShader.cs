using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CVControllerShader : CVControllerBase
{
    public Material _Mat;

    // Start is called before the first frame update
    public override void Init(string oscPrefix)
    {
        base.Init(oscPrefix);

        // Init all control values
        for (int i = 0; i < _ControlValues.Length; i++)
        {
            _ControlValues[i].Init(_OSCPrefix + "/" + _ControlValues[i]._Name);
        }
    }

    // Update is called once per frame
    protected override void Update()
    {
        base.Update();

        for (int i = 0; i < _ControlValues.Length; i++)
            _Mat.SetFloat(_ControlValues[i]._Name, _ControlValues[i].Value);
    }
}
