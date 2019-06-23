using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class CVControllerGUI : MonoBehaviour
{
    public Text _HeadingText;
    CVControllerBase _Controller;
    GameObject[] _CVSlider;

    public void Initialize(CVControllerBase controller)
    {
        _Controller = controller;
        _HeadingText.text = _Controller.OSCAddress;

        _CVSlider = new GameObject[_Controller._ControlValues.Length];
        for (int i = 0; i < _CVSlider.Length; i++)
        {
            _CVSlider[i] = SRResources.CV_Slider.Instantiate(transform);
            _CVSlider[i].GetComponentInChildren<Text>().text = _Controller._ControlValues[i]._Name;
        }

        UpdateSliders();
    }

    private void UpdateSliders()
    {
        for (int i = 0; i < _CVSlider.Length; i++)
        {
            _CVSlider[i].GetComponentInChildren<Slider>().normalizedValue = _Controller._ControlValues[i]._NormalizedValue;
        }
    }
}
