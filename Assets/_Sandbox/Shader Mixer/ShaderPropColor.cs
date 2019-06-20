using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class ShaderPropColor : MonoBehaviour
{
    public ShaderObject _Object;
    public string _Name;
    public HSBColor _HSBCol;
    string _SerializedName;
    public Image _ColImage;

    public float _HDR = 1;

    // Start is called before the first frame update
    void Start()
    {       
        _HSBCol = HSBColor.FromColor(_Object._Mat.GetColor(_Name));
        _HSBCol.a = 1;

        UpdateGUI();

         _SerializedName = _Object.name + _Name;
    }

    void UpdateGUI()
    {
        Slider[] sliders = GetComponentsInChildren<Slider>();
        if (sliders != null)
        {
            sliders[0].value = _HSBCol.h;
            sliders[0].name = "Slider - H";
            sliders[0].onValueChanged.AddListener((float f) => SetH(f));

            sliders[1].value = _HSBCol.s;
            sliders[1].name = "Slider - S";
            sliders[1].onValueChanged.AddListener((float f) => SetS(f));

            sliders[2].value = _HSBCol.b;
            sliders[2].name = "Slider - B";
            sliders[2].onValueChanged.AddListener((float f) => SetB(f));

            sliders[3].value = 1;
            sliders[3].name = "Slider - HDR";
            sliders[3].onValueChanged.AddListener((float f) => SetHDR(f));
        }
        _ColImage.color = _HSBCol.ToColor();
    }

    public void Load(int index)
    {
        _HSBCol.h = PlayerPrefs.GetFloat(_SerializedName + "H" + index);
        _HSBCol.s = PlayerPrefs.GetFloat(_SerializedName + "S" + index);
        _HSBCol.b = PlayerPrefs.GetFloat(_SerializedName + "B" + index);
        _HDR = PlayerPrefs.GetFloat(_SerializedName + "HDR" + index, 1);

        _ColImage.color = _HSBCol.ToColor() * _HDR;
        UpdateMatProp();
    }

    public void Save(int index)
    {
        PlayerPrefs.SetFloat(_SerializedName + "H" + index, _HSBCol.h);
        PlayerPrefs.SetFloat(_SerializedName + "S" + index, _HSBCol.s);
        PlayerPrefs.SetFloat(_SerializedName + "B" + index, _HSBCol.b);
        PlayerPrefs.SetFloat(_SerializedName + "HDR" + index, _HDR);
    }

    void UpdateMatProp()
    {
       // _Object.UpdateColor(_Name, _HSBCol.ToColor() * _HDR);
        _Object.UpdateVector4(_Name, _HSBCol.ToColor() * _HDR);
    }

    void SetH(float f)
    {
        _HSBCol.h = f;
        _ColImage.color = _HSBCol.ToColor() * _HDR;
        UpdateMatProp();
    }

    void SetS(float f)
    {
        _HSBCol.s = f;
        _ColImage.color = _HSBCol.ToColor() * _HDR;
        UpdateMatProp();
    }

    void SetB(float f)
    {
        _HSBCol.b = f;
        _ColImage.color = _HSBCol.ToColor() * _HDR;
        UpdateMatProp();
    }

    void SetHDR(float f)
    {
        _HDR = f;
        _ColImage.color = _HSBCol.ToColor() * _HDR;        
        UpdateMatProp();
    }
}
