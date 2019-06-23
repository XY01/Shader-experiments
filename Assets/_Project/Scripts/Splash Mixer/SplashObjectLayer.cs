using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SplashObjectLayer : MonoBehaviour
{
    SplashObjectBase _SplashObject;
  
    public bool _Draw = false;

    SplashObject_GUI _SOGUI;

    private void Update()
    {
        if (Input.GetKeyDown(KeyCode.Alpha1))
            SetActiveObject(SplashMixer.Instance._AllSplashObjects[0]);
    }

    public void SetActiveObject(SplashObjectBase so)
    {
        // Deacctivate current SO
        if (_SplashObject != null)
        {
            _SplashObject.Deactivate();
            Destroy(_SOGUI.gameObject);
        }

        // Activate new Splash Object
        _SplashObject = so;
        _SplashObject.Activate();

        // Create new GUI
        _SOGUI = SplashMixer_GUIManager.Instance.CreateSplashObjectGUI(_SplashObject);
    }    
}
