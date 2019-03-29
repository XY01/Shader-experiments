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

    string _SerializedName;

    private void Start()
    {
        _Value = _Object._Mat.GetFloat(_Name);

        Slider s  = GetComponentInChildren<Slider>();
        if(s !=null)
        {
            print("Setting value " + _Value);
            s.value = _Value;

            s.name = "Slider " + _Name;
        }

        _SerializedName = _Object.name + _Name + _Value;
    }

    void UpdateSlder()
    {
        Slider s = GetComponentInChildren<Slider>();
        if (s != null)
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


    public void Load(int index)
    {
        _Value = PlayerPrefs.GetFloat(_SerializedName + index, _Value);


        print("Loading:  " + _SerializedName + index + "     Value: " + _Value);


        UpdateValue(_Value);
        UpdateSlder();
    }

    public void Save(int index)
    {
     
        PlayerPrefs.SetFloat(_SerializedName + index, _Value);

        print("Saving:  " + _SerializedName + index + "     Value: " + _Value);
    }
}
