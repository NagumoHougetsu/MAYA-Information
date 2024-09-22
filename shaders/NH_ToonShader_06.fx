float4x4 gWVP   :   WorldViewProjection;
float4x4 gWIT   :   WorldInverseTranspose;
float4x4 gW     :   World;
float4x4 gVP    :   ViewProjection;

//【GUI」ライト情報取得
float3 gLight0Dir   :   DIRECTION <
    string Object = "Light 0";
    int UIOrder = 0;
>;
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

//アウトラインマスクテクスチャ読み込み
uniform Texture2D gOutlineMaskTexture <
    string UIGroup = "Outline";
    int UIOrder = 307;
    string UIName = "Outline Mask Texture";
    string UIWidget = "FilePicker";
    string ResourceType = "2D";
>;

struct VS_INPUT{
    float4 Position :   POSITION;
    float4 Normal   :   NORMAL;
    float2 UV       :   TEXCOORD0;
};

struct VS_TO_PS{
    float4 HPos     :   SV_Position;
    float4 Normal   :   NORMAL;
    float2 UV       :   TEXCOORD0;
};

uniform SamplerState gWrapSampler{
    Filter = MIN_MAG_MIP_LINEAR;
    AddressU = WRAP;
    AddressV = WRAP;
};

//トゥーンシェーディングを計算する関数
float3 CulcShade(VS_TO_PS In){
    float3 OutColor;
    float3 lightDir = normalize(gLight0Dir);
    float3 baseColor;
    float3 shadowColor;
    float N = dot(In.Normal.xyz, -lightDir);
    N = smoothstep(gToonThreshold - gToonFeather, gToonThreshold + gToonFeather, N);
    if(gUseBaseColorTexture == true){
        baseColor = gBaseColorTexture.Sample(gWrapSampler, In.UV).xyz * gBaseColor;
    }else{
        baseColor = gBaseColor;
    }
    if(gUseShadowColorTexture == true){
        shadowColor = gShadowColorTexture.Sample(gWrapSampler, In.UV).xyz * gShadowColor;
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
    Out.UV = float2(In.UV.x, (1.0 - In.UV.y));
    return Out;
}

//頂点シェーダー（アウトライン）
VS_TO_PS VS_OUTLINE(VS_INPUT In){
    VS_TO_PS Out;
    Out.Normal = mul(In.Normal, gWIT);
    Out.UV = float2(In.UV.x, (1.0 - In.UV.y));
    if(gUseOutline == true){
        float4 worldPosition = mul(In.Position, gW);
        float4 worldNormal = Out.Normal * gOutlineWidth;
        if(gUseOutlineMask == true){
            float outlineMask;
            outlineMask = gOutlineMaskTexture.SampleLevel(gWrapSampler, In.UV, 0).r;
            worldNormal *= outlineMask;
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
    /*
    float3 lightDir = normalize(gLight0Dir);
    float N = dot(In.Normal.xyz, -lightDir);
    N = smoothstep(gToonThreshold - gToonFeather, gToonThreshold + gToonFeather, N);
    N = clamp(0.0, 1.0, N);
    float3 color;
    float3 baseColor;
    float3 shadowColor;
    if(gUseBaseColorTexture == true){
        baseColor = gBaseColorTexture.Sample(gWrapSampler, In.UV).xyz * gBaseColor;
    }else{
        baseColor = gBaseColor;
    }
    if(gUseShadowColorTexture == true){
        shadowColor = gShadowColorTexture.Sample(gWrapSampler, In.UV).xyz * gShadowColor;
    }else{
        shadowColor = gShadowColor;
    }
    color = lerp(shadowColor, baseColor, N);
    */
    float3 color = CulcShade(In);
    return float4(color, 1.0f);
}

//ピクセルシェーダー（アウトライン）
float4 PS_OUTLINE(VS_TO_PS In) : SV_Target{
    float3 color = float3(0.0f, 0.0f, 0.0f);
    if(gUseColorTresses == true){
        float3 tressColor = CulcShade(In);
        color = tressColor * gOutlineColor;
    }else{
        if(gUseOutlineColorTexture == true){
            color = gOutlineColorTexture.Sample(gWrapSampler, In.UV).xyz * gOutlineColor;
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