using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MirrorTransform : MonoBehaviour
{
    public Vector3 _MirrorAxis = Vector3.up;
    public Transform _InputTransformParent;
    Transform _InputTransform;
    public int _Count = 2;
    int _PrevCount = 0;

    Transform[] _MirroredTransforms;

    bool _Initialized = false;

    // Start is called before the first frame update
    void Start()
    {
        transform.position = _InputTransformParent.position;
        _InputTransform = _InputTransformParent.GetChild(0);
        UpdateMirrorTransforms();
    }

    private void Update()
    {
        if (_PrevCount != _Count)
            UpdateMirrorTransforms();

        if(_Initialized)
        {
            for (int i = 0; i < _MirroredTransforms.Length; i++)
            {
                _MirroredTransforms[i].GetChild(0).localPosition = _InputTransform.localPosition;
            }
        }
    }

    // Update is called once per frame
    void UpdateMirrorTransforms()
    {
        // Destroy all mirrored transforms
        if (_Initialized)
        {           
            for (int i = 0; i < _MirroredTransforms.Length; i++)
            {
                Destroy(_MirroredTransforms[i].gameObject);
            }
        }

        // Create array of transform parents
        _MirroredTransforms = new Transform[_Count-1];

        // Instantiate transforms
        for (int i = 0; i < _MirroredTransforms.Length; i++)
        {
            _MirroredTransforms[i] = Instantiate(_InputTransformParent, transform);
            float angle = 360f / (float)_Count;
            angle *= i + 1;

            // Set rotation around axis
            _MirroredTransforms[i].transform.localRotation = Quaternion.Euler(_MirrorAxis * angle);
        }

        _PrevCount = _Count;
        _Initialized = true;
    }
}
