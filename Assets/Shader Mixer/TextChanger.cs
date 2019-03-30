using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class TextChanger : MonoBehaviour
{
    public KeyCode _Key = KeyCode.LeftShift;
    public string _AltText;
    string _BaseText;
    Text _Text;

    // Start is called before the first frame update
    void Start()
    {
        _Text = GetComponentInChildren<Text>();
        _BaseText = _Text.text;
    }

    // Update is called once per frame
    void Update()
    {
        if (Input.GetKey(_Key))
            _Text.text = _AltText;
        else
            _Text.text = _BaseText;
    }
}
