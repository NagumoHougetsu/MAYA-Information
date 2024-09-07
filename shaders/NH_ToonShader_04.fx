float4x4 gWVP   :   WorldViewProjection;
float4x4 gWIT   :   WorldInverseTranspose;

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

VS_TO_PS VS(VS_INPUT In){
    VS_TO_PS Out;
    Out.HPos = mul(In.Position, gWVP);
    Out.Normal = mul(In.Normal, gWIT);
    Out.UV = float2(In.UV.x, (1.0 - In.UV.y));
    return Out;
}

float4 PS(VS_TO_PS In) : SV_Target{
    float3 lightDir = normalize(gLight0Dir);
    float N = dot(In.Normal.xyz, -lightDir);
    N = smoothstep(gToonThreshold - gToonFeather, gToonThreshold + gToonFeather, N);
    N = clamp(0.0, 1.0, N);
    float3 color;
    float3 baseColor;
    float3 shadowColor;
    if(gUseBaseColorTexture == true){
        baseColor = gBaseColorTexture.Sample(gWrapSampler, In.UV) * gBaseColor;
    }else{
        baseColor = gBaseColor;
    }
    if(gUseShadowColorTexture == true){
        shadowColor = gShadowColorTexture.Sample(gWrapSampler, In.UV) * gShadowColor;
    }else{
        shadowColor = gShadowColor;
    }
    color = lerp(shadowColor, baseColor, N);
    return float4(color, 1.0);
}

RasterizerState CullFront{
    CullMode = Front;
};

technique11 WhiteLambert{
        pass P0{
            SetRasterizerState(CullFront);
            SetVertexShader(CompileShader(vs_5_0, VS()));
            SetPixelShader(CompileShader(ps_5_0, PS()));
        }
}