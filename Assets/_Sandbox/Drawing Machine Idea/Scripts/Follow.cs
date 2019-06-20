using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Follow : MonoBehaviour
{
    public Transform _Follow;
    public float _Smooth = 0;

    void Update()
    {
        if (_Smooth == 0)
        {
            transform.position = _Follow.position;
        }
        else
        {
            transform.position = Vector3.Lerp(transform.position, _Follow.position, Time.deltaTime * _Smooth);
        }
    }
}
