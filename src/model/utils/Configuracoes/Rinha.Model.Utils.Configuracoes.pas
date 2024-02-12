unit Rinha.Model.Utils.Configuracoes;
interface
uses
  System.IniFiles,
  System.SysUtils,
  Rinha.Model.Utils.Configuracoes.Interfaces,
  Rinha.Model.Utils.Configuracoes.Params,
  Rinha.Model.Utils.Criptografia.Interfaces,
  Rinha.Model.Utils.Criptografia;
type
  TModelUtilsSettings = class(TInterfacedObject, iModelUtilsSettings)
  private
    FParams: iModelUtilsSettingsParams;
    FSettings: TIniFile;
    FCryptography : iModelUtilsCryptography;
    function SaveData: Boolean;
  public
    constructor Create;
    destructor Destroy; override;
    class function New: iModelUtilsSettings;
    function SaveSettings: iModelUtilsSettings;
    function LoadingSettings: iModelUtilsSettings;
    function Params: iModelUtilsSettingsParams;
  end;
implementation
{ TModelUtilsSettings }
function TModelUtilsSettings.LoadingSettings: iModelUtilsSettings;
var
  aPassword: string;
begin
  aPassword := FSettings.ReadString('CONFIGURACAO','Password', '');
  FParams.DataBase(FSettings.ReadString('CONFIGURACAO','DataBase', ''));
  FParams.UserName(FSettings.ReadString('CONFIGURACAO','UserName', ''));
  FParams.Password(FCryptography.Decrypt(aPassword));
  FParams.Protocol(FSettings.ReadString('CONFIGURACAO','Protocol', ''));
  FParams.HostName(FSettings.ReadString('CONFIGURACAO','HostName', ''));
  FParams.Port(FSettings.ReadString('CONFIGURACAO','Port', ''));
end;

constructor TModelUtilsSettings.Create;
begin
  FSettings := TIniFile.Create(ExtractFilePath(ParamStr(0)) + '\Config.ini');
  FParams := TModelUtilsSettingsParams.New(Self);
  FCryptography := TModelUtilsCryptography.New;
end;

destructor TModelUtilsSettings.Destroy;
begin
  if Assigned(FSettings) then
    FreeAndNil(FSettings);
  inherited;
end;

class function TModelUtilsSettings.New: iModelUtilsSettings;
begin
  Result := Self.Create;
end;

function TModelUtilsSettings.Params: iModelUtilsSettingsParams;
begin
  Result := FParams;
end;

function TModelUtilsSettings.SaveSettings: iModelUtilsSettings;
begin
  SaveData;
end;

function TModelUtilsSettings.SaveData: Boolean;
begin
  try
    FSettings.WriteString('CONFIGURACAO', 'DataBase', FParams.DataBase);
    FSettings.WriteString('CONFIGURACAO', 'UserName', FParams.UserName);
     FSettings.WriteString('CONFIGURACAO', 'Password',
     FCryptography.Encrypt(FParams.Password));
    FSettings.WriteString('CONFIGURACAO', 'Protocol', FParams.Protocol);
    FSettings.WriteString('CONFIGURACAO', 'HostName', FParams.HostName);
    FSettings.WriteString('CONFIGURACAO', 'Port', FParams.Port);
    Result := True;
  except
   on E: Exception do
    begin
      Result := False;
    end;
  end;
end;
end.
