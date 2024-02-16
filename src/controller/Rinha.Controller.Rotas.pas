unit Rinha.Controller.Rotas;

interface

uses
  Data.DB,
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
    FLog : iModelLog;
    function ClientIsExists(aID : integer): boolean;
    function ClientIsNegative(aID, aValor: integer): boolean;
  public
    constructor Create;
    destructor Destroy; override;
    function Extrato(aID : integer) : TJSONObject;
    function InsertTransacao(aID, aValor: integer; aTipo, aDescricao : string) : TJSONObject;
  end;

implementation

{ TControllerRotas }

function TControllerRotas.ClientIsExists(aID: integer): boolean;
begin
  var FQuery     := TModelConnectionFactory.New.Query;
  var aSQL :=
    'select '#13+
    's.valor, '#13+
    's.cliente_id, '#13+
    'c.limite '#13+
    'from saldos s '#13+
    'left join clientes c on c.id = s.cliente_id '#13+
    'where cliente_id = cast(:ID as integer)';

  FQuery
   .Params('ID', aID.ToString)
   .OpenSQL(aSQL);

  if FQuery.DataSet.RecordCount <= 0  then
    Result := False else Result := True;
end;

function TControllerRotas.ClientIsNegative(aID, aValor: integer): boolean;
begin
  var FQuery     := TModelConnectionFactory.New.Query;
  var aSQL :=
    'select '#13+
    's.valor, '#13+
    'c.limite '#13+
    'from saldos s '#13+
    'left join clientes c on c.id = s.cliente_id '#13+
    'where cliente_id = cast(:ID as integer)';

  FQuery
   .Params('ID', aID.ToString)
   .OpenSQL(aSQL);

  var aSaldo      := FQuery.DataSet.FieldByName('valor').AsInteger;
  var aLimite     := FQuery.DataSet.FieldByName('limite').AsInteger * -1;
  var aSaldoAtual := aSaldo - Abs(aValor);

  if aSaldoAtual < aLimite then
    Result := False else Result := True;
end;

constructor TControllerRotas.Create;
begin
  FLog := TModelLog.New;
end;


destructor TControllerRotas.Destroy;
begin
  inherited;
end;

function TControllerRotas.Extrato(aID : integer) : TJSONObject;
begin
  if not ClientIsExists(aID) then
   begin
    raise EHorseException.New
     .Error('Cliente não cadastrado').Status(THTTPStatus.NotFound);
     FLog.LogMensage('Erro: ' + 'Cliente não cadastrado').SalvarLog;
   end;

  var FQuery     := TModelConnectionFactory.New.Query;
  var FQueryPesq := TModelConnectionFactory.New.Query;
  var aJSONObject := TJSONObject.Create;
  Result := aJSONObject;
  var aSQL1 :=
    'select s.valor TOTAL, '#13+
    'CURRENT_TIMESTAMP data_extrato, '#13+
    'c.limite '#13+
    'FROM SALDOS s '#13+
    'left join clientes c on c.id = s.cliente_id '#13+
    'WHERE CLIENTE_ID = cast(:ID as integer)';
  var aSQL2 :=
    'select '#13+
    't.valor, '#13+
    't.tipo, '#13+
    't.descricao, '#13+
    't.realizada_em '#13+
    'from transacoes t '#13+
    'where t.cliente_id = cast(:ID as integer) '#13+
    'order by t.realizada_em desc limit 10';

  FQuery.Params('ID', aID.ToString).OpenSQL(aSQL1);
  FQueryPesq.Params('ID', aID.ToString).OpenSQL(aSQL2);
  Result.AddPair('Saldo:', FQuery.DataSet.ToJSONObject);
  Result.AddPair('ultimas_transacoes:', FQueryPesq.DataSet.ToJSONArray);
end;

function TControllerRotas.InsertTransacao(aID, aValor: integer; aTipo, aDescricao : string) : TJSONObject;
begin
  var FQuery := TModelConnectionFactory.New.Query;

  if not ClientIsExists(aID) then
  begin
    raise EHorseException.New
     .Error('Cliente não cadastrado').Status(THTTPStatus.NotFound);
     FLog.LogMensage('Erro: ' + 'Cliente não cadastrado').SalvarLog;
  end;

  if (UpperCase(aTipo) <> 'd') and (not ClientIsNegative(aID, aValor)) then
   begin
     raise EHorseException.New
      .Error('Saldo insuficiente').Status(THTTPStatus.UnprocessableEntity);
    FLog.LogMensage('Erro: ' + 'Saldo insuficiente').SalvarLog;
   end;

  if aTipo = 'd' then
   FQuery
    .Params('cliente_id_tx', aID.ToString)
    .Params('valor_tx', aValor.ToString)
    .Params('descricao_tx', aDescricao)
    .OpenSQL('SELECT public.debitar(cast(:cliente_id_tx as integer),cast(:valor_tx as integer), :descricao_tx);') else

  if aTipo = 'c' then
   FQuery
    .Params('cliente_id_tx', aID.ToString)
    .Params('valor_tx', aValor.ToString)
    .Params('descricao_tx', aDescricao)
    .OpenSQL('SELECT public.creditar(cast(:cliente_id_tx as integer),cast(:valor_tx as integer), :descricao_tx);');


  var FResult := TModelConnectionFactory.New.Query;
  var aSQL :=
    'select '#13+
    'c.limite, '#13+
    's.valor '#13+
    'from clientes c '#13+
    'left join saldos s ON s.cliente_id = c.id '#13+
    'where c.id = cast(:ID as integer)';

  FResult.Params('ID', aID.ToString).OpenSQL(aSQL);

  Result := FResult.DataSet.ToJSONObject;
end;

end.
