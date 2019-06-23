using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SplashObjectBaseGUI : MonoBehaviour
{
    SplashObjectBase _SplashObject;

    public CVSlider _FadeSlider;



    // Start is called before the first frame update
    void Initialize(SplashObjectBase splashObj)
    {
        _SplashObject = splashObj;

        _FadeSlider.Init(_SplashObject._FadeCV);

        // Create GUI for each of the splash object CV controllers
        for (int i = 0; i < _SplashObject.CVControllers.Length; i++)
        {
          //  _ControllerGUI = SRResources.Panel_CV_Controllers.Instantiate(_CVControllerParent).GetComponent<CVControllerGUI>();
          //  _ControllerGUI.Initialize(_SplashObject.CVControllers[i]);
        }
    }
}
