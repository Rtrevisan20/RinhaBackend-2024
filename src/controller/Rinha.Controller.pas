unit Rinha.Controller;

interface

uses
  Horse,
  System.SysUtils,
  System.JSON,
  Rinha.Controller.Rotas;

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
  var aBody := req.Body<TJSONObject>;
  try
    try
     var aID        := req.Params['id'].ToInt64;
     var aValor     := aBody.GetValue<integer>('valor', 0);
     if aValor < 0 then
      begin
        raise Exception.Create('O valor não pode ser menor que 0');
      end;
     var aTipo      := aBody.GetValue<string>('tipo', '');
     var aDescricao := aBody.GetValue<string>('descricao', '');
     Res.Send(aExtrato.InsertTransacao(aID,aValor,aTipo,aDescricao)).Status(200);
    except on E: Exception do
     Res.Send(E.Message).Status(500);
    end;
  finally
    FreeAndNil(aExtrato);
  end;
end;

end.

