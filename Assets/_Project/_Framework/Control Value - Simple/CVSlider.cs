using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class CVSlider : UnityEngine.UI.Slider
{
    public void SetValue(float val, bool sendEvent)
    {
        Set(val, sendEvent);
    }
}
