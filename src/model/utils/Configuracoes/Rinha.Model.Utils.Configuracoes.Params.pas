unit Rinha.Model.Utils.Configuracoes.Params;

interface

uses
  Rinha.Model.Utils.Configuracoes.Interfaces;

type
  TModelUtilsSettingsParams = class(TInterfacedObject,
    iModelUtilsSettingsParams)
  private
    [weak]
    FParent: iModelUtilsSettings;
    FDataBase: string;
    FUserName: string;
    FPassword: string;
    FProtocol: string;
    FHostName: string;
    FPort: string;
  public
    constructor Create(Parent: iModelUtilsSettings);
    destructor Destroy; override;
    class function New(Parent: iModelUtilsSettings)
      : iModelUtilsSettingsParams;
    function &End: iModelUtilsSettings;
    function DataBase: string; overload;
    function DataBase(aValue: string): iModelUtilsSettingsParams; overload;
    function UserName: string; overload;
    function UserName(aValue: string): iModelUtilsSettingsParams; overload;
    function Password: string; overload;
    function Password(aValue: string): iModelUtilsSettingsParams; overload;
    function Protocol: string; overload;
    function Protocol(aValue: string): iModelUtilsSettingsParams; overload;
    function HostName: string; overload;
    function HostName(aValue: string): iModelUtilsSettingsParams; overload;
    function Port: string; overload;
    function Port(aValue: string): iModelUtilsSettingsParams; overload;
  end;

implementation

{ TModelUtilsSettingsParams }

function TModelUtilsSettingsParams.&End: iModelUtilsSettings;
begin
  Result := FParent;
end;

function TModelUtilsSettingsParams.HostName(aValue: string)
  : iModelUtilsSettingsParams;
begin
  Result := Self;
  FHostName := aValue;
end;

function TModelUtilsSettingsParams.HostName: string;
begin
  Result := FHostName;
end;

constructor TModelUtilsSettingsParams.Create
  (Parent: iModelUtilsSettings);
begin
  FParent := Parent;
end;

function TModelUtilsSettingsParams.DataBase: string;
begin
  Result := FDataBase;
end;

function TModelUtilsSettingsParams.DataBase(aValue: string)
  : iModelUtilsSettingsParams;
begin
  Result := Self;
  FDataBase := aValue;
end;

destructor TModelUtilsSettingsParams.Destroy;
begin

  inherited;
end;

class function TModelUtilsSettingsParams.New
  (Parent: iModelUtilsSettings): iModelUtilsSettingsParams;
begin
  Result := Self.Create(Parent);
end;

function TModelUtilsSettingsParams.Password(aValue: string)
  : iModelUtilsSettingsParams;
begin
  Result := Self;
  FPassword := aValue;
end;

function TModelUtilsSettingsParams.Password: string;
begin
  Result := FPassword;
end;

function TModelUtilsSettingsParams.Port(aValue: string)
  : iModelUtilsSettingsParams;
begin
  Result := Self;
  FPort := aValue;
end;

function TModelUtilsSettingsParams.Port: string;
begin
  Result := FPort;
end;

function TModelUtilsSettingsParams.Protocol(aValue: string)
  : iModelUtilsSettingsParams;
begin
  Result := Self;
  FProtocol := aValue;
end;

function TModelUtilsSettingsParams.Protocol: string;
begin
  Result := FProtocol;
end;

function TModelUtilsSettingsParams.UserName: string;
begin
  Result := FUserName;
end;

function TModelUtilsSettingsParams.UserName(aValue: string)
  : iModelUtilsSettingsParams;
begin
  Result := Self;
  FUserName := aValue;
end;

end.
