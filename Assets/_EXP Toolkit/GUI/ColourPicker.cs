using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using System;

[RequireComponent(typeof(RectTransform))]
public class ColourPicker : MonoBehaviour
{
    public static ColourPicker Instance;

    public delegate void ColourChangeEvent(Color col);
    public ColourChangeEvent OnColourChangeEvent;

    CanvasGroup _CanvasGroup;

    public SetSlider _HSLider;
    public SetSlider _SSLider;
    public SetSlider _VSLider;
    public SetSlider _ASLider;
    
    public Image m_Swatch;

    HSBColor _HSBCol;
    public Color CurrentCol { get { return _HSBCol.ToColor(); } }

    Action<HSBColor> _Callback;

    private void Awake()
    {
        Instance = this;        
        _HSBCol = new HSBColor(Color.white);
        _HSLider.onValueChanged.AddListener((float f) => UpdateColour());
        _SSLider.onValueChanged.AddListener((float f) => UpdateColour());
        _VSLider.onValueChanged.AddListener((float f) => UpdateColour());
        _ASLider.onValueChanged.AddListener((float f) => UpdateColour());

        _CanvasGroup = GetComponent<CanvasGroup>();

        SetCol(_HSBCol);

        Close();
    }
    
    void UpdateColour()
    {
        _HSBCol.h = _HSLider.normalizedValue;
        _HSBCol.s = _SSLider.normalizedValue;
        _HSBCol.b = _VSLider.normalizedValue;
        _HSBCol.a = _ASLider.normalizedValue;

        m_Swatch.color = CurrentCol;
        OnColourChangeEvent?.Invoke(CurrentCol);

        if (_Callback != null)
            _Callback.Invoke(_HSBCol);
    }

    void SetCol(HSBColor col)
    {
        _HSBCol.h = col.h;
        _HSBCol.s = col.s;
        _HSBCol.b = col.b;
        _HSBCol.a = col.a;

        _HSLider.SetValue(_HSBCol.h,false);
        _SSLider.SetValue(_HSBCol.s, false);
        _VSLider.SetValue(_HSBCol.b, false);
        _ASLider.SetValue(_HSBCol.a, false);

    }
    
    public void Open(Color col, Action<HSBColor> callback = null)
    {
        _CanvasGroup.alpha = 1;
        _CanvasGroup.interactable = true;

        SetCol(HSBColor.FromColor(col));

        if (callback != null)
            _Callback = callback;
    }


    public void Close()
    {
        _CanvasGroup.alpha = 0;
        _CanvasGroup.interactable = false;
        _Callback = null;
    }
}
