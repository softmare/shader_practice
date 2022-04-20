Shader "Custom/DiffuseShader"
{
    Properties
    {
        _Color ("Choice your favorite.", COLOR) = (1,0,0,1)
        _DiffuseTex ("Texture", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "LightMode" = "ForwardBase" } // 이 물체의 첫번째 라이트 패스로 사용
        // Tags { "LightMode" = "ForwardAdd" } // 다른 빛이 영향을 주기 바랄 때 이 태그를 추가한다.
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"
            #include "UnityLightingCommon.cginc"

            float4 _Color;
            sampler2D _DiffuseTex;
            float4 _DiffuseTex_ST;

            struct appdata
            {
                float4 vertex : POSITION;
                float4 color : COLOR;
                float3 normal : NORMAL;
                float2 uv : TEXCOORD0; 
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
                float3 worldNormal : TEXCOORD1;
                float2 uv : TEXCOORD0;
            };


            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                float3 worldNormal = UnityObjectToWorldNormal(v.normal);
                o.worldNormal = worldNormal;
                o.uv = TRANSFORM_TEX(v.uv, _DiffuseTex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float3 normalDirection = normalize(i.worldNormal);

                float4 tex = tex2D(_DiffuseTex, i.uv);

                float nl = max(0.0, dot(normalDirection, _WorldSpaceLightPos0.xyz));
                float4 diffuseTerm = nl * _Color * tex * _LightColor0;

                return diffuseTerm;
            }

            ENDCG
        }
    }
}
