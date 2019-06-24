using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[RequireComponent(typeof(Camera))]
public class CameraLayerMaskSwitcher : MonoBehaviour
{
    public LayerMask[] _LayerMasks;
    Camera _Camera;

    private void Start()
    {
        _Camera = GetComponent<Camera>();
    }

    public void SetLayerMask(int index)
    {
        _Camera.cullingMask = _LayerMasks[index].value;
    }
}
