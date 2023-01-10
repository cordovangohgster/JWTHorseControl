{******************************************************************************}
{                                                                              }
{  Ejmplo tomado de:                                                           }
{  https://github.com/paolo-rossi/delphi-jose-jwt/blob/master/Samples/Basic/   }
{        JWTDemo.Form.Simple.pas                                               }
{                                                                              }
{******************************************************************************}
{                                                                              }
{  Muestra las diferentes formas de crear y obtener informaci�n del JWT        }
{  Use el comando: boss install para descargar las dependencias del proyecto   }
{                                                                              }
{******************************************************************************}
unit UMain;

interface
uses
 Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
 System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
 Vcl.StdCtrls, Vcl.ExtCtrls,
 JOSE.Core.JWT,
 JOSE.Core.JWS,
 JOSE.Core.JWK,
 JOSE.Core.JWA,
 JOSE.Builder,
 JOSE.Types.JSON,
 Vcl.Mask,
 JOSE.Core.Builder,
 JOSE.Producer;

type
  TFMain = class(TForm)
    GroupBox1: TGroupBox;
    btnBuildClasses: TButton;
    cbbAlgorithm: TComboBox;
    Full: TGroupBox;
    memoJSON: TMemo;
    Compact: TGroupBox;
    memoCompact: TMemo;
    Option: TGroupBox;
    btnBuildTJOSE: TButton;
    btnTestClaims: TButton;
    btnVerifyTJOSE: TButton;
    DeserializeTJOSE: TButton;
    VerifyClasses: TButton;
    edtSecret: TLabeledEdit;
    btnBuildProducer: TButton;
    procedure btnBuildClassesClick(Sender: TObject);
    procedure btnTestClaimsClick(Sender: TObject);
    procedure btnBuildTJOSEClick(Sender: TObject);
    procedure btnVerifyTJOSEClick(Sender: TObject);
    procedure DeserializeTJOSEClick(Sender: TObject);
    procedure VerifyClassesClick(Sender: TObject);
    procedure edtSecretChange(Sender: TObject);
    procedure btnBuildProducerClick(Sender: TObject);
    private
    const SECRET_CAPTION = 'Secret (%dbit)';
  private
    { Private declarations }
     FCompact: string;
     procedure BuildToken;
     procedure BuildTokenComplete;
     function VerifyToken: Boolean;
     procedure DeserializeToken;
     function VerifyTokenComplete: Boolean;
  public
    { Public declarations }
  end;

var
  FMain: TFMain;

implementation

{$R *.dfm}

procedure TFMain.btnBuildClassesClick(Sender: TObject);
begin
  BuildTokenComplete;
end;

procedure TFMain.btnBuildProducerClick(Sender: TObject);
var
  LAlg: TJOSEAlgorithmId;
  LResult: string;
begin
  // Signing algorithm
  case cbbAlgorithm.ItemIndex of
    0: LAlg := TJOSEAlgorithmId.HS256;
    1: LAlg := TJOSEAlgorithmId.HS384;
    2: LAlg := TJOSEAlgorithmId.HS512;
  else LAlg := TJOSEAlgorithmId.HS256;
  end;

  LResult := TJOSEProcess.New
    .SetAlgorithm(LAlg)
    .SetKeyID('uniqueidforthistoken')
    .SetHeaderParam('id', 123)

    .SetIssuer('Delphi JOSE Library')
    .SetIssuedAt(Now)
    .SetExpiration(Now + 1)

    .SetCustomClaim('author', 'Paolo Rossi')
    .SetCustomClaim('year', 2022)

    .SetKey(edtSecret.Text)

    .Build
    .GetCompactToken
  ;

  memoCompact.Lines.Add(LResult);
end;

procedure TFMain.btnBuildTJOSEClick(Sender: TObject);
begin
  BuildToken;
end;

procedure TFMain.btnTestClaimsClick(Sender: TObject);
var
  LToken: TJWT;
begin
  // Unpack and verify the token
  LToken := TJOSE.Verify(edtSecret.Text, FCompact);

  if Assigned(LToken) then
  begin
    try
      if LToken.Verified then
      begin
        // Claims validation (for more see the JOSE.Consumer unit)

        if LToken.Claims.Subject <> 'Paolo Rossi' then
          memoJSON.Lines.Add('Subject [sub] claim value doesn''t match expected value');

        if LToken.Claims.Expiration > Now then
          memoJSON.Lines.Add('Expiration time passed: ' + DateTimeToStr(LToken.Claims.Expiration));

      end;
    finally
      LToken.Free;
    end;
  end;
end;

procedure TFMain.btnVerifyTJOSEClick(Sender: TObject);
begin
 if VerifyToken then
    memoJSON.Lines.Add('Token signature is verified')
  else
    memoJSON.Lines.Add('Token signature is not verified')
end;

procedure TFMain.BuildToken;
var
  LToken: TJWT;
  LAlg: TJOSEAlgorithmId;
begin
  // Create a JWT Object
  LToken := TJWT.Create;
  try
    // Token claims

    LToken.Claims.Subject := 'Paolo Rossi';
    LToken.Claims.IssuedAt := Now;
    LToken.Claims.Expiration := Now + 1;
    LToken.Claims.Issuer := 'Delphi JOSE Library';

    // Signing algorithm
    case cbbAlgorithm.ItemIndex of
      0: LAlg := TJOSEAlgorithmId.HS256;
      1: LAlg := TJOSEAlgorithmId.HS384;
      2: LAlg := TJOSEAlgorithmId.HS512;
    else LAlg := TJOSEAlgorithmId.HS256;
    end;

    // Signing and compact format creation.
    FCompact := TJOSE.SerializeCompact(edtSecret.Text, LAlg, LToken);

    // Token in compact representation
    memoCompact.Lines.Add(FCompact);

    // Header and Claims JSON representation
    memoJSON.Lines.Add('Header: ' + TJSONUtils.ToJSON(LToken.Header.JSON));
    memoJSON.Lines.Add('Claims: ' + TJSONUtils.ToJSON(LToken.Claims.JSON));
  finally
    LToken.Free;
  end;
end;

procedure TFMain.BuildTokenComplete;
var
  LToken: TJWT;
  LSigner: TJWS;
  LKey: TJWK;
  LAlg: TJOSEAlgorithmId;
begin
  LToken := TJWT.Create;
  try
    LToken.Claims.Issuer := 'Delphi JOSE Library';
    LToken.Claims.IssuedAt := Now;
    LToken.Claims.Expiration := Now + 1;

    // Signing algorithm
    case cbbAlgorithm.ItemIndex of
      0: LAlg := TJOSEAlgorithmId.HS256;
      1: LAlg := TJOSEAlgorithmId.HS384;
      2: LAlg := TJOSEAlgorithmId.HS512;
    else LAlg := TJOSEAlgorithmId.HS256;
    end;

    LSigner := TJWS.Create(LToken);
    try
      LKey := TJWK.Create(edtSecret.Text);
      try
        // With this option you can have keys < algorithm length
        LSigner.SkipKeyValidation := True;

        LSigner.Sign(LKey, LAlg);
        FCompact := LSigner.CompactToken;

        memoJSON.Lines.Add('Header: ' + TJSONUtils.ToJSON(LToken.Header.JSON));
        memoJSON.Lines.Add('Claims: ' + TJSONUtils.ToJSON(LToken.Claims.JSON));

        memoCompact.Lines.Add('Header: ' + LSigner.Header);
        memoCompact.Lines.Add('Payload: ' + LSigner.Payload);
        memoCompact.Lines.Add('Signature: ' + LSigner.Signature);
        memoCompact.Lines.Add('Compact Token: ' + LSigner.CompactToken);
      finally
        LKey.Free;
      end;
    finally
      LSigner.Free;
    end;
  finally
    LToken.Free;
  end;

end;

procedure TFMain.DeserializeTJOSEClick(Sender: TObject);
begin
  DeserializeToken;
end;

procedure TFMain.DeserializeToken;
var
  LToken: TJWT;
begin
  // Unpack and verify the token
  LToken := TJOSE.DeserializeCompact(edtSecret.Text, FCompact);
  try
    if Assigned(LToken) then
      memoJSON.Lines.Add(LToken.Claims.JSON.ToJSON);
  finally
    LToken.Free;
  end;
end;

procedure TFMain.edtSecretChange(Sender: TObject);
begin
edtSecret.EditLabel.Caption := Format(SECRET_CAPTION, [Length(edtSecret.Text) * 8]);
end;

procedure TFMain.VerifyClassesClick(Sender: TObject);
begin
if VerifyTokenComplete then
    memoJSON.Lines.Add('Token signature is verified')
  else
    memoJSON.Lines.Add('Token signature is not verified')
end;

function TFMain.VerifyToken: Boolean;
var
  LToken: TJWT;
begin
  Result := False;

  // Unpack and verify the token
  LToken := TJOSE.Verify(edtSecret.Text, FCompact);

  if Assigned(LToken) then
  begin
    try
      Result := LToken.Verified;
    finally
      LToken.Free;
    end;
  end;
end;

function TFMain.VerifyTokenComplete: Boolean;
var
  LKey: TJWK;
  LToken: TJWT;
  LSigner: TJWS;
begin
  LKey := TJWK.Create(edtSecret.Text);
  try
    LToken := TJWT.Create;
    try
      LSigner := TJWS.Create(LToken);
      try
        LSigner.SetKey(LKey);
        LSigner.CompactToken := FCompact;
        Result := LSigner.VerifySignature;
      finally
        LSigner.Free;
      end;
    finally
      LToken.Free;
    end;
  finally
    LKey.Free;
  end;
end;

end.
