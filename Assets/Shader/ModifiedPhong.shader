Shader "Custom/ModifiedPhong"
{
    Properties
    {
        _Color ("Color", Color) = (1, 1, 1, 1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _SpecColor ("Specular Material Color", Color) = (1, 1, 1, 1)
        _Shininess ("Shininess", Range (0.03, 128)) = 0.078125
    }
    SubShader
    {
        Tags { "RenderType" = "Opaque"}
        LOD 200

        CGPROGRAM

        #pragma surface surf PhongModified fullforwardshadows
        #pragma target 3.0

        sampler2D _MainTex;
        float _Shininess;
        fixed4 _Color;


        struct Input {
            float2 uv_MainTex;
        };

        UNITY_INSTANCING_BUFFER_START(Props)
        UNITY_INSTANCING_BUFFER_END(Props)

        void surf (Input IN, inout SurfaceOutput o){
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
            o.Albedo = c.rgb;
            o.Alpha = 1.0f;
        }

        inline fixed4 LightingPhongModified (SurfaceOutput s, half3 viewDir, UnityGI gi)
        {
            const float PI = 3.14159265358979323846;
            UnityLight light = gi.light;

            float nl = max(0.0f, dot(s.Normal, light.dir));
            float3 diffuseTerm = nl * s.Albedo.rgb * light.color;
            float3 reflectionDirection = reflect(-light.dir, s.Normal);
            float3 specularDot = max(0.0, dot(viewDir, reflectionDirection));
            float norm = (_Shininess + 2) / (2 * PI);
            float3 specular = norm * pow(specularDot, _Shininess);
            float3 specularTerm = specular * _SpecColor.rgb * light.color.rgb;
            float3 finalColor = diffuseTerm.rgb + specularTerm;

            fixed4 c;
            c.rgb = finalColor;
            c.a = s.Alpha;

            #ifdef UNIYT_LIGHT_FUNCTION_APPLY_INDIRECT
                c.rgb += s.Albedo * gi.indirect.diffuse;
            #endif

            return c;
        }

        inline void LightingPhongModified_GI (SurfaceOutput s, UnityGIInput data, inout UnityGI gi)
        {
            gi = UnityGlobalIllumination(data, 1.0, s.Normal);
        }
        ENDCG
    }
    FallBack "Diffuse"
}