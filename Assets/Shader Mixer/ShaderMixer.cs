using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ShaderMixer : MonoBehaviour
{
    ShaderObject[] _ShaderObjects;
    ShaderPropFloat[] _ShaderProps;

    // Start is called before the first frame update
    void Start()
    {
        _ShaderObjects = FindObjectsOfType<ShaderObject>();
        _ShaderProps = FindObjectsOfType<ShaderPropFloat>();
    }

    // Update is called once per frame
    void Update()
    {
        if(Input.GetKey(KeyCode.Alpha0))
        {

        }

        if (Input.GetKey(KeyCode.LeftShift))
        {
            if (Input.GetKey(KeyCode.Escape))
            {
                Application.Quit();
            }

            if (Input.GetKey(KeyCode.Alpha0))
            {

            }
        }
    }

    public void Load(int index)
    {
        for (int i = 0; i < _ShaderObjects.Length; i++)
        {
            _ShaderObjects[i].Load(index);
        }

        for (int i = 0; i < _ShaderProps.Length; i++)
        {
            _ShaderProps[i].Load(index);
        }
    }

    public void Save(int index)
    {
        for (int i = 0; i < _ShaderObjects.Length; i++)
        {
            _ShaderObjects[i].Save(index);
        }

        for (int i = 0; i < _ShaderProps.Length; i++)
        {
            _ShaderProps[i].Save(index);
        }
    }
}

