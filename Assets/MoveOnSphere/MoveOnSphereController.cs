using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MoveOnSphereController : MonoBehaviour 
{
	[SerializeField] private float _radius = 10f;
	[SerializeField] private float _speed = 1f;

    public float _PerlSpeed = .1f;

	private float _azimuth = 0f;	// In radians
	private float _elevation = 0f;	// In radians

	private Transform _transform;

    float _PerlOffset;

	void Awake()
	{
		_transform = transform;
        _PerlOffset = Random.value * 1000;
        _PerlSpeed = Random.Range(.2f, .8f);

    }

	void Update()
	{
		HandleInput();
		UpdatePosition();
	}

	private void HandleInput()
	{
		float h = Mathf.PerlinNoise((Time.time * _PerlSpeed*.5f) + _PerlOffset, (Time.time * _PerlSpeed*.3f) + _PerlOffset);  //Input.GetAxis("Horizontal");
        float v = Mathf.PerlinNoise((Time.time * _PerlSpeed) + _PerlOffset, (Time.time * _PerlSpeed*1.5f) + _PerlOffset);  // Input.GetAxis("Vertical");

		_azimuth += h * Time.deltaTime * _speed;
		_elevation += v * Time.deltaTime * _speed;

		_azimuth = ClampAngle(_azimuth);
		_elevation = ClampAngle(_elevation);
	}

	private void UpdatePosition()
	{
		float x = _radius * Mathf.Cos(_elevation) * Mathf.Cos(_azimuth);
		float y = _radius * Mathf.Sin(_elevation);
		float z = _radius * Mathf.Cos(_elevation) * Mathf.Sin(_azimuth);

		_transform.localPosition = new Vector3(x, y, z);
	}

	private static float ClampAngle(float angle)
	{
		while (angle > Mathf.PI)
		{
			angle -= 2f * Mathf.PI;
		}
		while (angle < -Mathf.PI)
		{
			angle += 2f * Mathf.PI;
		}
		return angle;
	}
}
