using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Movement : MonoBehaviour
{
    // Start is called before the first frame update
    public float speed = 0.0000000001f;
    void Start()
    {
        
    }

    // Update is called once per frame
    
    void Update()
    {
        if (Input.GetKey(KeyCode.S))
        {
            transform.Translate(0, 0, -1);
        }
        if (Input.GetKey(KeyCode.A))
        {
            transform.Translate(-1, 0, 0);
        }
        if (Input.GetKey(KeyCode.W))
        {
            transform.Translate(0, 0, 1);
        }
        if (Input.GetKey(KeyCode.D))
        {
            transform.Translate(1, 0, 0);
        }
    }
}