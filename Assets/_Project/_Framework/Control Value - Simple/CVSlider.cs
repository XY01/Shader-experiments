using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

/// <summary>
/// Sets the normalized values of the control value
/// </summary>
public class CVSlider : UnityEngine.UI.Slider
{
    public ControlValue _CV;

    public void Init(ControlValue cv)
    {
        _CV = cv;
        this.onValueChanged.AddListener((float f) => _CV._NormalizedValue = f);
        SetValue(_CV._NormalizedValue, false);
    }

    void Update()
    {
        // Sets the value without sending an event in case value is changedd externally
        SetValue(_CV._NormalizedValue, false);
    }

    public void SetValue(float val, bool sendEvent)
    {
        Set(val, sendEvent);
    }
}
