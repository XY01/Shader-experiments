using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MoveOnSphereOffsetController : MonoBehaviour 
{
	[SerializeField] private float _radius = 10f;
	[SerializeField] private float _speed = 1f;
	[SerializeField] private Vector3 _offset = Vector3.zero;

	private float _azimuth = 0f;	// In radians
	private float _elevation = 0f;	// In radians

	private Transform _transform;

	void Awake()
	{
		_transform = transform;
	}

	void Update()
	{
		HandleInput();
		UpdatePosition();
	}

	private void HandleInput()
	{
		float h = Input.GetAxis("Horizontal");
		float v = Input.GetAxis("Vertical");

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

		_transform.localPosition = _offset + new Vector3(x, y, z);
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
