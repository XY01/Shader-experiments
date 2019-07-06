using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class ButtonData
{
    public string _Name;
    public int _ReturnIndex;
    public bool _Interacable = true;
    public Texture _Thumbnail;   

    public ButtonData(string name, int returnIndex, bool interactable = true, Texture thumb = null)
    {
        _Name = name;
        _ReturnIndex = returnIndex;
        _Interacable = interactable;
        _Thumbnail = thumb;
    }
}

public class UISelectionList : MonoBehaviour
{
    public delegate void ItemSelected(int index);
    public event ItemSelected onItemSelected;

    Button[] _SelectionButtons;
    public RectTransform _ListParent;

    // Start is called before the first frame update
    public void Initialize(ButtonData[] buttonData)
    {
        print("Opening selection list: " + buttonData.Length);

        // Destroy old buttons
        if (_SelectionButtons != null)
        {
            foreach (Button b in _SelectionButtons)
                Destroy(b.gameObject);
        }
       
        // Create new buttons
        _SelectionButtons = new Button[buttonData.Length];
        for (int i = 0; i < _SelectionButtons.Length; i++)
        {
            int index = buttonData[i]._ReturnIndex;
           
            _SelectionButtons[i] = SRResources.UI.Button.Instantiate(_ListParent).GetComponent<Button>();
            _SelectionButtons[i].GetComponentInChildren<Text>().text = buttonData[i]._Name;
            _SelectionButtons[i].onClick.AddListener(() => SelectItem(index) );
            _SelectionButtons[i].interactable = buttonData[i]._Interacable;

            if (buttonData[i]._Thumbnail != null)
                _SelectionButtons[i].GetComponentInChildren<RawImage>().texture = buttonData[i]._Thumbnail;
        }

        gameObject.SetActive(true);
    }
    
    void SelectItem(int index)
    {
       
        onItemSelected?.Invoke(index);
        gameObject.SetActive(false);
    }   
}
