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
    public CVControllerBase[] CVControllers { private set; get; }
    public string OSCPrefix { private set; get; }

    public ControlValue _FadeCV;

    // Start is called before the first frame update
    void Awake()
    {
        CVControllers = GetComponentsInChildren<CVControllerBase>();
        OSCPrefix = "/"+name;

        _FadeCV = new ControlValue("fade", 1, 0, 1, OSCPrefix + "/");

        for (int i = 0; i < CVControllers.Length; i++)
        {
            CVControllers[i].Init(OSCPrefix);
        }
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    // Activate splash object
    public void Activate()
    {

    }

    // Deactivate splash object
    public void Deactivate()
    {

    }
}
