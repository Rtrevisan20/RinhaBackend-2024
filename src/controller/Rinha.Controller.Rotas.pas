unit Rinha.Controller.Rotas;

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
  TControllerRotas = class
  private
    FQuery     : iModelConnectionQuery;
    FQueryPesq : iModelConnectionQuery;
    FLog : iModelLog;
  public
    constructor Create;
    destructor Destroy; override;
    function Extrato(aID : integer) : TJSONObject;
    function InsertTransacao(aID : integer; aValor : Currency; aTipo, aDescricao : string) : TJSONObject;
  end;

implementation

{ TControllerRotas }

constructor TControllerRotas.Create;
begin
  FQuery     := TModelConnectionFactory.New.Query;
  FQueryPesq := TModelConnectionFactory.New.Query;
  FLog   := TModelLog.New;
end;


destructor TControllerRotas.Destroy;
begin

  inherited;
end;

function TControllerRotas.Extrato(aID : integer) : TJSONObject;
begin
  try
   var aJSONObject := TJSONObject.Create;
   Result := aJSONObject;

   var aSQL1 :=
    'select SUM(s.valor) TOTAL, '#13+
    'CURRENT_TIMESTAMP data_extrato, '#13+
    'c.limite '#13+
    'FROM SALDOS s '#13+
    'left join clientes c on c.id = s.cliente_id '#13+
    'WHERE CLIENTE_ID = cast(:ID as integer) '#13+
    'group by c.limite';

   var aSQL2 :=
    'select '#13+
    't.valor, '#13+
    't.tipo, '#13+
    't.descricao, '#13+
    't.realizada_em '#13+
    'from transacoes t '#13+
    'where t.cliente_id = cast(:ID as integer)';

    FQuery
     .Params('ID', aID.ToString)
     .OpenSQL(aSQL1);

    FQueryPesq
     .Params('ID', aID.ToString)
     .OpenSQL(aSQL2);

    Result.AddPair('Saldo:', FQuery.DataSet.ToJSONObject);
    Result.AddPair('ultimas_transacoes:', FQueryPesq.DataSet.ToJSONArray);
  except on E: Exception do
    begin
      FLog.LogMensage('Erro: ' + E.Message).SalvarLog;
      raise Exception.Create(E.Message);
    end;
  end;
end;

function TControllerRotas.InsertTransacao(aID : integer; aValor: Currency; aTipo, aDescricao: string): TJSONObject;
begin
  try
    Result := TJSONObject.Create;
  except on E: Exception do
    begin
      FLog.LogMensage('Erro: ' + E.Message).SalvarLog;
      raise Exception.Create(E.Message);
    end;
  end;
end;

end.
