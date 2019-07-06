using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SplashObjectLayerGUI : MonoBehaviour
{
    public RectTransform _SplashObjectGUIParent;
    SplashObjectLayer _Layer;

    SplashObject_GUI _SOGUI;

    public void Init(SplashObjectLayer layer)
    {
        _Layer = layer;
    }

    public void OpenObjectSelection()
    {
        SplashMixer.Instance.SelectLayerAndOpenSelection(_Layer);
    }

    public void DeactivateObject()
    {
        _Layer.DeactivateObject();
    }

    public void DestroyGUI()
    {
        // Deacctivate current SO
        if (_SOGUI != null)
        {
            Destroy(_SOGUI.gameObject);
        }
    }

    public void SetActiveObject(SplashObjectBase so)
    {
        DestroyGUI();

         // Create new GUI
         _SOGUI = SplashMixer_GUIManager.Instance.CreateSplashObjectGUI(so, _SplashObjectGUIParent);
    }
}
