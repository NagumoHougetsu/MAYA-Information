float4x4 gWVP   :   WorldViewProjection;
float4x4 gWIT   :   WorldInverseTranspose;
float4x4 gW     :   World;
float4x4 gVP    :   ViewProjection;
float4x4 gVI    :   ViewInverse;

//【ライト情報】
//ライト情報取得1
float3 gLight0Dir   :   DIRECTION <
    string Object = "Light 0";
    int UIOrder = 0;
>;
//ライト情報取得2
float3 gLight1Dir   :   DIRECTION <
    string Object = "Light 1";
    int UIOrder = 1;
>;
//ShadowMap情報
Texture2D gLight0ShadowMap  :   ShadowMap <
    string Object = "Light 0";
    int UIOrder = 2;
>;
//射影（ライトビュー）変換行列
float4x4 gMatLight  :   shadowMapMatrix <
    string Object = "Light 0";
    int UIOrder = 4;
>;

//ShadowMapバイアス
float gLight0ShadowMapBias  :   shadowMapBias <
    string Object = "Light 0";
    int UIOrder = 5;
>;

//【カラー情報】
//【GUI】ベースカラーテクスチャ使用の有無
uniform bool gUseBaseColorTexture <
    string UIGroup = "Color";
    int UIOrder = 100;
    string UIName = "Use BaseColor Texture";
> = false;
//【GUI】ベースカラー用のカラーピッカー
uniform float3 gBaseColor <
    string UIGroup = "Color";
    int UIOrder = 101;
    string UIName = "Base Color";
    string UIWidget = "ColorPicker";
> = {1.0, 1.0, 1.0};
//【GUI】ベースカラーテクスチャ読み込み
uniform Texture2D gBaseColorTexture <
    string UIGroup = "Color";
    int UIOrder = 102;
    string UIName = "BaseColorTexture";
    string UIWidget = "FilePicker";
    string ResourceType = "2D";
>;
//【GUI】シャドウカラーテクスチャ使用の有無
uniform bool gUseShadowColorTexture <
    string UIGroup = "Color";
    int UIOrder = 103; 
    string UIName = "Use ShadowColor Texture";
> = false;
//【GUI】シャドウカラー用のカラーピッカー
uniform float3 gShadowColor <
    string UIGroup = "Color";
    int UIOrder = 104;
    string UIName = "Shadow Color";
    string UIWidget = "ColorPicker";
> = {0.0, 0.0, 0.0};
//【GUI】シャドウカラーテクスチャの読み込み
uniform Texture2D gShadowColorTexture <
    string UIGroup = "Color";
    int UIOrder = 105;
    string UIName = "ShadowColor Texture";
    string UIWidget = "FilePicker";
    string ResourceType = "2D";
>;

//【シェーディング情報】
//【GUI】トゥーンのしきい値
uniform float gToonThreshold <
    string UIGroup = "Toon";
    int UIOrder = 201;
    string UIName = "Toon Threshold";
    float UIMin = -1.0;
    float UIMax = 1.0;
> = 0.0;
//【GUI】トゥーンのぼかし具合
uniform float gToonFeather <
    string UIGroup = "Toon";
    int UIOrder = 202;
    string UIName = "Toon Feather";
    float UIMin = 0.0;
    float UIMax = 1.0;
> = 0.0;

//【アウトライン情報】
//アウトラインを使うかどうか
uniform bool gUseOutline <  
    string UIGroup = "Outline";
    int UIOrder = 300;
    string UIName = "Use Outline";
> = false;
//色トレスを使うかどうか
uniform bool gUseColorTresses <
    string UIGroup = "Outline";
    int UIOrder = 301;
    string UIName = "Use ColorTresses";
> = false;
//アウトラインカラーテクスチャを使うかどうか
uniform bool gUseOutlineColorTexture <
    string UIGroup = "Outline";
    int UIOrder = 302;
    string UIName = "Use Outline Color Texture";
