using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System.Linq;

[RequireComponent(typeof(Rigidbody))]
public class RadialAwareness : MonoBehaviour
{
    public List<GameObject> ObjectsInRange { get; private set; } = new List<GameObject>();
    public bool HasObjectsInRange { get { return ObjectsInRange.Count > 0; } }
    GameObject _ClosestObject;

    SphereCollider _RigidCollider;
    SphereCollider _TriggerCollider;

    public float _AwarenessRadius = 3;

    // The amount of influence that objects based on distance
    public AnimationCurve _InfluenceFalloffCurve;

    public bool _DrawGizmos = false;

    private void Start()
    {
        _RigidCollider = GetComponent<SphereCollider>();

        _TriggerCollider = gameObject.AddComponent<SphereCollider>();
        _TriggerCollider.radius = _AwarenessRadius;
        _TriggerCollider.isTrigger = true;
    }

    public Vector3 AverageDirection()
    {
        Vector3 averageVec = Vector3.zero;

        if (HasObjectsInRange)
        {
            Vector3 aggregateDir = Vector3.zero;
            foreach (GameObject go in ObjectsInRange)
            {
                aggregateDir += go.transform.position - transform.position;
            }

            averageVec = aggregateDir / ObjectsInRange.Count;
        }

        return averageVec;
    }

    public Vector3 DirectionToDesiredDistance(float dist)
    {
        Vector3 desiredPos = Vector3.zero;
        Vector3 desiredDir = Vector3.zero;

        if (HasObjectsInRange)
        {           
            foreach (GameObject go in ObjectsInRange)
            {
                Vector3 directionTo = go.transform.position - transform.position;

                desiredPos += go.transform.position - (directionTo.normalized * dist);
            }

            desiredPos /= ObjectsInRange.Count;
            desiredDir = desiredPos - transform.position;
        }

        return desiredDir;
    }

    public GameObject ClosestObject()
    {
        if (HasObjectsInRange)
        {
            ObjectsInRange.OrderBy(go => Vector3.SqrMagnitude(go.transform.position - transform.position));
            _ClosestObject = ObjectsInRange[0];
            return _ClosestObject;
        }
        else
            return null;
    }

    #region TRIGGERS
    private void OnTriggerEnter(Collider other)
    {
        if(!ObjectsInRange.Contains(other.gameObject))
        {
            ObjectsInRange.Add(other.gameObject);
        }
    }

    private void OnTriggerExit(Collider other)
    {
        if (ObjectsInRange.Contains(other.gameObject))
        {
            ObjectsInRange.Remove(other.gameObject);
        }
    }
    #endregion
        
    private void OnDrawGizmos()
    {
        if(Application.isPlaying && _DrawGizmos)
        {
            if (HasObjectsInRange)
            {
                Gizmos.color = Color.red;
                for (int i = 0; i < ObjectsInRange.Count; i++)
                {
                    Gizmos.DrawLine(transform.position, ObjectsInRange[i].transform.position);
                }

                Gizmos.color = Color.blue;
                Gizmos.DrawLine(transform.position, ClosestObject().transform.position);
            }

            if (_ClosestObject != null)
            {
                Gizmos.color = Color.yellow;
                Gizmos.DrawLine(transform.position, _ClosestObject.transform.position);
            }
        }
    }
}
