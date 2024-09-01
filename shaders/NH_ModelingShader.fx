float4x4 gWVP   :   WorldViewProjection;
float4x4 gWIT   :   WorldInverseTranspose;
float4x4 gW     :   World;
float4x4 gVP    :   ViewProjection;

float3 gLight0Dir   :   DIRECTION <
    string Object = "Light 0";
    int UIOrder = 0;
>;
//カラー設定
float3 gBaseColor <
    string UIGroup = "Color Setting";
    int UIOrder = 201;
    string UIName = "Base Color";
    string UIWidget = "Color Picker";
> = {1.0f, 1.0f, 1.0f};

float3 gShadowColor <
    string UIGroup = "Color Setting";
    int UIOrder = 202;
    string UIName = "Shadow Color";
    string UIWidget = "Color Picker";
> = {0.5f, 0.5f, 0.5f};

//法線強調モード
float gHilightIntensity <
    string UIGroup = "Hilight Normal";
    int UIOrder = 300;
    string UIName = "Hilight Normal Intensity";
    float UIMin = 1.0f;
    float UIMax = 50.0f;
> = 1.0f;
//トゥーンモード

float gToonThreshold <
    string UIGroup = "Toon Shading";
    int UIOrder = 301;
    string UIName = "Toon Shreshold";
    float UIMin = -1.0f;
    float UIMax = 1.0f;
> = 0.0f;

float gToonFeather <
    string UIGroup = "Toon Shading";
    int UIOrder = 302;
    string UIName = "Toon Feather";
    float UIMin = 0.0f;
    float UIMax = 1.0f;
> = 0.0f;

bool gUseOutline <
    string UIGroup = "Outline";
    int UIOrder = 303;
    string UIName = "Use Outline";
> = false;

float3 gOutlineColor <
    string UIGroup = "Outline";
    int UIOrder = 304;
    string UIName = "Outline Color";
    string UIWidget = "Color Picker";
> = {0.0f, 0.0f, 0.0f};

float gOutlineWidth <
    string UIGroup = "Outline";
    int UIOrder = 305;
    string UIName = "Outline Width";
    float UIMin = 0.0f;
    float UIMax = 5.0f;
> = 1.0f;

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
    color = lerp(gShadowColor, gBaseColor, N);
    return float4(color, 1.0f);
}

float4 PS_HILIGHT(VS_TO_PS In) : SV_Target{
    float3 color;
    float N;
    float3 lightDir = normalize(gLight0Dir);
    N = dot(-gLight0Dir, In.Normal.xyz);
    N = pow(N * 0.5 + 0.5, gHilightIntensity);
    color = lerp(gShadowColor, gBaseColor, N);
    return float4(color, 1.0f);
}

float4 PS_TOON(VS_TO_PS In) : SV_Target{
    float3 color;
    float N;
    float3 lightDir = normalize(gLight0Dir);
    N = dot(-gLight0Dir, In.Normal.xyz);
    N = smoothstep(gToonThreshold - gToonFeather, gToonThreshold + gToonFeather, N);
    N = clamp(0.0, 1.0, N);
    color = lerp(gShadowColor, gBaseColor, N);
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
}technique11 HilightNormal{
    pass P0{
        SetRasterizerState(CullBack);
        SetVertexShader(CompileShader(vs_5_0, VS()));
        SetPixelShader(CompileShader(ps_5_0, PS_HILIGHT()));
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