> = false;
//アウトラインカラーテクスチャ読み込み
uniform Texture2D gOutlineColorTexture <
    string UIGroup = "Outline";
    int UIOrder = 303;
    string UIName = "Outline Color Texture";
    string UIWidget = "FilePicker";
    string ResourceType = "2D";
>;
//アウトラインカラー
uniform float3 gOutlineColor <
    string UIGroup = "Outline";
    int UIOrder = 304;
    string UIName = "Outline Color";
    string UIWidget = "ColorPicker";
> = {0.0f, 0.0f, 0.0f};
//アウトラインの幅
uniform float gOutlineWidth <
    string UIGroup = "Outline";
    int UIOrder = 305;
    string UIName = "Outline Width";
    float UIMin = 0.0f;
    float UIMax = 3.0f;
> = 1.0f;
//アウトラインマスクテクスチャを使うかどうか
uniform bool gUseOutlineMask <
    string UIGroup = "Outline";
    int UIOrder = 306;
    string UIName = "Use Outline Mask";
> = false;
//アウトラインマスクの参照先変更
uniform int gOutlineMaskSource <
    string UIGroup = "Outline";
    int UIOrder = 307;
    string UIName = "Outline Mask Source";
    string UIFieldNames = "Mask Texture:Color Alpha";
    float UIMin = 0;
    float UIMax = 1;
    float UIStep = 1;
> = 0;
//アウトラインマスクテクスチャ読み込み
uniform Texture2D gOutlineMaskTexture <
    string UIGroup = "Outline";
    int UIOrder = 308;
    string UIName = "Outline Mask Texture";
    string UIWidget = "FilePicker";
    string ResourceType = "2D";
>;
//アウトラインのライト方向による太さ調整
uniform bool gUseLightDirWidth <
    string UIGroup = "Outline";
    int UIOrder = 309;
    string UIName = "LightDir Mask";
> = false;
//アウトラインのライト方向による太さ調整の強度
uniform float gLightDirWidthIntensity <
    string UIGroup = "Outline";
    int UIOrder = 310;
    string UIName = "Mask Intensity";
    float UIMin = 0.0f;
    float UIMax = 1.0f;
> = 0.0f;
//アウトラインの距離に応じた太さ調整
uniform bool gUseDistanceWidth <
    string UIGroup = "Outline";
    int UIOrder = 311;
    string UIName = "Distance Width";
> = false;
//変化率の調整
uniform float gScalingFactor <
    string UIGroup = "Outline";
    int UIOrder = 312;
    string UIName = "Scaling Factor";
    float UIMin = 0.0f;
    float UIMax = 1.0f;
> = 1.0f;

//【リムライト情報】
//リムライトを使用するかどうか
uniform bool gUseRim <
    string UIGroup = "Rimlight";
    int UIOrder = 400;
    string UIName = "Use Rim";
> = false;
//リムライトカラーテクスチャを使うかどうか
uniform bool gUseRimColorTexture<
    string UIGroup = "Rimlight";
    int UIOrder = 401;
    string UIName = "Use Rim ColorTexture";
> = false;
//リムライトのカラーピッカー
uniform float3 gRimColor<
    string UIGroup = "Rimlight";
    int UIOrder = 402;
    string UIName = "Rim Color"; 
    string UIWidget = "ColorPicker";
> = {1.0, 1.0, 1.0};
//リムライトのカラーテクスチャ読み込み
uniform Texture2D gRimColorTexture<
    string UIGroup = "Rimlight";
    int UIOrder = 403;
    string UIName = "Rim Color Texture";
    string UIWidget = "FilePicker";
    string ResourceType = "2D";
>;
//リムライトの強度
uniform float gRimLevel<
    string UIGroup = "Rimlight";
    int UIOrder = 404;
    string UIName = "Rim Level";
    float UIMin = 0.0;
    float UIMax = 1.0;
> = 1.0;
//リムライトの範囲
uniform float gRimArea<
    string UIGroup = "Rimlight";
    int UIOrder = 405;
    string UIName = "Rim Area";
    float UIMin = 0.0;
    float UIMax = 1.0;
