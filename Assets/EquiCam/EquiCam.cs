using UnityEngine;
using Klak.Ndi;

/// <summary>
///  Modified Equi cam to push out to NDI
/// </summary>
namespace BodhiDonselaar
{
	[RequireComponent(typeof(Camera))]
	public class EquiCam : MonoBehaviour
	{
		private static Material _EquiMat;
		public Size RenderResolution = Size.Default;
		private RenderTexture _CubemapRT;
		private Camera _Cam;
		private GameObject _ChildGO;

        public NdiSender _NDISender;
        public Material _ProjectionMat;
        
		public enum Size
		{
			High = 2048,
			Default = 1024,
			Low = 512,
			Minimum = 256
		}
		void OnEnable()
		{
			if (_EquiMat == null) _EquiMat = new Material(Resources.Load<Shader>("EquiCam"));
			_ChildGO = new GameObject();
			_ChildGO.hideFlags = HideFlags.HideInHierarchy;
			_ChildGO.transform.SetParent(transform);
			_ChildGO.transform.localPosition = Vector3.zero;
			_ChildGO.transform.localEulerAngles = Vector3.zero;
			_Cam = _ChildGO.AddComponent<Camera>();
			_Cam.CopyFrom(GetComponent<Camera>());
			_ChildGO.SetActive(false);
			New();
            
            if (_NDISender != null)
            {
                _NDISender._Source = NdiSender.Source.RenderTexture;
                _NDISender.sourceTexture = _CubemapRT;
            }

        }
		void OnDisable()
		{
			if (_ChildGO != null) DestroyImmediate(_ChildGO);
			if (_CubemapRT != null)
			{
				_CubemapRT.Release();
				DestroyImmediate(_CubemapRT);
			}
		}

		void OnRenderImage(RenderTexture src, RenderTexture des)
		{
			if (_CubemapRT.width != (int)RenderResolution) New();
			_Cam.RenderToCubemap(_CubemapRT);
			Shader.SetGlobalFloat("FORWARD", _Cam.transform.eulerAngles.y * 0.01745f);
			Graphics.Blit(_CubemapRT, des, _EquiMat);

            // Set the NDI source texture to the cubemap each time it renders
            _NDISender.sourceTexture = _CubemapRT;
        }

		private void New()
		{
			_Cam.targetTexture = null;
			if (_CubemapRT != null)
			{
				_CubemapRT.Release();
				DestroyImmediate(_CubemapRT);
			}
			_CubemapRT = new RenderTexture((int)RenderResolution, (int)RenderResolution, 0, RenderTextureFormat.ARGB32);
			_CubemapRT.antiAliasing = 1;
			_CubemapRT.filterMode = FilterMode.Bilinear;
			_CubemapRT.anisoLevel = 0;
			_CubemapRT.dimension = UnityEngine.Rendering.TextureDimension.Cube;
			_CubemapRT.autoGenerateMips = false;
			_CubemapRT.useMipMap = false;
			_Cam.targetTexture = _CubemapRT;
		}
	}
}