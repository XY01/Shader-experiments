using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class SplashObject_GUI : MonoBehaviour
{
    SplashObjectBase _SplashObject;

    public Text _ObjectNameText;

    public CVSlider _FadeSlider;
    public RectTransform _CVControllersParent;
    public Button _BtnReset;

    List<CVControllerGUI> controlGUIs = new List<CVControllerGUI>();

    // Start is called before the first frame update
    public void Initialize(SplashObjectBase splashObj)
    {
        // Set the splash object
        _SplashObject = splashObj;

        _ObjectNameText.text = splashObj.name;

        // Set up fade slider
        _FadeSlider.Init(_SplashObject._FadeCV);

        _BtnReset.onClick.AddListener(() => Reset());

        controlGUIs = new List<CVControllerGUI>();

        // Create GUI for each of the splash object CV controllers
        for (int i = 0; i < _SplashObject.CVControllers.Length; i++)
        {
            CVControllerGUI newCtrlrGUI = SRResources.Panel_CV_Controllers.Instantiate(_CVControllersParent).GetComponent<CVControllerGUI>();
            newCtrlrGUI.Initialize(_SplashObject.CVControllers[i]);
            controlGUIs.Add(newCtrlrGUI);
        }
    }

    void Reset()
    {
        foreach(CVControllerGUI gui in controlGUIs)
        {
            foreach(CVSlider slider in gui._CVSliders)
            {
                slider._CV.Reset();
            }
        }
    }
}
