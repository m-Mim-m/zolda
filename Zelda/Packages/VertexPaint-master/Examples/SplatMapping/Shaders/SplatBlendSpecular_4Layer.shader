//
// If your looking for example code to make your own shaders, I suggest looking at the included examples. 
// This shader uses lots of compiler/C Macro abuse which is going to make it much harder to understand
// than the included examples. 

Shader "VertexPainter/SplatBlendSpecular_4Layer" 
{
   Properties {
      _Tex1 ("Albedo + Height", 2D) = "white" {}
      _Tint1 ("Tint", Color) = (1, 1, 1, 1)
      [NoScaleOffset][Normal]_Normal1("Normal", 2D) = "bump" {}
      _Glossiness1 ("Smoothness", Range(0,1)) = 0.5
      _SpecColor1("Specular Color", Color) = (0.2, 0.2, 0.2, 0.2)
      [NoScaleOffset]_SpecGlossMap1("Specular/Gloss Map", 2D) = "black" {}
      _Emissive1  ("Emissive", 2D) = "black" {}
      _EmissiveMult1("Emissive Multiplier", Float) = 1
      _Parallax1 ("Parallax Height", Range (0.005, 0.08)) = 0.02
      _TexScale1 ("Texture Scale", Float) = 1
      
      
      _Tex2("Albedo + Height", 2D) = "white" {}
      _Tint2 ("Tint", Color) = (1, 1, 1, 1)
      [NoScaleOffset][Normal]_Normal2("Normal", 2D) = "bump" {}
      _Glossiness2 ("Smoothness", Range(0,1)) = 0.5
      _SpecColor2("Specular Color", Color) = (0.2, 0.2, 0.2, 0.2)
      [NoScaleOffset]_SpecGlossMap2("Specular/Gloss Map", 2D) = "black" {}
      _Emissive2  ("Emissive", 2D) = "black" {}
      _EmissiveMult2("Emissive Multiplier", Float) = 1
      _Parallax2 ("Parallax Height", Range (0.005, 0.08)) = 0.02
      _TexScale2 ("Texture Scale", Float) = 1
      _Contrast2("Contrast", Range(0,0.99)) = 0.5
      
      _Tex3("Albedo + Height", 2D) = "white" {}
      _Tint3 ("Tint", Color) = (1, 1, 1, 1)
      [NoScaleOffset][Normal]_Normal3("Normal", 2D) = "bump" {}
      _Glossiness3 ("Smoothness", Range(0,1)) = 0.5
      _SpecColor3("Specular Color", Color) = (0.2, 0.2, 0.2, 0.2)
      [NoScaleOffset]_SpecGlossMap3("Specular/Gloss Map", 2D) = "black" {}
      _Emissive3  ("Emissive", 2D) = "black" {}
      _EmissiveMult3("Emissive Multiplier", Float) = 1
      _Parallax3 ("Parallax Height", Range (0.005, 0.08)) = 0.02 
      _TexScale3 ("Texture Scale", Float) = 1
      _Contrast3("Contrast", Range(0,0.99)) = 0.5
      
      _Tex4("Albedo + Height", 2D) = "white" {}
      _Tint4 ("Tint", Color) = (1, 1, 1, 1)
      [NoScaleOffset][Normal]_Normal4("Normal", 2D) = "bump" {}
      _Glossiness4 ("Smoothness", Range(0,1)) = 0.5
      _SpecColor4("Specular Color", Color) = (0.2, 0.2, 0.2, 0.2)
      [NoScaleOffset]_SpecGlossMap4("Specular/Gloss Map", 2D) = "black" {}
      _Emissive4  ("Emissive", 2D) = "black" {}
      _EmissiveMult4("Emissive Multiplier", Float) = 1
      _Parallax4 ("Parallax Height", Range (0.005, 0.08)) = 0.02 
      _TexScale4 ("Texture Scale", Float) = 1
      _Contrast4("Contrast", Range(0,0.99)) = 0.5
      
      
      _FlowSpeed ("Flow Speed", Float) = 0
      _FlowIntensity ("Flow Intensity", Float) = 1
      _FlowAlpha ("Flow Alpha", Range(0, 1)) = 1
      _FlowRefraction("Flow Refraction", Range(0, 0.3)) = 0.04

      _DistBlendMin("Distance Blend Begin", Float) = 0
      _DistBlendMax("Distance Blend Max", Float) = 100
      _DistUVScale1("Distance UV Scale", Float) = 0.5
      _DistUVScale2("Distance UV Scale", Float) = 0.5
      _DistUVScale3("Distance UV Scale", Float) = 0.5
      _DistUVScale4("Distance UV Scale", Float) = 0.5
      
   }
   SubShader {
      Tags { "RenderType"="Opaque" }
      LOD 200
      
      CGPROGRAM
      
      // these are done with shader compile options - but honestly, on most modern hardware,
      // doing a branch would be fine since the branch would always go the same direction on
      // each pixel. If you are running low on keywords, that could be a viable option for you.
      #pragma surface surf StandardSpecular vertex:vert fullforwardshadows
      #pragma shader_feature __ _PARALLAXMAP
      #pragma shader_feature __ _NORMALMAP
      #pragma shader_feature __ _SPECGLOSSMAP
      #pragma shader_feature __ _EMISSION
      // flow map keywords. 
      #pragma shader_feature __ _FLOW1 _FLOW2 _FLOW3 _FLOW4 
      #pragma shader_feature __ _FLOWDRIFT 
      #pragma shader_feature __ _FLOWREFRACTION
      #pragma shader_feature __ _DISTBLEND

      #include "SplatBlend_Shared.cginc"
      
      void vert (inout appdata_full v, out Input o) 
      {
          SharedVert(v,o);
      }
      
      void surf (Input IN, inout SurfaceOutputStandardSpecular o) 
      {
         
         //////////////////
         // Four Layer
         //////////////////
         COMPUTEDISTBLEND

         float2 uv1 = IN.uv_Tex1 * _TexScale1;
         float2 uv2 = IN.uv_Tex1 * _TexScale2;
         float2 uv3 = IN.uv_Tex1 * _TexScale3;
         float2 uv4 = IN.uv_Tex1 * _TexScale4;
         INIT_FLOW
         #if _FLOWDRIFT || !_PARALLAXMAP
         fixed4 c1 = FETCH_TEX1(_Tex1, _Tex1, uv1);
         fixed4 c2 = FETCH_TEX2(_Tex2, _Tex1, uv2);
         fixed4 c3 = FETCH_TEX3(_Tex3, _Tex1, uv3);
         fixed4 c4 = FETCH_TEX4(_Tex4, _Tex1, uv4);
         #elif _DISTBLEND
         fixed4 c1 = lerp(UNITY_SAMPLE_TEX2D_SAMPLER(_Tex1, _Tex1, uv1), UNITY_SAMPLE_TEX2D_SAMPLER(_Tex1, _Tex1, uv1*_DistUVScale1), dist);
         fixed4 c2 = lerp(UNITY_SAMPLE_TEX2D_SAMPLER(_Tex2, _Tex1, uv2), UNITY_SAMPLE_TEX2D_SAMPLER(_Tex2, _Tex1, uv2*_DistUVScale2), dist);
         fixed4 c3 = lerp(UNITY_SAMPLE_TEX2D_SAMPLER(_Tex3, _Tex1, uv3), UNITY_SAMPLE_TEX2D_SAMPLER(_Tex3, _Tex1, uv3*_DistUVScale3), dist);
         fixed4 c4 = lerp(UNITY_SAMPLE_TEX2D_SAMPLER(_Tex4, _Tex1, uv4), UNITY_SAMPLE_TEX2D_SAMPLER(_Tex4, _Tex1, uv4*_DistUVScale4), dist);
         #else
         fixed4 c1 = UNITY_SAMPLE_TEX2D_SAMPLER(_Tex1, _Tex1, uv1);
         fixed4 c2 = UNITY_SAMPLE_TEX2D_SAMPLER(_Tex2, _Tex1, uv2);
         fixed4 c3 = UNITY_SAMPLE_TEX2D_SAMPLER(_Tex3, _Tex1, uv3);
         fixed4 c4 = UNITY_SAMPLE_TEX2D_SAMPLER(_Tex4, _Tex1, uv4);
         #endif
         half b1 = HeightBlend(c1.a, c2.a, IN.color.r, _Contrast2);
         fixed h1 = lerp(c1.a, c2.a, b1);
         half b2 = HeightBlend(h1, c3.a, IN.color.g, _Contrast3);
         fixed h2 = lerp(h1, c2.a, b1);
         half b3 = HeightBlend(h2, c4.a, IN.color.b, _Contrast4);

         #if _FLOW2
            b1 *= _FlowAlpha;
            #if _FLOWREFRACTION && _NORMALMAP
               half4 rn = FETCH_TEX2 (_Normal2, _Normal1, uv2) - 0.5;
               uv1 += rn.xy * b1 * _FlowRefraction;
               #if !_PARALLAXMAP 
                  c1 = FETCH_TEX1(_Tex1, _Tex1, uv1);
               #endif
            #endif
         #endif
         #if _FLOW3
            b2 *= _FlowAlpha;
            #if _FLOWREFRACTION && _NORMALMAP
               half4 rn = FETCH_TEX3 (_Normal3, _Normal1, uv3) - 0.5;
               uv1 += rn.xy * b1 * _FlowRefraction;
               uv2 += rn.xy * b2 * _FlowRefraction;
               #if !_PARALLAXMAP 
                  c1 = FETCH_TEX1(_Tex1, _Tex1, uv1);
                  c2 = FETCH_TEX2(_Tex2, _Tex1, uv2);
               #endif
            #endif
         #endif
         #if _FLOW4
            b3 *= _FlowAlpha;
            #if _FLOWREFRACTION && _NORMALMAP
               half4 rn = FETCH_TEX4 (_Normal4, _Normal1, uv4) - 0.5;
               uv1 += rn.xy * b1 * _FlowRefraction;
               uv2 += rn.xy * b2 * _FlowRefraction;
               uv3 += rn.xy * b3 * _FlowRefraction;
               #if !_PARALLAXMAP 
                  c1 = FETCH_TEX1(_Tex1, _Tex1, uv1);
                  c2 = FETCH_TEX2(_Tex2, _Tex1, uv2);
                  c3 = FETCH_TEX3(_Tex3, _Tex1, uv3);
               #endif
            #endif
         #endif



         #if _PARALLAXMAP
         float parallax = lerp(lerp(lerp(_Parallax1, _Parallax2, b1), _Parallax3, b2), _Parallax4, b3);
         float2 offset = ParallaxOffset (lerp(lerp(lerp(c1.a, c2.a, b1),c3.a, b2), c4.a, b3), parallax, IN.viewDir);
         uv1 += offset;
         uv2 += offset;
         uv3 += offset;
         uv4 += offset;
         c1 = FETCH_TEX1(_Tex1, _Tex1, uv1);
         c2 = FETCH_TEX2(_Tex2, _Tex1, uv2);
         c3 = FETCH_TEX3(_Tex3, _Tex1, uv3);
         c4 = FETCH_TEX4(_Tex4, _Tex1, uv4);
         #if (_FLOW1 || _FLOW2 || _FLOW3 || _FLOW4 || _FLOW5)
         fuv1 += offset;
         fuv2 += offset;
         #endif
         #endif
         
         
         fixed4 c = lerp(lerp(lerp(c1 * _Tint1, c2 * _Tint2, b1), c3 * _Tint3, b2), c4 * _Tint4, b3);


         #if _SPECGLOSSMAP
         fixed4 g1 = FETCH_TEX1(_SpecGlossMap1, _SpecGlossMap1, uv1);
         fixed4 g2 = FETCH_TEX2(_SpecGlossMap2, _SpecGlossMap1, uv2);
         fixed4 g3 = FETCH_TEX3(_SpecGlossMap3, _SpecGlossMap1, uv3);
         fixed4 g4 = FETCH_TEX4(_SpecGlossMap4, _SpecGlossMap1, uv4);
         fixed4 gf = lerp(lerp(lerp(g1, g2, b1), g3, b2), g4, b3);
         o.Smoothness = gf.a;
         o.Specular = gf.rgb;
         #else
         o.Smoothness = lerp(lerp(lerp(_Glossiness1, _Glossiness2, b1), _Glossiness3, b2), _Glossiness4, b3);
         o.Specular = lerp(lerp(lerp(_SpecColor1, _SpecColor2, b1), _SpecColor3, b2), _SpecColor4, b3).rgb;
         #endif

         
         #if _EMISSION
         fixed4 e1 = FETCH_TEX1(_Emissive1, _Emissive1, uv1);
         fixed4 e2 = FETCH_TEX2(_Emissive2, _Emissive1, uv2);
         fixed4 e3 = FETCH_TEX3(_Emissive3, _Emissive1, uv3);
         fixed4 e4 = FETCH_TEX4(_Emissive4, _Emissive1, uv4);
         o.Emission = lerp(lerp(lerp(e1.rgb * _EmissiveMult1, 
                                     e2.rgb * _EmissiveMult2, b1), 
                                     e3.rgb * _EmissiveMult3, b2),
                                     e4.rgb * _EmissiveMult4, b3);
         #endif
         
         
         #if _NORMALMAP
         half4 n1 =  (FETCH_TEX1 (_Normal1, _Normal1, uv1));
         half4 n2 =  (FETCH_TEX2 (_Normal2, _Normal1, uv2));
         half4 n3 =  (FETCH_TEX3 (_Normal3, _Normal1, uv3));
         half4 n4 =  (FETCH_TEX4 (_Normal4, _Normal1, uv4));
         o.Normal = UnpackNormal(lerp(lerp(lerp(n1, n2, b1), n3, b2), n4, b3));
         #endif
         
         o.Albedo = c.rgb;
         
      }
      ENDCG
   } 
   CustomEditor "SplatMapShaderGUI"
   FallBack "Diffuse"
}