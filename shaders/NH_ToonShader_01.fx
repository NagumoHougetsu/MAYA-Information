float4x4 gWVP   :   WorldViewProjection;
float4x4 gWIT   :   WorldInverseTranspose;

float3 gLight0Dir   :   DIRECTION <
    string Object = "Light 0";
    int UIOrder = 0;
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

VS_TO_PS VS(VS_INPUT In){
    VS_TO_PS Out;
    Out.HPos = mul(In.Position, gWVP);
    Out.Normal = mul(In.Normal, gWIT);
    Out.UV = float2(In.UV.x, (1.0 - In.UV.y));
    return Out;
}

float4 PS(VS_TO_PS In) : SV_Target{
    float4 color = float4(1.0f, 1.0f, 1.0f, 1.0f);
    float3 lightDir = normalize(gLight0Dir);
    float N = dot(In.Normal.xyz, -lightDir);
    N = clamp(N, 0.0, 1.0);
    color *= N;
    return color;
}

RasterizerState CullBack{
    CullMode = Front;
};

RasterizerState CullFront{
    CullMode = Back;
};

technique11 WhiteLambert{
        pass P0{
            SetRasterizerState(CullBack);
            SetVertexShader(CompileShader(vs_5_0, VS()));
            SetPixelShader(CompileShader(ps_5_0, PS()));
        }
}