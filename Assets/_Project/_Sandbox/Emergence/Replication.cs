using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Replication : MonoBehaviour
{
    public int _Generation = 0;
    float _Duration = 4;

    public int _MaxReplications = 3;
    public int _MaxCount = 30;

    void Start()
    {
        _Generation++;
        Invoke("Replicate", _Duration);
    }

    void Replicate()
    {
        if (FindObjectsOfType<Replication>().Length >= _MaxCount)
            return;

        GameObject replicatedObject = Instantiate(gameObject, transform.position + (Random.onUnitSphere * transform.localScale.x * .6f), Quaternion.identity);
        _MaxReplications--;

        if (_MaxReplications > 0)
            Invoke("Replicate", _Duration);
    }
}
