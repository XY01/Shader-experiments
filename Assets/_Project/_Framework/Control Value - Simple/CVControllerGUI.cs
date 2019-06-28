using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

/// <summary>
/// A gui for a collection of control values made up of CV sliders
/// </summary>
public class CVControllerGUI : MonoBehaviour
{
    public Text _HeadingText;
    CVControllerBase _Controller;
    GameObject[] _SliderParents;
    public CVSlider[] _CVSliders;
    Button[] _CVColButtons;
  

    int _SelectedColControllerIndex;

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
            _CVSliders[i].Init(_Controller._ControlValues[index]);//.onValueChanged.AddListener((float f) => _Controller._ControlValues[index]._NormalizedValue = f);
        }

        _CVColButtons = new Button[_Controller._ControlColours.Length];
        for (int i = 0; i < _CVColButtons.Length; i++)
        {
            int index = i;
            _CVColButtons[i] = SRResources.UI.Button_Colour_Select.Instantiate(transform).GetComponent<Button>();
            _CVColButtons[i].GetComponentInChildren<Text>().text = _Controller._ControlColours[i]._Name;
            _CVColButtons[i].GetComponentInChildren<Image>().color = _Controller._ControlColours[i]._Col;
            _CVColButtons[i].onClick.AddListener(() => OpenColourPickerAndAssignControlCol(index));
        }
    }

    void OpenColourPickerAndAssignControlCol(int index)
    {
        _SelectedColControllerIndex = index;
        ColourPicker.Instance.Open(_Controller._ControlColours[index]._Col, SetControlAndButtonCol);// _Controller._ControlColours[index].SetColour);
    }

    void SetControlAndButtonCol(HSBColor col)
    {
        _CVColButtons[_SelectedColControllerIndex].GetComponentInChildren<Image>().color = col.ToColor();
        _Controller._ControlColours[_SelectedColControllerIndex].SetColour(col);
    }

}