> = 0.5;
//リムライトのぼかし
uniform float gRimFeather<
    string UIGroup = "Rimlight";
    int UIOrder = 406;
    string UIName = "Rim Feather";
    float UIMin = 0.0;
    float UIMax = 1.0;
> = 0.0;
//リムライトのブレンド方法
uniform int gRimBlendMode <
    string UIGroup = "Rimlight";
    int UIOrder = 407;
    string UIName = "Rim Blend Mode";
    string UIFieldNames = "Screen:Add:Dodge color";
    int UIMin = 0;
    int UIMax = 2;
> = 0;
//リムライトマスクを使うかどうか
uniform bool gUseRimMask <
    string UIGroup = "Rimlight";
    int UIOrder = 408;
    string UIName = "Use Rim Mask";
> = false;
//リムライトマスクの読み込み
uniform Texture2D gRimMask<
    string UIGroup = "Rimlight";
    int UIOrder = 409;
    string UIName = "Rim Mask";
    string UIWidget = "FilePicker";
    string ResourceType = "2D";
>;
//リムライトマスクのライト方向制御
uniform bool gUseLightDirMask <
    string UIGroup = "Rimlight";
    int UIOrder = 410;
    string UIName = "Use LightDir Mask";
> = false;
//リムライトのライト方向制御の強度
uniform float gLightDirMaskIntensity <
    string UIGroup = "Rimlight";
    int UIOrder = 411;
    string UIName = "Mask Intensity";
    float UIMin = 0.0f;
    float UIMax = 1.0f;
> = 0.0f;

//【ノーマルマップ情報】
//ノーマルマップを使用するかどうか
uniform bool gUseNormalMap <
    string UIGroup = "NormalMap";
    int UIOrder = 500;
    string UIName = "Use NormalMap";
> = false;
//ノーマルマップの読み込み
uniform Texture2D gNormalMap <
    string UIGroup = "NormalMap";
    int UIOrder = 501;
    string UIName = "NormalMap";
    string UIWidget = "FilePicker";
    string ResourceType = "2D";
>;
//ノーマル強度
uniform float gNormalIntensity <
    string UIGroup = "NormalMap";
    int UIOrder = 502;
    string UIName = "Normal Intensity";
    float UIMin = 0.0f;
    float UIMax = 5.0f;
> = 1.0f;

//【セルフシャドウ情報】
//セルフシャドウ関連
uniform bool gUseCastShadow <
    string UIGroup = "CastShadow";
    int UIOrder = 500;
    string UIName = "Use Cast Shadow";
> = false;
//メソッド選択
uniform int gShadowMethod <
    string UIGroup = "CastShadow";
    int UIOrder = 501;
    string UIName = "Shadow Method";
    string UIFieldNames = "DepthMap Hard:PCF Soft:VSM Soft";
    int UIMin = 0;
    int UIMax = 2;
> = 0;
//シャドウ強度
uniform float gShadowIntensity <
    string UIGroup = "CastShadow";
    int UIOrder = 502;
    string UIName = "Shadow Intensity";
    float UIMin = 0.0f;
    float UIMax = 1.0f;
> = 0.5f;

//【ガンマ補正情報】
//ガンマ補正
uniform bool gUseGamma <
    string UIGroup = "Color Space";
    int UIOrder = 600;
    string UIName = "Gamma 2.2";
> = true;

//【SDF情報】
//SDFを使うかどうか
uniform bool gUseSdf <
    string UIGroup = "SDF Shadow";
    int UIOrder = 700;
    string UIName = "Use SDF Shadow";
> = false;
//SDFマスクテクスチャ読み込み
uniform Texture2D gSdfTexture <
    string UIGroup = "SDF Shadow";
    int UIOrder = 701;
    string UIName = "SDF Mask Texture";
    string UIWidget = "FilePicker";
    string ResourceType = "2D";
