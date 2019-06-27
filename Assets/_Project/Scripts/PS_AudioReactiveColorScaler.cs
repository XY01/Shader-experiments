using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[RequireComponent(typeof(ParticleSystem))]
public class PS_AudioReactiveColorScaler : MonoBehaviour
{
    ParticleSystem _PS;
    ParticleSystem.Particle[] _Particles;

    public Color _LowCol = Color.black;
    public Color _HighCol = Color.white;
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

            _Particles[i].startColor = Color.Lerp(_LowCol, _HighCol, lerp);  
        }

        _PS.SetParticles(_Particles, particleAlive);
    }
}
