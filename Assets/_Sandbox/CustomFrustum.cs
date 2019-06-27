using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CustomFrustum : MonoBehaviour
{
    // Start is called before the first frame update
    void Start()
    {
        Camera cam = GetComponent<Camera>();
        cam.projectionMatrix = Matrix4x4.Frustum(-.5f, .5f, -.1f, .1f, 1, 100);
    }

    // Update is called once per frame
    void Update()
    {
        Camera cam = GetComponent<Camera>();
        if (Input.GetKeyDown(KeyCode.I))
            cam.projectionMatrix = cam.projectionMatrix;
    }
}
