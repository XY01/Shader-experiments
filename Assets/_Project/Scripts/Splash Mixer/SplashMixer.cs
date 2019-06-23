using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;


/// <summary>
/// TODO
/// Select obbjeect for layer
/// Splash object GUI
/// 
/// Add layers
/// - Skin
/// - Particles
/// - Audio react
/// - Drawing
/// 
/// Render output on a teh actual sphere
/// Get a copy of the CAD file for better previz
/// Add audio reactivity 
/// 
/// Auto build UI in osc control
/// </summary>
public class SplashMixer : MonoBehaviour
{
    public static SplashMixer Instance;

    public List<SplashObjectLayer> _Layers = new List<SplashObjectLayer>();

    public SplashObjectBase[] _AllSplashObjects;

    SplashObjectBase _SplashObject;
    CVControllerGUI _ControllerGUI;

    public RectTransform _CVControllerParent;

    private void Awake()
    {
        Instance = this;

        _AllSplashObjects = FindObjectsOfType<SplashObjectBase>();
    }

    private void Start()
    {
        // Find all layers
        _Layers = new List<SplashObjectLayer>(GetComponentsInChildren<SplashObjectLayer>());

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
