using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TransformArray_Radial : MonoBehaviour
{
    public float _Radius = 1;
    public int _Divisions = 6;
    public GameObject _Prefab;
    public Transform[] _SpawnedTransforms;
    public float _Scale = 1;
    public Vector3 _RotationOffset;

    [ContextMenu("Populate")]
    void Populate()
    {
        _SpawnedTransforms = new Transform[_Divisions];

        // Remove existing transforms
        if(transform.childCount > 0)
        {
            TransformExtensions.DestroyAllChildrenImmediate(transform);
        }

        // Populate transforms
        for (int i = 0; i < _Divisions; i++)
        {
            float norm = i / (float)_Divisions;

            float angle = norm * 360;

            float x = Mathf.Sin(angle * Mathf.Deg2Rad) * _Radius;
            float y = Mathf.Cos(angle * Mathf.Deg2Rad) * _Radius;

            Transform newT = Instantiate(_Prefab, transform).GetComponent<Transform>();
            newT.localScale = Vector3.one * _Scale;

            newT.position = transform.TransformPoint(new Vector3(x, y, 0));
            newT.localRotation = Quaternion.Euler(0 + _RotationOffset.x, 0 + _RotationOffset.y, -angle + _RotationOffset.z);
        }
    }
    

    private void OnDrawGizmos()
    {
        for (int i = 0; i < _Divisions; i++)
        {
            float norm = i / (float)_Divisions;

            float angle = norm * 360;

            float x = Mathf.Sin(angle * Mathf.Deg2Rad) * _Radius;
            float y = Mathf.Cos(angle * Mathf.Deg2Rad) * _Radius;

            Gizmos.DrawWireSphere(transform.TransformPoint(new Vector3(x, y, 0)), _Scale);
        }
    }
}
