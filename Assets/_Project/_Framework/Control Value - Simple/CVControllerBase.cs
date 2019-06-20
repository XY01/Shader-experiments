using System.Collections;
using System.Collections.Generic;
using UnityEngine;

// Controller base is a base class that is used for any controller that makes use of control vlaues
// i.e. shader controller passes flaots into a shader
// i.e. rotation conttroller updates transform rotation using control values
public class CVControllerBase : MonoBehaviour
{
    public string _OSCPrefix;
    public ControlValue[] _ControlValues;
    public bool _SelfInit = false;

    private void Start()
    {
        if (_SelfInit)
            Init(_OSCPrefix);
    }

    public virtual void Init(string oscPrefix)
    {
        _OSCPrefix = oscPrefix;
    }

    protected virtual void Update()
    {
        // Update control values
        for (int i = 0; i < _ControlValues.Length; i++)
            _ControlValues[i].UpdateValue();
    }
}
