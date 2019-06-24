using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SplashObjectLayer : MonoBehaviour
{
    SplashObjectBase _SplashObject;  
    public bool _Draw = false;
    public SplashObjectLayerGUI _GUI;

    public float _LayerScaler = 1;

    private void Start()
    {
        _GUI.Init(this);
    }

    private void Update()
    {
    }

    public void SetActiveObject(SplashObjectBase so)
    {
        // Deacctivate current SO
        if (_SplashObject != null)
            _SplashObject.Deactivate();

        // Activate new Splash Object
        _SplashObject = so;
        _SplashObject.Activate();

        // Hacks - TODO fix
        _SplashObject.transform.localScale = Vector3.one * 2.5f * _LayerScaler;

        _GUI.SetActiveObject(_SplashObject);
    }

    public void DeactivateObject()
    {
        // Deacctivate current SO
        if (_SplashObject != null)
        {
            _SplashObject.Deactivate();
            _SplashObject = null;
            _GUI.DestroyGUI();
        }
    }
}
