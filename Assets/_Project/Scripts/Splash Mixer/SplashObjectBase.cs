using System.Collections;
using System.Collections.Generic;
using UnityEngine;

/// <summary>
/// A Splash objectt is a sinple object that 
///  - Activates and deactivates smoothly. Either throguh fade, scaling or animation
///  - Has a variety of conntrollers which are displayed in the UI so it can be manipulated 
/// </summary>
public class SplashObjectBase : MonoBehaviour
{
    CVControllerBase[] _CVControllers;

    public string _OSCPrefix;

    // Start is called before the first frame update
    void Start()
    {
        _CVControllers = GetComponentsInChildren<CVControllerBase>();
        _OSCPrefix = "/"+name;

        for (int i = 0; i < _CVControllers.Length; i++)
        {
            _CVControllers[i].Init(_OSCPrefix);
        }
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    // Activate splash object
    protected void Activate()
    {

    }

    // Deactivate splash object
    protected void Deactivate()
    {

    }
}
