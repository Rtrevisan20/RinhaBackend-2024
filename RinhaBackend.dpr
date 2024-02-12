program RinhaBackend;

{$APPTYPE CONSOLE}
{$R *.res}

uses
  Horse,
  Rinha.Model.Connection.Factory in 'src\model\connection\Rinha.Model.Connection.Factory.pas',
  Rinha.Model.Connection.Interfaces in 'src\model\connection\Rinha.Model.Connection.Interfaces.pas',
  Rinha.Model.Connection.FireDAC in 'src\model\connection\FireDac\Rinha.Model.Connection.FireDAC.pas',
  Rinha.Model.Connection.FireDAC.Query in 'src\model\connection\FireDac\Rinha.Model.Connection.FireDAC.Query.pas',
  Rinha.Model.Utils.Configuracoes.Interfaces in 'src\model\utils\Configuracoes\Rinha.Model.Utils.Configuracoes.Interfaces.pas',
  Rinha.Model.Utils.Configuracoes.Params in 'src\model\utils\Configuracoes\Rinha.Model.Utils.Configuracoes.Params.pas',
  Rinha.Model.Utils.Configuracoes in 'src\model\utils\Configuracoes\Rinha.Model.Utils.Configuracoes.pas',
  Rinha.Model.Utils.Criptografia.Interfaces in 'src\model\utils\Criptografia\Rinha.Model.Utils.Criptografia.Interfaces.pas',
  Rinha.Model.Utils.Criptografia in 'src\model\utils\Criptografia\Rinha.Model.Utils.Criptografia.pas',
  Rinha.Model.Log.Interfaces in 'src\model\utils\log\Rinha.Model.Log.Interfaces.pas',
  Rinha.Model.Log in 'src\model\utils\log\Rinha.Model.Log.pas';

begin
  THorse.Get('/ping',
    procedure(Req: THorseRequest; Res: THorseResponse)
    begin
      Res.Send(TModelUtilsCryptography.New.Encrypt('Masterkey'));
    end);

  THorse.Listen(9000);
end.
