using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ShaderPropertyList : MonoBehaviour
{
    public Material _Mat;
    Shader _Shader;

    // Start is called before the first frame update
    void Start()
    {
        _Shader = _Mat.shader;


    }

    // Update is called once per frame
    void SetShader()
    {
        _Shader = _Mat.shader;
        int propertyCount = UnityEditor.ShaderUtil.GetPropertyCount(_Shader);
        string allProperties = string.Empty;
        for (int i = 0; i < propertyCount; i++)
        {
            UnityEditor.ShaderUtil.ShaderPropertyType type = UnityEditor.ShaderUtil.GetPropertyType(_Shader, i);
            string name = UnityEditor.ShaderUtil.GetPropertyName(_Shader, i);
            string valueStr = string.Empty;
            switch (type)
            {
                case UnityEditor.ShaderUtil.ShaderPropertyType.Color:
                    {
                        Color value = mat.GetColor(name);
                        valueStr = value.r.ToString() + IOUtils.VECTOR_SEPARATOR +
                                    value.g.ToString() + IOUtils.VECTOR_SEPARATOR +
                                    value.b.ToString() + IOUtils.VECTOR_SEPARATOR +
                                    value.a.ToString();
                    }
                    break;
                case UnityEditor.ShaderUtil.ShaderPropertyType.Vector:
                    {
                        Vector4 value = mat.GetVector(name);
                        valueStr = value.x.ToString() + IOUtils.VECTOR_SEPARATOR +
                                    value.y.ToString() + IOUtils.VECTOR_SEPARATOR +
                                    value.z.ToString() + IOUtils.VECTOR_SEPARATOR +
                                    value.w.ToString();
                    }
                    break;
                case UnityEditor.ShaderUtil.ShaderPropertyType.Float:
                    {
                        float value = mat.GetFloat(name);
                        valueStr = value.ToString();
                    }
                    break;
                case UnityEditor.ShaderUtil.ShaderPropertyType.Range:
                    {
                        float value = mat.GetFloat(name);
                        valueStr = value.ToString();
                    }
                    break;
                case UnityEditor.ShaderUtil.ShaderPropertyType.TexEnv:
                    {
                        Texture value = mat.GetTexture(name);
                        valueStr = AssetDatabase.GetAssetPath(value);
                        Vector2 offset = mat.GetTextureOffset(name);
                        Vector2 scale = mat.GetTextureScale(name);
                        valueStr += IOUtils.VECTOR_SEPARATOR + scale.x.ToString() +
                            IOUtils.VECTOR_SEPARATOR + scale.y.ToString() +
                            IOUtils.VECTOR_SEPARATOR + offset.x.ToString() +
                            IOUtils.VECTOR_SEPARATOR + offset.y.ToString();
                    }
                    break;
            }

            allProperties += name + IOUtils.FIELD_SEPARATOR + type + IOUtils.FIELD_SEPARATOR + valueStr;


        }
    }
