unit Rinha.Controller;

interface

uses
  Horse,

  Rinha.Model.Connection.Factory,
  Rinha.Model.Connection.Interfaces,
  DataSet.Serialize,
  System.JSON,
  System.SysUtils;

procedure RegistrarRotas;
procedure Extrato(Req: THorseRequest; Res: THorseResponse; Next : TProc);

implementation

procedure RegistrarRotas;
begin
  THorse.Get('/clientes', Extrato);
end;

procedure Extrato(Req: THorseRequest; Res: THorseResponse; Next : TProc);
var
 Query : iModelConnectionQuery;
begin
  Query := TModelConnectionFactory.New.Query;

  Query.OpenSQL('select * from clientes order by id');

  Res.Send(Query.DataSet.ToJSONArray).Status(200);
end;

end.
