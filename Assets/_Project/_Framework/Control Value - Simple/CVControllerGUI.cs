using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class CVControllerGUI : MonoBehaviour
{
    public Text _HeadingText;
    CVControllerBase _Controller;
    GameObject[] _SliderParents;
    CVSlider[] _CVSliders;

    public void Initialize(CVControllerBase controller)
    {
        _Controller = controller;
        _HeadingText.text = _Controller.OSCAddress;

        _SliderParents = new GameObject[_Controller._ControlValues.Length];
        _CVSliders = new CVSlider[_Controller._ControlValues.Length];
        for (int i = 0; i < _SliderParents.Length; i++)
        {
            int index = i;
            _SliderParents[i] = SRResources.CV_Slider.Instantiate(transform);
            _SliderParents[i].GetComponentInChildren<Text>().text = _Controller._ControlValues[i]._Name;

            _CVSliders[i] = _SliderParents[i].GetComponentInChildren<CVSlider>();
            _CVSliders[i].onValueChanged.AddListener((float f) => _Controller._ControlValues[index]._NormalizedValue = f);
        }

        UpdateSliders();
    }

    private void Update()
    {
        UpdateSliders();
    }

    private void UpdateSliders()
    {
        for (int i = 0; i < _SliderParents.Length; i++)
        {
            _CVSliders[i].SetValue(  _Controller._ControlValues[i]._NormalizedValue, false );
        }
    }
}
