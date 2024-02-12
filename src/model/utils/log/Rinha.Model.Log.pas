unit Rinha.Model.Log;

interface

uses
  System.SysUtils,
  System.Classes,
  Rinha.Model.Log.Interfaces;

type
  TModelLog = class(TInterfacedObject, iModelLog)
  private
    FLista: TStringList;
    FArq: TextFile;
    FPath: string;
    FLogMensage: string;
    procedure SetLog;
  public
    constructor Create;
    destructor Destroy; override;
    class function New: iModelLog;
    function SalvarLog: iModelLog;
    function LogMensage(aValue: string): iModelLog;
  end;

implementation

{ TModelLog }

constructor TModelLog.Create;
begin
  FPath := ExtractFilePath(ParamStr(0)) + 'RinhaLog.log';
  SetLog;
end;

destructor TModelLog.Destroy;
begin

  inherited;
end;

function TModelLog.LogMensage(aValue: string): iModelLog;
begin
  Result := Self;
  FLogMensage := aValue;
end;

class function TModelLog.New: iModelLog;
begin
  Result := Self.Create;
end;

function TModelLog.SalvarLog: iModelLog;
begin
  Result := Self;
  FLista.Add(DateTimeToStr(now)+' '+ FLogMensage);
  FLista.SaveToFile(FPath);
end;

procedure TModelLog.SetLog;
begin
  FLista := TStringList.Create;
  if FileExists(FPath) then
  begin
    FLista.LoadFromFile(FPath);
  end
  else
  begin
   AssignFile(FArq, FPath);
   Rewrite(FArq, FPath); //Seto o arquivo a ser criado
   Append(FArq); //Crio o arquivo
   CloseFile(FArq); // salvo o arquivo criado
   FLista.LoadFromFile(FPath);
  end;
end;

end.
