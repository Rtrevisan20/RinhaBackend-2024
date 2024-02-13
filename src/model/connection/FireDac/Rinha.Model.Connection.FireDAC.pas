unit Rinha.Model.Connection.FireDAC;

interface

uses
  Data.DB,

  FireDAC.Comp.Client,
  FireDAC.Comp.DataSet,
  FireDAC.Comp.UI,
  FireDAC.DApt,
  FireDAC.DApt.Intf,
  FireDAC.DatS,
  FireDAC.Phys,
  FireDAC.Phys.PG,
  FireDAC.Phys.PGDef,
  FireDAC.Phys.IBBase,
  FireDAC.Phys.Intf,
  FireDAC.Phys.SQLiteVDataSet,
  FireDAC.Stan.Async,
  FireDAC.Stan.Def,
  FireDAC.Stan.Error,
  FireDAC.Stan.Intf,
  FireDAC.Stan.Option,
  FireDAC.Stan.Param,
  FireDAC.Stan.Pool,
  FireDAC.UI.Intf,
  DataSet.Serialize.Config,
  Rinha.Model.Connection.Interfaces,
  Rinha.Model.Log,
  Rinha.Model.Log.Interfaces,
  Rinha.Model.Utils.Configuracoes,
  Rinha.Model.Utils.Configuracoes.Interfaces,

  System.Generics.Collections,
  System.SysUtils;

type
  TModelConnectionFireDac = class(TInterfacedObject, iModelConnection)
  private
    FPath : string;
    FConnection: TFDConnection;
    FConnList: TObjectList<TFDConnection>;
    FSettings: iModelUtilsSettings;
    FLog : iModelLog;
    FDriverLinkFB : TFDPhysPgDriverLink;
    procedure SetDataSetSerialize;
  public
    constructor Create;
    destructor Destroy; override;
    class function New: iModelConnection;
    function Connection: TCustomConnection;
    function IdConnection: integer;
    function Disconnected(aIndexConn: integer): iModelConnection;
    function GetConnection(aIndexConn: integer): TCustomConnection;
  end;

const
  aDriverID = 'PG';

implementation

{ TModelConnectionFireDac }

function TModelConnectionFireDac.Connection: TCustomConnection;
begin
  FConnection := TFDConnection.Create(nil);
//  Result := FConnection;
  with FConnection do
  begin
    Params.Clear;
    Params.Add('DriverID=' + aDriverID); // driver de conexao
    Params.Add('Database=' + FSettings.Params.DataBase);// caminho da base dados
    Params.Add('user_name=' + FSettings.Params.UserName);// usuario do banco
    Params.Add('password=' + FSettings.Params.Password); // senha do banco
    Params.Add('Protocolo=' + FSettings.Params.Protocol);// protocolo de conexao
    Params.Add('hostname=' + FSettings.Params.HostName);// local do server ex 192.168.0.1
    Params.Add('port=' + FSettings.Params.Port); // porta da concexao remota
    Params.Add('CharacterSet=' + 'win1252'); // character padrao do banco

    try
      SetDataSetSerialize;
      FConnection.Connected := True;
      Result := FConnection;
    except
      on E: Exception do
      begin
       FLog.LogMensage(e.Message).SalvarLog;
       raise Exception.Create(e.Message);
      end;
    end;
  end;
end;

constructor TModelConnectionFireDac.Create;
begin
  FPath := ExtractFilePath(ParamStr(0));
  FSettings := TModelUtilsSettings.New;
  FLog :=  TModelLog.New;

  FDriverLinkFB := TFDPhysPgDriverLink.Create(nil);
  {$IFDEF WIN32}
   FDriverLinkFB.VendorLib := FPath + '..\dlls\x32\libpq.dll';
  {$ELSEIF DEFINED(WIN64)}
   FDriverLinkFB.VendorLib := FPath + '..\dlls\x64\libpq.dll';
  {$ELSEIF DEFINED(LINUX64)}
   FDriverLinkFB.VendorLib := FPath + '..\dlls\x64\libpq.dll';
  {$ENDIF$}
//  FDriverLinkFB.Release;
end;

destructor TModelConnectionFireDac.Destroy;
begin
  FreeAndNil(FConnList);
  inherited;
end;

function TModelConnectionFireDac.Disconnected(aIndexConn: integer): iModelConnection;
begin
  Result := Self;
  FConnList.Items[aIndexConn].Connected := False;
  FConnList.Items[aIndexConn].Free;
  FConnList.TrimExcess;
end;

function TModelConnectionFireDac.GetConnection(aIndexConn: integer): TCustomConnection;
begin
  Result := FConnList.Items[aIndexConn];
end;

function TModelConnectionFireDac.IdConnection: integer;
var
  IndexConn: integer;
begin
//  Result := -1;
  FSettings.LoadingSettings;

  if not Assigned(FConnList) then
    FConnList := TObjectList<TFDConnection>.Create(False);

  FConnList.Add(TFDConnection.Create(nil));
  IndexConn := Pred(FConnList.Count);
  with FConnList.Items[IndexConn] do
  begin
    Params.Clear;
    Params.Add('DriverID=' + aDriverID); // driver de conexao
    Params.Add('Database=' + FSettings.Params.DataBase);// caminho da base dados '192.168.100.122:/media/storage/InforTech/DataBase/AmbiSoft.FDB'
    Params.Add('user_name=' + FSettings.Params.UserName);// usuario do banco
    Params.Add('password=' + FSettings.Params.Password); // senha do banco
    Params.Add('Protocolo=' + FSettings.Params.Protocol);// protocolo de conexao
    Params.Add('hostname=' + FSettings.Params.HostName);// local do server ex 192.168.0.1
    Params.Add('port=' + FSettings.Params.Port); // porta da concexao remota
    Params.Add('CharacterSet=' + 'win1252'); // character padrao do banco
    try
      SetDataSetSerialize;
      Connected := True;
      Result := IndexConn;
    except
      on E: Exception do
      begin
        FLog.LogMensage(e.Message).SalvarLog;
        raise Exception.Create(e.Message);
      end;
    end;
  end;

end;

class function TModelConnectionFireDac.New: iModelConnection;
begin
  Result := Self.Create;
end;

procedure TModelConnectionFireDac.SetDataSetSerialize;
begin
  TDataSetSerializeConfig.GetInstance.CaseNameDefinition      := cndNone;
  TDataSetSerializeConfig.GetInstance.Import.DecimalSeparator := '.';
end;

end.
