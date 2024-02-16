unit Rinha.Controller;

interface

uses
  Horse,

  Rinha.Controller.Rotas,

  System.JSON,
  System.SysUtils;

procedure RegistrarRotas;
procedure Extrato(Req: THorseRequest; Res: THorseResponse; Next : TProc);
procedure Transacoes(Req: THorseRequest; Res: THorseResponse; Next : TProc);

implementation

procedure RegistrarRotas;
begin
  THorse.Get('/clientes/:id/extrato', Extrato);
  THorse.Post('/clientes/:id/transacoes', Transacoes);
end;

procedure Extrato(Req: THorseRequest; Res: THorseResponse; Next : TProc);
begin
  var aExtrato :=  TControllerRotas.Create;
  try
    Res.Send(aExtrato.Extrato(req.Params['id'].ToInt64)).Status(200);
  finally
    FreeAndNil(aExtrato);
  end;
end;

procedure Transacoes(Req: THorseRequest; Res: THorseResponse; Next : TProc);
begin
  var aExtrato :=  TControllerRotas.Create;
  var aBody    := req.Body<TJSONObject>;
  try
   var aID        := req.Params['id'].ToInt64;
   var aValor     := aBody.GetValue<integer>('valor', 0);
   var aTipo      := aBody.GetValue<string>('tipo', '');
   var aDescricao := aBody.GetValue<string>('descricao', '');
   Res.Send(aExtrato.InsertTransacao(aID,aValor,aTipo,aDescricao)).Status(200);
  finally
    FreeAndNil(aExtrato);
  end;
end;

end.

