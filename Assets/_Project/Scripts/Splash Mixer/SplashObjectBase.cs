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

    // Choose a CV for this to control by name
    [HideInInspector] public ControlValue _FadeCV;

    // Start is called before the first frame update
    void Awake()
    {
        CVControllers = GetComponentsInChildren<CVControllerBase>();
        OSCPrefix = "/"+name;

        _FadeCV = new ControlValue("fade", 1, 0, 1, OSCPrefix + "/");

        // Find the master CV to attach to the fade CV
        for (int i = 0; i < CVControllers.Length; i++)
        {
            for (int j = 0; j < CVControllers[i]._ControlValues.Length; j++)
            {
                if (CVControllers[i]._ControlValues[j]._Master)
                {
                    _FadeCV._LinkedControlValue = CVControllers[i]._ControlValues[j];
                    print(name + "  Master CV found " + CVControllers[i]._ControlValues[j]._Name);
                }
            }
        }

        _FadeCV._NormalizedValue = 0;
       

        for (int i = 0; i < CVControllers.Length; i++)
        {
            CVControllers[i].Init(OSCPrefix);
        }
    }

    // Update is called once per frame
    void Update()
    {
        _FadeCV.UpdateValue(Time.deltaTime);
    }

    // Activate splash object
    public virtual void Activate()
    {
        gameObject.SetActive(true);
        StartCoroutine("FadeInRoutine");
    }

    // Deactivate splash object
    public virtual void Deactivate()
    {        
        if(gameObject.activeSelf)
            StartCoroutine("FadeOutRoutine");
    }

    protected virtual IEnumerator FadeOutRoutine()
    {
        _FadeCV._NormalizedValue = 1;

        float timer = 0;
        float duration = 1f;

        while(timer < duration)
        {
            timer += Time.deltaTime;
            yield return new WaitForEndOfFrame();

            _FadeCV._NormalizedValue = 1 - (timer / duration);
        }

        _FadeCV._NormalizedValue = 0;
        gameObject.SetActive(false);
    }

    protected virtual IEnumerator FadeInRoutine()
    {
        _FadeCV._NormalizedValue = 0;

        if (_FadeCV._LinkedControlValue != null)
        {
            _FadeCV._LinkedControlValue._NormalizedValue = 0;
            _FadeCV._LinkedControlValue.UpdateValue(Time.deltaTime);
        }

        float timer = 0;
        float duration = 1f;

        while (timer < duration)
        {
            timer += Time.deltaTime;
            yield return new WaitForEndOfFrame();

            _FadeCV._NormalizedValue = timer / duration;
        }

        _FadeCV._NormalizedValue = 1;        
    }
}
