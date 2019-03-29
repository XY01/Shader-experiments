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
        _ScaleSlider.value = transform.localScale.x;
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
}
