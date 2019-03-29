using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class LookAt : MonoBehaviour
{
    public Transform _LookAt;

    // Update is called once per frame
    void Update()
    {

        transform.rotation = Quaternion.LookRotation(_LookAt.position - transform.position, Vector3.right);// Quaternion.Slerp(transform.rotation, , Time.deltaTime * 10);
    }
}
