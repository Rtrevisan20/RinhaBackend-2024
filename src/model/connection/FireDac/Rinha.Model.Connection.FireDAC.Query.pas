unit Rinha.Model.Connection.FireDAC.Query;

interface

uses
  Data.Bind.DBScope,
  Data.DB,

  FireDAC.Comp.Client,
  FireDAC.Comp.DataSet,
  FireDAC.Comp.UI,
  FireDAC.DApt,
  FireDAC.DApt.Intf,
  FireDAC.DatS,
  FireDAC.Phys,
  FireDAC.Phys.FB,
  FireDAC.Phys.FBDef,
  FireDAC.Phys.IBBase,
  FireDAC.Phys.Intf,
  FireDAC.Stan.Async,
  FireDAC.Stan.Def,
  FireDAC.Stan.Error,
  FireDAC.Stan.Intf,
  FireDAC.Stan.Option,
  FireDAC.Stan.Param,
  FireDAC.Stan.Pool,
  FireDAC.UI.Intf,

  Rinha.Model.Connection.FireDAC,
  Rinha.Model.Connection.Interfaces,

  System.Generics.Collections,
  System.SysUtils;

type
  TModelConnectionFireDacQuery = class(TInterfacedObject, iModelConnectionQuery)
  private
    FQuery: TFDQuery;
    FDataSet: TObject;
    FIndexConn: Integer;
    FConnection: iModelConnection;
    FParamsList: TDictionary<string, string>;
  public
    constructor Create;
    destructor Destroy; override;
    class function New: iModelConnectionQuery;
    function OpenSQL(aSQL: String): iModelConnectionQuery;
    function ExecuteSQL(aSQL: String): iModelConnectionQuery;
    function OpenTable(aTable: String): iModelConnectionQuery;
    function DataSet: TDataSet;
    function Params(aParam, aValue: string): iModelConnectionQuery;
  end;

implementation

{ TModelConnectionFireDacQuery }

constructor TModelConnectionFireDacQuery.Create;
begin
  if not Assigned(FQuery) then
     FQuery := TFDQuery.Create(nil);

  if not Assigned(FDataSet) then
     FDataSet := FQuery;

  if not Assigned(FConnection) then
  FConnection := TModelConnectionFireDAC.New;

  FIndexConn := FConnection.IdConnection;
  FQuery.Connection := TFDConnection(FConnection.GetConnection(FIndexConn));
end;

function TModelConnectionFireDacQuery.DataSet: TDataSet;
begin
  Result := FQuery;
end;

destructor TModelConnectionFireDacQuery.Destroy;
begin
  if Assigned(FConnection) then
   if FIndexConn <> -1 then
     FConnection.Disconnected(FIndexConn);

  if Assigned(FQuery) then
     FreeAndNil(FQuery);

  if Assigned(FParamsList) then
     FreeAndNil(FParamsList);
  inherited;
end;

function TModelConnectionFireDacQuery.ExecuteSQL(aSQL: String): iModelConnectionQuery;
begin
  Result := Self;
  FQuery.Active := False;
  FQuery.SQL.Clear;
  FQuery.SQL.Add(aSQL);

  if Assigned(FParamsList) then
    for var Param in FParamsList do
      begin
        FQuery.ParamByName(Param.Key).Value := Param.Value;
      end;

  FQuery.ExecSQL;
  if Assigned(FParamsList) then
    FParamsList.Clear;
end;

class function TModelConnectionFireDacQuery.New: iModelConnectionQuery;
begin
  Result := Self.Create;
end;

function TModelConnectionFireDacQuery.OpenSQl(aSQL: String): iModelConnectionQuery;
begin
  Result := Self;
  FQuery.Active := False;
  FQuery.SQL.Clear;
  FQuery.SQL.Add(aSQL);

  if Assigned(FParamsList) then
    for var Param in FParamsList do
      begin
        FQuery.ParamByName(Param.Key).Value := Param.Value;
      end;

  FQuery.Active := True;
  if Assigned(FParamsList) then
    FParamsList.Clear;
end;

function TModelConnectionFireDacQuery.OpenTable(aTable: String): iModelConnectionQuery;
begin
  Result := Self;
  FQuery.SQL.Clear;
  FQuery.SQL.Add('select * from '+aTable);
  FQuery.Active := True;
end;

function TModelConnectionFireDacQuery.Params(aParam, aValue: string): iModelConnectionQuery;
begin
  Result := Self;

  if not Assigned(FParamsList) then
     FParamsList := TDictionary<string, string>.Create;
  FParamsList.Add(aParam, aValue);
end;

end.
