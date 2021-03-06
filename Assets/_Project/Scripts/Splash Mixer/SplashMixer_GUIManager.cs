﻿using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class SplashMixer_GUIManager : MonoBehaviour
{
    public static SplashMixer_GUIManager Instance;
    
   // public RectTransform _LayerParent;
    public UISelectionList _SelectionList;

    public RectTransform _LightingGUIParent;
    public CVControllerBase _LightingController;

    private void Awake()
    {
        Instance = this;
        _SelectionList.onItemSelected += SelectionList_onItemSelected;


        // LIGHTING TODO Move
        _LightingController.Init("/lighting");
        CVControllerGUI newCtrlrGUI = SRResources.Panel_CV_Controllers.Instantiate(_LightingGUIParent).GetComponent<CVControllerGUI>();
        //newCtrlrGUI.GetComponent<RectTransform>().SetSizeWithCurrentAnchors(RectTransform.Axis.Horizontal, 300);
        newCtrlrGUI.Initialize(_LightingController);
    }

    ButtonData[] GetSplashObjectButtonData()
    {
        ButtonData[] splashObjectButtonData = new ButtonData[SplashMixer.Instance._AllSplashObjects.Length];

        for (int i = 0; i < splashObjectButtonData.Length; i++)
        {
            int index = i;

            splashObjectButtonData[i] = new ButtonData
            (
                SplashMixer.Instance._AllSplashObjects[i].name,
                index,
                !SplashMixer.Instance._AllSplashObjects[i].gameObject.activeSelf
            );
        }

        return splashObjectButtonData;
    }

    public SplashObject_GUI CreateSplashObjectGUI(SplashObjectBase so, RectTransform parent)
    {
        SplashObject_GUI sOGUI = SRResources.Splash_UI.Panel_Splash_Object_GUI.Instantiate(parent).GetComponent<SplashObject_GUI>();
        sOGUI.Initialize(so);

        return sOGUI;
    }

    public void OpenObjectSelection()
    {
        _SelectionList.Initialize(GetSplashObjectButtonData());
    }

    private void SelectionList_onItemSelected(int index)
    {
        SplashMixer.Instance.ActiveLayer.SetActiveObject(SplashMixer.Instance._AllSplashObjects[index]);
    }
}
