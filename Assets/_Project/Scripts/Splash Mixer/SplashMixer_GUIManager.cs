using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class SplashMixer_GUIManager : MonoBehaviour
{
    public static SplashMixer_GUIManager Instance;
    public RectTransform _LayerParent;
    public UISelectionList _SelectionList;
   

    private void Awake()
    {
        Instance = this;
        _SelectionList.onItemSelected += SelectionList_onItemSelected;
    }

   

    public SplashObject_GUI CreateSplashObjectGUI(SplashObjectBase so)
    {
        SplashObject_GUI sOGUI = SRResources.Splash_UI.Panel_Splash_Object_GUI.Instantiate(_LayerParent).GetComponent<SplashObject_GUI>();
        sOGUI.Initialize(so);

        return sOGUI;
    }

    public void OpenObjectSelection()
    {
        _SelectionList.Initialize(SplashMixer.Instance._AllObjectNames);
    }

    private void SelectionList_onItemSelected(int index)
    {
        SplashMixer.Instance.ActiveLayer.SetActiveObject(SplashMixer.Instance._AllSplashObjects[index]);
    }
}
