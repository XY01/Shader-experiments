using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[RequireComponent(typeof(RadialAwareness))]
public class Emergence_Attraction : MonoBehaviour
{
    public enum Mode
    {
        Repel,
        Attract,
        DesiredDistance,
    }

    public Mode _Mode = Mode.Attract;
    public RadialAwareness RadialAwareness { get; private set; }
    public float _Speed = 1;

    public float _DesiredDistance = 1;
    Vector3 _Direction;
    Rigidbody _RB;

    public bool _UseRigidbodyPhysics = true;

    // Start is called before the first frame update
    void Start()
    {
        _RB = GetComponent<Rigidbody>();
        RadialAwareness = GetComponent<RadialAwareness>();
    }

    // Update is called once per frame
    void Update()
    {
        if (RadialAwareness.HasObjectsInRange)
        {
            Vector3 _Direction = Vector3.zero;

            switch (_Mode)
            {
                case Mode.Attract:
                    _Direction = RadialAwareness.AverageDirection();
                    break;
                case Mode.Repel:
                    _Direction = -RadialAwareness.AverageDirection();
                    break;
                case Mode.DesiredDistance:
                    _Direction = RadialAwareness.DirectionToDesiredDistance(_DesiredDistance);
                    break;

            }
            
            if (_UseRigidbodyPhysics)
                _RB.AddForce(_Direction * Time.deltaTime * _Speed);
            else
                transform.Translate(_Direction * Time.deltaTime * _Speed);

           
            Debug.DrawLine(transform.position, transform.position + _Direction );
        }
    }

    private void OnDrawGizmos()
    {
        if (Application.isPlaying)
        {
            Gizmos.color = Color.yellow;
            //Gizmos.DrawLine(transform.position, transform.position + (_Direction * 3));
            //Gizmos.DrawSphere(transform.position + (_Direction), .5f);
        }
    }
}