>;
uniform float gSdfThreshold <
    string UIGroup = "SDF Shadow";
    int UIOrder = 702;
    string UIName = "SDF Threshold";
    float UIMin = -1.0f;
    float UIMax = 1.0f;
> = 0.0f;
uniform float gSdfFeather <
    string UIGroup = "SDF Shadow";
    int UIOrder = 603;
    string UIName = "SDF Feather";
    float UIMin = 0.0f;
    float UIMax = 0.1f;
> = 0.0f;
uniform float gSdfFlipFeather <
    string UIGroup = "SDF Shadow";
    int UIOrder = 604;
    string UIName = "SDF Flip Feather";
    float UIMin = 0.0f;
    float UIMax = 0.1f;
> = 0.0f;

struct VS_INPUT{
    float4 Position :   POSITION;
    float4 Normal   :   NORMAL;
    float4 Tangent  :   TANGENT;
    float2 UV       :   TEXCOORD0;
};

struct VS_TO_PS{
    float4 HPos     :   SV_Position;
    float4 Normal   :   NORMAL;
    float4 Tangent  :   TANGENT;
    float3 Binormal :   BINORMAL;
    float2 UV       :   TEXCOORD0;
    float3 View     :   TEXCOORD1;
    float4 posInLVP :   TEXCOORD2;
};

uniform SamplerState gWrapSampler{
    Filter = MIN_MAG_MIP_LINEAR;
    AddressU = WRAP;
    AddressV = WRAP;
};

//正確にsRGBガンマ補正を計算する関数
float3 CulcSrgb(float3 linearColor){
    float r = linearColor.r;
    float g = linearColor.g;
    float b = linearColor.b;
    if(r <= 0.0031308){ //暗い部分は線形
        r *=12.92;
    }else{ //明るい部分はガンマ2.4
        r = pow(r, 1.0f / 2.4f) * 1.055f - 0.055;
    }
    if(g <= 0.0031308){ //暗い部分は線形
        g *=12.92;
    }else{ //明るい部分はガンマ2.4
        g = pow(g, 1.0f / 2.4f) * 1.055f - 0.055;
    }
    if(b <= 0.0031308){ //暗い部分は線形
        b *=12.92;
    }else{ //明るい部分はガンマ2.4
        b = pow(b, 1.0f / 2.4f) * 1.055f - 0.055;
    }
    return float3(r, g, b);
}


//トゥーンシェーディングを計算する関数
float3 CulcShade(VS_TO_PS In){
    float3 OutColor;
    float3 lightDir = normalize(gLight0Dir);
    float3 baseColor;
    float3 shadowColor;
    float gamma = 1.0;
    if(gUseGamma == true){
        gamma = 1.0f / 2.2f;
    }
    //ノーマルマップの読み込み
    float3 normal;
    if(gUseNormalMap == true){
        normal = gNormalMap.Sample(gWrapSampler, In.UV).xyz * 2.0f - 1.0f;
        normal.xy *= gNormalIntensity;
        normal = normal.x * In.Tangent.xyz + normal.y * In.Binormal + normal.z * In.Normal.xyz;
    }else{
        normal = In.Normal.xyz;
    }
    float N;
    if(gUseSdf == true){
        float3 fDir = float3(0.0f, 0.0f, gLight1Dir.z);//顔の向き
        float3 rDir = float3(gLight1Dir.x, 0.0f, 0.0f);//顔の右方向の向き
        //前方向と右方向それぞれとライトの内積を計算
        float dotF = dot(gLight0Dir, fDir) * 0.5f + 0.5f;//ライトと顔が相対しているときは1.0、角度がつくにつれて0.0に向かう
        float dotR = dot(-gLight0Dir, rDir);//ライトと顔が相対しているとき0.0、右90度で照らしていると1.0、左90度で照らしていると-1.0
        //マスク読み込み
        float sdfMask = gSdfTexture.Sample(gWrapSampler, In.UV).r;
        //マスクを反転したものを作る
        float sdfMask_flip = gSdfTexture.Sample(gWrapSampler, float2(1.0f - In.UV.x, In.UV.y)).r;
        //右から照らしているときは通常のマスク、左から照らしているときは反転したマスクとして合成する
        N = lerp(sdfMask_flip, sdfMask, smoothstep(0.5f - gSdfFlipFeather * 0.5f, 0.5f + gSdfFlipFeather * 0.5f, 1.0f - (dotR * 0.5f + 0.5f)));
        N = smoothstep((gSdfThreshold * 0.5f + 1.0f) - gSdfFeather, (gSdfThreshold * 0.5f + 1.0f) + gSdfFeather, (N - dotF) + 1.0);
    }else if(gUseSdf == false){
        N = dot(normal, -lightDir);
        N = smoothstep(gToonThreshold - gToonFeather, gToonThreshold + gToonFeather, N);
    }    
    if(gUseBaseColorTexture == true){
        baseColor = pow(gBaseColorTexture.Sample(gWrapSampler, In.UV).xyz, gamma) * gBaseColor;
    }else{
        baseColor = gBaseColor;
    }
    if(gUseShadowColorTexture == true){
        shadowColor = pow(gShadowColorTexture.Sample(gWrapSampler, In.UV).xyz, gamma) * gShadowColor;
    }else{
        shadowColor = gShadowColor;
    }
    OutColor = lerp(shadowColor, baseColor, N);
    return OutColor;
}


