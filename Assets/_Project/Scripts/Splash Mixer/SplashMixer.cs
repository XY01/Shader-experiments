using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class SplashMixer : MonoBehaviour
{
    public static SplashMixer Instance;

    SplashObjectBase _SplashObject;
    CVControllerGUI _ControllerGUI;

    public RectTransform _CVControllerParent;

    private void Awake()
    {
        Instance = this;
    }

    private void Start()
    {
        SetActiveSplashObject(FindObjectOfType<SplashObjectBase>());
    }

    void SetActiveSplashObject(SplashObjectBase splashObject)
    {
        if (_SplashObject != null)
            _SplashObject.Deactivate();

        _SplashObject = splashObject;
        _SplashObject.Activate();

        // GUI
        print(_SplashObject.CVControllers.Length);
        for (int i = 0; i < _SplashObject.CVControllers.Length; i++)
        {
            _ControllerGUI = SRResources.Panel_CV_Controllers.Instantiate(_CVControllerParent).GetComponent<CVControllerGUI>();
            _ControllerGUI.Initialize(_SplashObject.CVControllers[i]);
        }       
    }
}
