using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ScaleInOut : MonoBehaviour
{
    public AnimationCurve _Curve;
    public float _ScaleDuration = 1;
    public float _Scale = 1;

    // Start is called before the first frame update
    void Start()
    {
        StartCoroutine(ScaleIn());
    }

    IEnumerator ScaleIn()
    {
        float timer = 0;
        while(timer < _ScaleDuration)
        {
            timer += Time.deltaTime;

            transform.localScale = Vector3.one * _Curve.Evaluate(Mathf.Clamp01(timer/_ScaleDuration)) * _Scale;
            yield return new WaitForEndOfFrame();
        }
    }

    IEnumerator ScaleOut()
    {
        float timer = 0;
        while (timer < _ScaleDuration)
        {
            timer += Time.deltaTime;

            transform.localScale = Vector3.one * _Curve.Evaluate(1-Mathf.Clamp01(timer / _ScaleDuration)) * _Scale;
            yield return new WaitForEndOfFrame();
        }

        Destroy(gameObject);
    }
}
