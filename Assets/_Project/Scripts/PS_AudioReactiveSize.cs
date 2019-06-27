using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[RequireComponent(typeof(ParticleSystem))]
public class PS_AudioReactiveSize : MonoBehaviour
{
    ParticleSystem _PS;
    ParticleSystem.Particle[] _Particles;

    public Vector2 _SizeRange = new Vector2(.01f, .1f);
    public bool _ScaleByParticleNorm = false;

    DataRacketIn _DataRacketIn;
    public DataInType _DataRacketType = DataInType.DR_Centroid;

    void Start()
    {
        _DataRacketIn = DataRacketIn.Instance;
        _PS = GetComponent<ParticleSystem>();
        _Particles = new ParticleSystem.Particle[_PS.main.maxParticles];
    }

    void Update()
    {
        int particleAlive = _PS.GetParticles(_Particles);

        for (int i = 0; i < particleAlive; i++)
        {
            float norm = _Particles[i].randomSeed / (float)uint.MaxValue;

            float lerp = _DataRacketIn.GetData(DataInType.DR_Centroid);
            if (_ScaleByParticleNorm) lerp *= norm;

            _Particles[i].startSize = Mathf.Lerp( _SizeRange.x, _SizeRange.y, lerp);  
        }

        _PS.SetParticles(_Particles, particleAlive);
    }
}
