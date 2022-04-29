using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[RequireComponent (typeof (Camera))]
[ExecuteInEditMode]
public class PostEffects : MonoBehaviour
{

    public Shader curShader;
    private Material curMaterial;
    Material material
    {
        get
        {
            if (curMaterial == null){
                curMaterial = new Material(curShader);
                curMaterial.hideFlags = HideFlags.HideAndDontSave;
            }
            return curMaterial;
        }
    }
    // Start is called before the first frame update
    void Start()
    {
        curShader = Shader.Find("Hidden/PostEffects");  
        GetComponent<Camera>().allowHDR = true;
        if (!curShader && !curShader.isSupported){
            enabled = false;
            Debug.Log("not supported");
        }
        
        GetComponent<Camera>().depthTextureMode = DepthTextureMode.Depth;
    }

    // Update is called once per frame
    void Update()
    {
        if (!GetComponent<Camera>().enabled)
        return;
        
    }

    void OnRenderImage(RenderTexture sourceTexture, RenderTexture destTexture)
    {
        if (curShader != null)
        {
            Graphics.Blit(sourceTexture, destTexture, material, 1);
        }

    }

    void OnDisable(){
        if(curMaterial){
            DestroyImmediate(curMaterial);
        }
    }
}
