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

    public void UpdateColor(string name, Color col)
    {
        print(name + "    Setting col: " + name + "   " + col);
        _Mat.SetColor(name, col);
    }

    public void UpdateVector4(string name, Vector4 vec)
    {
        //print(name + "    Setting vec4: " + name + "   " + vec);
        _Mat.SetColor(name, vec);        
    }

    public void SetScale(float scale)
    {
        _Scale = scale;
        transform.localScale = Vector3.one * _Scale;
    }

    public void Load(int index)
    {
        int active = PlayerPrefs.GetInt(name + "_Active" + index, 1);

        if (active == 1)
            gameObject.SetActive(true);
        else
            gameObject.SetActive(false);

        _Scale = PlayerPrefs.GetFloat(name + "_Scale" + index, 3);
        transform.localScale = Vector3.one * _Scale;
        UpdateSlider();
    }

    public void Save(int index)
    {
        PlayerPrefs.SetFloat(name + "_Scale" + index, _Scale);

        if(gameObject.activeSelf)
            PlayerPrefs.SetInt(name + "_Active" + index, 1);
        else
            PlayerPrefs.SetInt(name + "_Active" + index, 0);
    }
}
