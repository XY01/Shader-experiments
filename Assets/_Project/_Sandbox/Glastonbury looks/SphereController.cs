using System.Collections;
using System.Collections.Generic;
using UnityEngine;

/// <summary>
/// Control input points on a spehre using Mouse or VR
/// </summary>
public class SphereController : MonoBehaviour
{
    public Transform[] _InputTransforms;

    public Transform _InputTransform;
    public Transform _OutputTransform;
    public float _Radius = 5;

    public enum Mirror
    {
        None,
        LeftRight,
        TopBottom,
        QuadrantsAroundY,
    }

    public enum ControlSource
    {
        Mouse,
        VR,
    }

    public Mirror _Mirror = Mirror.None;
    public ControlSource _ControlSource = ControlSource.Mouse;
    
    private void Update()
    {        
        _OutputTransform.position = CoordinateConverter.SphericalToCartesian(_InputTransform.position.x, _InputTransform.transform.position.y, _Radius);
    }
}
