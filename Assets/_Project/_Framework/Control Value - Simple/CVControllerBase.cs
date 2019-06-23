using System.Collections;
using System.Collections.Generic;
using UnityEngine;

// Controller base is a base class that is used for any controller that makes use of control vlaues
// i.e. shader controller passes flaots into a shader
// i.e. rotation conttroller updates transform rotation using control values
public class CVControllerBase : MonoBehaviour
{
    public string OSCAddress { get; private set; }
    public ControlValue[] _ControlValues;

    List<ControlValue> _CVList = new List<ControlValue>();

    public bool _SelfInit = false;
    bool _Initialized = false;
    public string _ControllerName;
    
    private void Start()
    {
        if (_SelfInit)
            Init(OSCAddress);
    }

    public void Init(string oscPrefix)
    {
        OSCAddress = oscPrefix +"/"+ _ControllerName +"/";
        OSCAddress = OSCAddress.ToLower();

        SetupControlValues();
        
        _Initialized = true;
    }

    protected virtual void SetupControlValues()
    {
        // Init all control values
        for (int i = 0; i < _ControlValues.Length; i++)
            _ControlValues[i].Init(OSCAddress);
    }

    void FixedUpdate()
    {
        if (!_Initialized)
            return;

        // Update control values
        for (int i = 0; i < _ControlValues.Length; i++)
            _ControlValues[i].UpdateValue(Time.fixedDeltaTime);

        UpdateControlValueEffects();
    }

    protected virtual void UpdateControlValueEffects()
    {

    }
}
