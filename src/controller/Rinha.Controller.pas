unit Rinha.Controller;

interface

uses
  Horse,
  System.SysUtils,
  Rinha.Model.Entidades.Clientes;

procedure RegistrarRotas;
procedure ListarClientes(Req: THorseRequest; Res: THorseResponse; Next : TProc);

implementation

procedure RegistrarRotas;
begin
  THorse.Get('/clientes', ListarClientes);
end;

procedure ListarClientes(Req: THorseRequest; Res: THorseResponse; Next : TProc);
begin
  var Cliente :=  TModelEntidadeCliente.Create;
  try
    Res.Send(Cliente.Listar).Status(200);  
  finally
    FreeAndNil(Cliente);
  end;

end;

end.

