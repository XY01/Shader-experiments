using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[RequireComponent(typeof(Camera))]
public class CameraLayerMaskSwitcher : MonoBehaviour
{
    public LayerMask[] _LayerMasks;
    Camera _Camera;

    // TODO hax
    public Transform _MappingSphere;

    public int _DefaultMask = 0;

    private void Start()
    {
        _Camera = GetComponent<Camera>();
        _MappingSphere.gameObject.SetActive(true);
        SetLayerMask(_DefaultMask);
    }

    public void SetLayerMask(int index)
    {
        _Camera.cullingMask = _LayerMasks[index].value;
    }
}
