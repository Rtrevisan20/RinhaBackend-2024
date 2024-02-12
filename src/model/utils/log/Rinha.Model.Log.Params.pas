unit Rinha.Model.Log.Params;

interface

uses
  System.SysUtils,
  System.Classes,
  Rinha.Model.Log.Interfaces;

type
  TModelLogParams = class(TInterfacedObject, iModelLogParams)
  private
    [weak]
    FParent: iModelLog;

    FMensagem: string;
  public
    constructor Create(Parent: iModelLog);
    destructor Destroy; override;
    class function New(Parent: iModelLog): iModelLogParams;
    function &End: iModelLog;
    function LogMensage: string; overload;
    function LogMensage(aValue: string): iModelLogParams; overload;
  end;

implementation

{ TModelLogParams }

function TModelLogParams.&End: iModelLog;
begin
  Result := FParent;
end;

function TModelLogParams.LogMensage(aValue: string): iModelLogParams;
begin
  Result := Self;
  FMensagem := aValue;
end;

function TModelLogParams.LogMensage: string;
begin
  Result := FMensagem;
end;

constructor TModelLogParams.Create(Parent: iModelLog);
begin
  FParent := Parent;
end;

destructor TModelLogParams.Destroy;
begin

  inherited;
end;

class function TModelLogParams.New(Parent: iModelLog): iModelLogParams;
begin
  Result := Self.Create(Parent);
end;

end.
