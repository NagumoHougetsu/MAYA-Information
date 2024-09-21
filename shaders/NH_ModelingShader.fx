float4x4 gWVP   :   WorldViewProjection;
float4x4 gWIT   :   WorldInverseTranspose;
float4x4 gW     :   World;
float4x4 gVP    :   ViewProjection;

float3 gLight0Dir   :   DIRECTION <
    string Object = "Light 0";
    int UIOrder = 0;
>;

//カラー設定
uniform bool gUseBaseColorTexture <
    string UIGroup = "Color Setting";
    int UIOrder = 100;
    string UIName = "Use BaseColor Texture";
> = false;

uniform float3 gBaseColor <
    string UIGroup = "Color Setting";
    int UIOrder = 101;
    string UIName = "Base Color";
    string UIWidget = "Color Picker";
> = {1.0f, 1.0f, 1.0f};

uniform Texture2D gBaseColorTexture <
    string UIGroup = "Color Setting";
    int UIOrder = 102;
    string UIName = "BaseColorTexture";
    string UIWidget = "FilePicker";
    string ResourceType = "2D";
>;

uniform bool gUseShadowColorTexture <
    string UIGroup = "Color Setting";
    int UIOrder = 103; 
    string UIName = "Use ShadowColor Texture";
> = false;

uniform float3 gShadowColor <
    string UIGroup = "Color Setting";
    int UIOrder = 104;
    string UIName = "Shadow Color";
    string UIWidget = "Color Picker";
> = {0.5f, 0.5f, 0.5f};

uniform Texture2D gShadowColorTexture <
    string UIGroup = "Color Setting";
    int UIOrder = 105;
    string UIName = "ShadowColor Texture";
    string UIWidget = "FilePicker";
    string ResourceType = "2D";
>;

//法線強調モード
uniform float gCurvatureIntensity <
    string UIGroup = "Curvature";
    int UIOrder = 200;
    string UIName = "Curvature Intensity";
    float UIMin = 1.0f;
    float UIMax = 5.0f;
> = 1.0f;

//トゥーンモード
uniform float gToonThreshold <
    string UIGroup = "Toon Shading";
    int UIOrder = 300;
    string UIName = "Toon Shreshold";
    float UIMin = -1.0f;
    float UIMax = 1.0f;
> = 0.0f;

uniform float gToonFeather <
    string UIGroup = "Toon Shading";
    int UIOrder = 301;
    string UIName = "Toon Feather";
    float UIMin = 0.0f;
    float UIMax = 1.0f;
> = 0.0f;

uniform bool gUseOutline <
    string UIGroup = "Outline";
    int UIOrder = 302;
    string UIName = "Use Outline";
> = false;

uniform float3 gOutlineColor <
    string UIGroup = "Outline";
    int UIOrder = 303;
    string UIName = "Outline Color";
    string UIWidget = "Color Picker";
> = {0.0f, 0.0f, 0.0f};

uniform float gOutlineWidth <
    string UIGroup = "Outline";
    int UIOrder = 304;
    string UIName = "Outline Width";
    float UIMin = 0.0f;
    float UIMax = 5.0f;
> = 1.0f;

uniform SamplerState gWrapSampler{
    Filter = MIN_MAG_MIP_LINEAR;
    AddressU = WRAP;
    AddressV = WRAP;
};

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

VS_TO_PS VS(VS_INPUT In){
    VS_TO_PS Out;
    Out.HPos = mul(In.Position, gWVP);
    Out.Normal = mul(In.Normal, gWIT);
    Out.UV = float2(In.UV.x, (1.0 - In.UV.y));
    return Out;
}

VS_TO_PS VS_OUTLINE(VS_INPUT In){
    VS_TO_PS Out;
    Out.Normal = mul(In.Normal, gWIT);
    Out.UV = float2(In.UV.x, (1.0f - In.UV.y));
    if(gUseOutline == true){
        float4 worldPosition = mul(In.Position, gW) + Out.Normal * gOutlineWidth;
        Out.HPos = mul(worldPosition, gVP);
    }else{
        Out.HPos = mul(In.Position, gWVP);
    }
    return Out;    
}

float4 PS_DEF(VS_TO_PS In) : SV_Target{
    float3 color;
    float N;
    float3 lightDir = normalize(gLight0Dir);
    N = dot(-gLight0Dir, In.Normal.xyz);
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
    return float4(color, 1.0f);
}

float4 PS_CURVATURE(VS_TO_PS In) : SV_Target{
    float3 dx = ddx(In.Normal);
    float3 dy = ddx(In.Normal);
    float3 xneg = In.Normal - dx;
    float3 xpos = In.Normal + dx;
    float3 yneg = In.Normal - dy;
    float3 ypos = In.Normal + dy;
    float depth = In.HPos.z / In.HPos.w * 0.5f + 0.5f;
    float curvature = (cross(xneg, xpos).y - cross(yneg, ypos).x) * 4.0f / depth;
    float ambient = pow(float3(curvature + 0.5f, curvature + 0.5f, curvature + 0.5f), gCurvatureIntensity);
    float3 color;
    float N;
    float3 lightDir = normalize(gLight0Dir);
    N = dot(-gLight0Dir, In.Normal.xyz);
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
    color = lerp(shadowColor, baseColor, N * ambient);
    return float4(color, 1.0f);
}


float4 PS_TOON(VS_TO_PS In) : SV_Target{
    float3 color;
    float N;
    float3 lightDir = normalize(gLight0Dir);
    N = dot(-gLight0Dir, In.Normal.xyz);
    N = smoothstep(gToonThreshold - gToonFeather, gToonThreshold + gToonFeather, N);
    N = clamp(0.0, 1.0, N);
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
    return float4(color, 1.0f);
}

float4 PS_OUTLINE(VS_TO_PS In) : SV_Target{
    return float4(gOutlineColor, 1.0f);
}

RasterizerState CullBack{
    CullMode = Front;
};

RasterizerState CullFront{
    CullMode = Back;
};

technique11 Default{
    pass P0{
        SetRasterizerState(CullBack);
        SetVertexShader(CompileShader(vs_5_0, VS()));
        SetPixelShader(CompileShader(ps_5_0, PS_DEF()));
    }
}technique11 Curvature{
    pass P0{
        SetRasterizerState(CullBack);
        SetVertexShader(CompileShader(vs_5_0, VS()));
        SetPixelShader(CompileShader(ps_5_0, PS_CURVATURE()));
    }
}technique11 Toon{
    pass P0{
        SetRasterizerState(CullBack);
        SetVertexShader(CompileShader(vs_5_0, VS()));
        SetPixelShader(CompileShader(ps_5_0, PS_TOON()));
    }pass P1{
        SetRasterizerState(CullFront);
        SetVertexShader(CompileShader(vs_5_0, VS_OUTLINE()));
        SetPixelShader(CompileShader(ps_5_0, PS_OUTLINE()));
    }
}