//頂点シェーダー（メイン）
VS_TO_PS VS(VS_INPUT In){
    VS_TO_PS Out;
    Out.HPos = mul(In.Position, gWVP);
    Out.Normal = mul(In.Normal, gWIT);
    Out.Tangent = normalize(mul(In.Tangent, gWIT));
    Out.Binormal = cross(In.Normal.xyz, In.Tangent.xyz).xyz * In.Tangent.w;
    Out.Binormal = normalize(mul(float4(Out.Binormal, 0.0f), gWIT));
    Out.UV = float2(In.UV.x, (1.0 - In.UV.y));
    Out.View = normalize(mul(In.Position, gW).xyz - gVI[3].xyz);
    Out.posInLVP = mul(mul(In.Position, gW), gMatLight);
    return Out;
}

//頂点シェーダー（アウトライン）
VS_TO_PS VS_OUTLINE(VS_INPUT In){
    VS_TO_PS Out;
    Out.Normal = mul(In.Normal, gWIT);
    Out.Tangent = normalize(mul(In.Tangent, gWIT));
    Out.Binormal = cross(In.Normal.xyz, In.Tangent.xyz).xyz * In.Tangent.w;
    Out.Binormal = normalize(mul(float4(Out.Binormal, 0.0f), gWIT));
    Out.UV = float2(In.UV.x, (1.0 - In.UV.y));
    Out.View = normalize(mul(In.Position, gW).xyz - gVI[3].xyz);
    Out.posInLVP = mul(mul(In.Position, gW), gMatLight);
    if(gUseOutline == true){
        float4 worldPosition = mul(In.Position, gW);
        float4 worldNormal = Out.Normal * gOutlineWidth;
        if(gUseOutlineMask == true){
            float outlineMask = 1.0f;
            if(gOutlineMaskSource == 0){
                outlineMask = gOutlineMaskTexture.    SampleLevel(gWrapSampler, In.UV, 0).r;
            }else if(gOutlineMaskSource == 1){
                outlineMask = gOutlineColorTexture.SampleLevel(gWrapSampler, In.UV, 0).a;
            }
            worldNormal.xyz *= outlineMask;
        }
        if(gUseLightDirWidth == 1){
            float LN = clamp(dot(In.Normal.xyz, gLight0Dir), 0.0f, 1.0f);
            LN = 1.0f - ((1.0f - LN) * gLightDirWidthIntensity);
            worldNormal *= LN;
        }
        if(gUseDistanceWidth == 1){
            float depth = distance(mul(In.Position, gW).xyz, gVI[3].xyz);
            float adjustedDepth = depth * gScalingFactor + 1.0;
            worldNormal *= adjustedDepth;
        }
        worldPosition.xyz += worldNormal.xyz;
        Out.HPos = mul(worldPosition, gVP);
    }else{
        Out.HPos = mul(In.Normal, gWVP);
    }
    return Out;
}

