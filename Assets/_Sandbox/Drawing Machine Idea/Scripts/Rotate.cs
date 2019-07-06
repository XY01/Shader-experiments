using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Rotate : MonoBehaviour
{
    public float _Speed = 90;
    public Vector3 _Axis = Vector3.right;

    void Update()
    {
        transform.Rotate(_Axis, _Speed * Time.deltaTime);
    }
}
