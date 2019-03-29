using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;



[System.Serializable]
public class ShaderPropFloat : MonoBehaviour
{
    public ShaderObject _Object;
    public string _Name;
    public float _Value;

    private void Start()
    {
        _Value = _Object._Mat.GetFloat(_Name);

        Slider s  = GetComponentInChildren<Slider>();
        if(s !=null)
        {
            print("Setting value " + _Value);
            s.value = _Value;
        }
    }

    public void UpdateValue(float val)
    {
        _Value = val;
        _Object.UpdateFloat(_Name, _Value);
    }
}
