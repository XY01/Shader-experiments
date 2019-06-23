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

    public SplashObjectLayer ActiveLayer { get; private set; }
    public List<SplashObjectLayer> _Layers = new List<SplashObjectLayer>();
    
    public SplashObjectBase[] _AllSplashObjects;
    public string[] _AllObjectNames;

    SplashObjectBase _SplashObject;    
    CVControllerGUI _ControllerGUI;

    public RectTransform _CVControllerParent;

    private void Awake()
    {
        Instance = this;

        // Populate objects and object names
        _AllSplashObjects = FindObjectsOfType<SplashObjectBase>();
        foreach (SplashObjectBase so in _AllSplashObjects)
            so.Deactivate();

        _AllObjectNames = new string[_AllSplashObjects.Length];
        for (int i = 0; i < _AllObjectNames.Length; i++)
        {
            _AllObjectNames[i] = _AllSplashObjects[i].name;
        }
    }

    private void Start()
    {
        // Find all layers
        _Layers = new List<SplashObjectLayer>(GetComponentsInChildren<SplashObjectLayer>());
        ActiveLayer = _Layers[0];
    }
    
    public void SelectLayerAndOpenSelection(int index)
    {
        ActiveLayer = _Layers[index];
        SplashMixer_GUIManager.Instance.OpenObjectSelection();
    }
}
