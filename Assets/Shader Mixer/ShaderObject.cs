using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class ShaderObject : MonoBehaviour
{
    public Material _Mat;
    public float _Scale;
    public Color _BaseCol;

    public Slider _ScaleSlider;

    private void Awake()
    {
        _Mat = GetComponent<Renderer>().material;
        _Scale = transform.localScale.x;
        UpdateSlider();
    }

    void UpdateSlider()
    {
        _ScaleSlider.value = _Scale;
    }

    public void UpdateFloat(string name, float val)
    {
        print(name + "    Setting value: " + name + "   " + val);
        _Mat.SetFloat(name, val);
    }

    public void SetScale(float scale)
    {
        transform.localScale = Vector3.one * scale;
    }

    public void Load(int i)
    {
        _Scale = PlayerPrefs.GetFloat(name + "_Scale" + i);
        transform.localScale = Vector3.one * _Scale;
        UpdateSlider();
    }

    public void Save(int i)
    {
        PlayerPrefs.SetFloat(name+"_Scale" + i, _Scale);
    }
}