//ピクセルシェーダー（メイン）
float4 PS(VS_TO_PS In) : SV_Target{
    float3 color = CulcShade(In);
    float gamma = 1.0;
    if(gUseGamma == true){
        gamma = 1.0f / 2.2f;
    }
    //リムライト
    if(gUseRim == true){
        float3 rimColor;
        float mask = 1.0f;
        if(gUseRimColorTexture == true){
            rimColor = pow(gRimColorTexture.Sample(gWrapSampler, In.UV).xyz, gamma);
        }else if(gUseRimColorTexture == false){
            rimColor = gRimColor;
        }
        if(gUseRimMask == true){
            mask = gRimMask.Sample(gWrapSampler, In.UV).xyz;
        }
        float vdn = smoothstep((1.0f - gRimArea) - gRimFeather, (1.0f - gRimArea) + gRimFeather, dot(In.View, In.Normal.xyz) + 1.0);
        vdn *= gRimLevel;
        vdn *= mask;
        if(gUseLightDirMask == true){
            float LN = clamp(dot(In.Normal.xyz, gLight0Dir), 0.0f, 1.0f);
            LN = 1.0f - ((1.0f - LN) * gLightDirMaskIntensity);
            vdn *= LN;
        }
        if(gRimBlendMode == 0){
            rimColor = 1.0f - (1.0f - color) * (1.0f - rimColor);
        }else if(gRimBlendMode == 1){
            rimColor += color;
        }else if(gRimBlendMode == 2){
            rimColor = clamp(0.0f, 0.99f, rimColor);
            rimColor = color / (1.0f - rimColor);
        }
        color = lerp(color, rimColor, vdn);
    }
    if(gUseCastShadow == true){
        float2 shadowMapUV = In.posInLVP.xy / In.posInLVP.w;
        shadowMapUV *= float2(0.5f, -0.5f);
        shadowMapUV += float2(0.5f, 0.5f);
        float zInLVP = In.posInLVP.z / In.posInLVP.w;
        if(gShadowMethod == 0){
            //デプスマップシャドウの処理実装予定
        }else if(gShadowMethod == 1){
            //PCFソフトシャドウ実装予定
        }else if(gShadowMethod == 2){
            //VSMソフトシャドウ実装予定
        }
    }
    return float4(color, 1.0f);
}

//ピクセルシェーダー（アウトライン）
float4 PS_OUTLINE(VS_TO_PS In) : SV_Target{
    float3 color = float3(0.0f, 0.0f, 0.0f);
    float gamma = 1.0;
    if(gUseGamma == true){
        gamma = 1.0f / 2.2f;
    }
    if(gUseColorTresses == true){
        float3 tressColor = CulcShade(In);
        color = tressColor * gOutlineColor;
    }else{
        if(gUseOutlineColorTexture == true){
            color = pow(gOutlineColorTexture.Sample(gWrapSampler, In.UV).xyz, gamma) * gOutlineColor;
        }else if(gUseOutlineColorTexture == false){
            color = gOutlineColor;
        }
    }
    return float4(color, 1.0f);
}

RasterizerState CullFront{
    FillMode = Solid;
    CullMode = Front;
};

RasterizerState CullBack{
    FillMode = Solid;
    CullMode = Back;
};

technique11 toonShader{
        pass P0{
            SetRasterizerState(CullFront);
            SetVertexShader(CompileShader(vs_5_0, VS()));
            SetPixelShader(CompileShader(ps_5_0, PS()));
        }
        pass P1{
            SetRasterizerState(CullBack);
            SetVertexShader(CompileShader(vs_5_0, VS_OUTLINE()));
            SetPixelShader(CompileShader(ps_5_0, PS_OUTLINE()));
        }
}