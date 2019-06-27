using UnityEngine;
using System.Collections;
using System.Collections.Generic;

namespace EXPToolkit
{
    /// <summary>
    /// BPM timer provides teh 
    /// </summary>
    public class BPMCounter : MonoBehaviour
    {
        private static BPMCounter m_Instance;
        public static BPMCounter Instance
        {
            get
            {
                if (m_Instance == null)
                {
                    var go = new GameObject("BPM Counter");
                    GameObject.DontDestroyOnLoad(go);
                    m_Instance = go.AddComponent<BPMCounter>();                    
                }
                return m_Instance;
            }
        }

        public delegate void FirstBeatHandler();
        public static event FirstBeatHandler onFirstBeat;

        public delegate void BeatHandler(int beatNumber);
        public static event BeatHandler onBeat;

        public delegate void SetBPMHandler(float bpm);
        public static event SetBPMHandler onSetBPM;

        public List<float> m_BPMTaps;
        public float m_BPM = 80;
        public float BPM
        {
            get { return m_BPM; }
            set
            {
                m_BPM = value;
            }
        }

        public bool m_ShouldAddBPMTap = false;
        public float m_ElapsedTime;
        public float m_AverageTimeBetweenBeats;
        public int m_MaxBPM = 200;

        public bool m_SendOnBeat = true;

        float m_NextBeat;
        public static bool m_BeatThisFrame = false;

        string[] m_BeatDisplay = new string[4] { "O", "O", "O", "O" };
        int m_CurrentBeatIndex = 0;

        int m_BeatOSCIndex = 34; // rewind button on korg
        int m_ClearBPMOSCIndex = 35; // loop button on korg 

        int m_BarCount = 0;

        bool m_SetFirst = false;

        private void Awake()
        {
            m_Instance = this;

            if (transform.parent == null)
            {
                GameObject parent = GameObject.Find("_Managers");
                if (parent == null)
                    parent = new GameObject("_Managers");

                transform.SetParent(parent.transform);
            }

            // MasterSpeedController.OnBPMChangedEvent += SetBPM;
        }

        void Update()
        {
            if (Input.GetKeyDown(KeyCode.B))
            {
                if (Input.GetKey(KeyCode.LeftShift))
                {
                    m_SetFirst = true;
                }

                AddBeat();
            }

            m_BeatThisFrame = false;

            if (m_AverageTimeBetweenBeats != 0)
            {
                if (Time.time > m_NextBeat)
                {
                    m_BeatThisFrame = true;
                    m_NextBeat += m_AverageTimeBetweenBeats;
                    m_CurrentBeatIndex++;

                    if (m_CurrentBeatIndex == 4)
                    {
                        m_CurrentBeatIndex = 0;
                        m_BarCount++;

                        if (m_BarCount == 4)
                        {
                            // Fires first beat event which can be used to sync LFO's
                            //if(onFirstBeat != null) onFirstBeat();
                            m_BarCount = 0;
                            //print("First Bar");
                        }
                    }

                    if (onBeat != null && m_SendOnBeat)
                    {
                        onBeat(m_CurrentBeatIndex);
                    }
                }
            }
        }

        public void ToggleSendOnBeat()
        {
            m_SendOnBeat = !m_SendOnBeat;

        }

        void onSendBeat(bool state, string function)
        {
            if (function == "onSendBeat")
                m_SendOnBeat = state;
        }

        void AddFirstBeat()
        {
            m_SetFirst = true;
            AddBeat();
            m_SetFirst = false;
        }

        public void AddBeat()
        {
            if (m_SetFirst)
                if (onFirstBeat != null) onFirstBeat();

            if (m_BPMTaps.Count > 0)
                if (Time.time - m_BPMTaps[m_BPMTaps.Count - 1] > 2) m_BPMTaps.Clear();

            m_BPMTaps.Add(Time.time);            

            if (m_BPMTaps.Count > 2) CalcBPM();

            m_BeatThisFrame = true;

            // Set time of the next beat based on the average between beats
            if (m_AverageTimeBetweenBeats > 0) m_NextBeat = Time.time + m_AverageTimeBetweenBeats;

            if (onBeat != null) onBeat(m_CurrentBeatIndex);
        }


        public void CalcBPM()
        {
            m_ElapsedTime = m_BPMTaps[m_BPMTaps.Count - 1] - m_BPMTaps[0];
            m_AverageTimeBetweenBeats = m_ElapsedTime / (m_BPMTaps.Count - 1);
            BPM = 60 / m_AverageTimeBetweenBeats;

            m_NextBeat = Time.time + m_AverageTimeBetweenBeats;

           /// MasterSpeedController.Instance.OnSetBPM(BPM, true);
        }

        public void SetBPM(float bpm)
        {
            BPM = bpm;
            m_AverageTimeBetweenBeats = 60 / m_BPM;
            
            if (onSetBPM != null) onSetBPM(m_BPM);
        }

        public void ClearBPM()
        {
            m_NextBeat = Time.time + 99999999999;
            m_BPMTaps.Clear();
            //m_BPM=0;
            m_CurrentBeatIndex = 0;
            m_BarCount = 0;

            if (onSetBPM != null) onSetBPM(m_BPM);
        }
    }
}
