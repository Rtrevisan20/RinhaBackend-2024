unit Rinha.Model.Entidades.Clientes;

interface

uses
  Horse,

  DataSet.Serialize,

  Rinha.Model.Connection.Factory,
  Rinha.Model.Connection.Interfaces,
  Rinha.Model.Log,
  Rinha.Model.Log.Interfaces,

  System.Classes,
  System.JSON,
  System.SysUtils;

type
  TModelEntidadeCliente = class
  private
    FQuery : iModelConnectionQuery;
    FLog : iModelLog;
  public
    constructor Create;
    destructor Destroy; override;
    function Insert(aLimite, aSaldoInicial : integer) : TJSONObject;
    function Edit(aLimite, aSaldoInicial : integer) : TJSONObject;
    function Delete(aID : integer) : TJSONObject;
    function Listar : TJSONArray;
  end;

implementation

{ TModelEntidadeCliente }

constructor TModelEntidadeCliente.Create;
begin
  FQuery := TModelConnectionFactory.New.Query;
  FLog   := TModelLog.New;
end;

function TModelEntidadeCliente.Delete(aID: integer): TJSONObject;
begin
  try

  except on E: Exception do
    begin
      FLog.LogMensage('Erro: ' + E.Message).SalvarLog;
      raise Exception.Create(E.Message);
    end;
  end;
end;

destructor TModelEntidadeCliente.Destroy;
begin

  inherited;
end;

function TModelEntidadeCliente.Edit(aLimite, aSaldoInicial: integer): TJSONObject;
begin
  try

  except on E: Exception do
    begin
      FLog.LogMensage('Erro: ' + E.Message).SalvarLog;
      raise Exception.Create(E.Message);
    end;
  end;
end;

function TModelEntidadeCliente.Insert(aLimite, aSaldoInicial: integer): TJSONObject;
begin
  try

  except on E: Exception do
    begin
      FLog.LogMensage('Erro: ' + E.Message).SalvarLog;
      raise Exception.Create(E.Message);
    end;
  end;
end;

function TModelEntidadeCliente.Listar: TJSONArray;
var
  i : integer;
begin
  try
    i:= StrToInt('oioiadsoi');
  except on E: Exception do
    begin
      FLog.LogMensage('Erro: ' + E.Message).SalvarLog;
      raise Exception.Create(E.Message);
    end;
  end;
end;

end.
