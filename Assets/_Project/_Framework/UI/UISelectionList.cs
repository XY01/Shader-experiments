using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class UISelectionList : MonoBehaviour
{
    public delegate void ItemSelected(int index);
    public event ItemSelected onItemSelected;

    Button[] _SelectionButtons;
    public RectTransform _ListParent;

    // Start is called before the first frame update
    public void Initialize(string[] selectionNames)
    {
        print("Opening selection list: " + selectionNames.Length);

        // Destroy old buttons
        if (_SelectionButtons != null)
        {
            foreach (Button b in _SelectionButtons)
                Destroy(b.gameObject);
        }
       
        // Create new buttons
        _SelectionButtons = new Button[selectionNames.Length];
        for (int i = 0; i < _SelectionButtons.Length; i++)
        {
            int index = i;
            _SelectionButtons[i] = SRResources.UI.Button.Instantiate(_ListParent).GetComponent<Button>();
            _SelectionButtons[i].GetComponentInChildren<Text>().text = selectionNames[i];
            _SelectionButtons[i].onClick.AddListener(() => SelectItem(index));
        }

        gameObject.SetActive(true);
    }

    void SelectItem(int index)
    {
        onItemSelected?.Invoke(index);
        gameObject.SetActive(false);
    }   
}
