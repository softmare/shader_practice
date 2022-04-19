using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SetVertexColor : MonoBehaviour
{
    // Start is called before the first frame update
    void Start()
    {
        Mesh mesh = GetComponent<MeshFilter>().mesh;
        Vector3[] vertices = mesh.vertices;

        Color[] colors = new Color[vertices.Length];        

        for (int i=0; i < vertices.Length; i++)
        {
            colors[i] = Color.Lerp(Color.red, Color.green, vertices[i].y);
            Debug.Log(colors[i]);
        }

        mesh.colors = colors;
    }

    // Update is called once per frame
    void Update()
    {
        
    }
}
