unit Rinha.Model.Connection.Interfaces;

interface

uses
  Data.DB;

type
  iModelConnection = interface
    ['{EB5629C3-EDEE-4D77-A0E6-F057EA795DFA}']
    function Connection : TCustomConnection;
    function IdConnection : integer;
    function Disconnected ( aIndexConn : integer) : iModelConnection;
    function GetConnection ( aIndexConn : integer ): TCustomConnection;
  end;

  iModelConnectionQuery = interface
    ['{4A49C2B3-BACB-4D99-853A-853166EF7BE4}']
    function OpenSQl ( aSQL : String ) : iModelConnectionQuery;
    function ExecuteSQL ( aSQL : String ) : iModelConnectionQuery;
    function OpenTable  ( aTable : String ) : iModelConnectionQuery;
    function DataSet : TDataSet;
    function Params ( aParam, aValue : string) : iModelConnectionQuery;
  end;

  iModelConnectionFactory = interface
    ['{B5C221CA-59A5-4C96-8FE4-58F59AA8A681}']
    function Connection : iModelConnection;
    function Query : iModelConnectionQuery;
  end;

implementation

end.
