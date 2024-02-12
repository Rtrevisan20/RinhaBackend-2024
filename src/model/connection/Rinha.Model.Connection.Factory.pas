unit Rinha.Model.Connection.Factory;

interface

uses
  Rinha.Model.Connection.Interfaces,
  Rinha.Model.Connection.FireDAC,
  Rinha.Model.Connection.FireDAC.Query;

type
  TModelConnectionFactory = class(TInterfacedObject, iModelConnectionFactory)
  private
    FConnection: iModelConnection;
    FQuery: iModelConnectionQuery;
  public
    constructor Create;
    destructor Destroy; override;
    class function New: iModelConnectionFactory;
    function Connection: iModelConnection;
    function Query: iModelConnectionQuery;
  end;

implementation

{ TModelConnectionFactory }

function TModelConnectionFactory.Connection: iModelConnection;
begin
  if not Assigned(FConnection) then
    FConnection := TModelConnectionFireDAC.New;
  Result := FConnection;
end;

constructor TModelConnectionFactory.Create;
begin

end;

destructor TModelConnectionFactory.Destroy;
begin

  inherited;
end;

class function TModelConnectionFactory.New: iModelConnectionFactory;
begin
  Result := Self.Create;
end;

function TModelConnectionFactory.Query: iModelConnectionQuery;
begin
  if not Assigned(FQuery) then
    FQuery := TModelConnectionFireDacQuery.New;
  Result := FQuery;
end;

end.
