﻿using System.Collections;
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
    public Transform _SplsahObjectParent;

    SplashObjectBase _SplashObject;    
    CVControllerGUI _ControllerGUI;

    public RectTransform _CVControllerParent;
    

    private void Awake()
    {
        Instance = this;

        // Populate objects and object names
        _AllSplashObjects = new SplashObjectBase[_SplsahObjectParent.childCount];
        for (int i = 0; i < _SplsahObjectParent.childCount; i++)
        {
            _AllSplashObjects[i] = _SplsahObjectParent.GetChild(i).GetComponent<SplashObjectBase>();
            print(i);
            _AllSplashObjects[i].Deactivate();
        }
    }

    private void Start()
    {
        // Find all layers
        _Layers = new List<SplashObjectLayer>(GetComponentsInChildren<SplashObjectLayer>());
        ActiveLayer = _Layers[0];
    }

    private void Update()
    {
        if (Input.GetKey(KeyCode.LeftShift) && Input.GetKeyDown(KeyCode.Escape))
            Application.Quit();
    }

    public void SelectLayerAndOpenSelection(SplashObjectLayer layer)
    {
        ActiveLayer = layer;
        SplashMixer_GUIManager.Instance.OpenObjectSelection();
    }
}
