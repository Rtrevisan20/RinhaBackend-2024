unit Rinha.Model.Utils.Configuracoes.Interfaces;

interface

type
  iModelUtilsSettingsParams = interface;

  iModelUtilsSettings = interface
    ['{6B363394-B0F3-4E5C-A867-F450EF7DE4DC}']
    function SaveSettings: iModelUtilsSettings;
    function LoadingSettings: iModelUtilsSettings;
    function Params: iModelUtilsSettingsParams;
  end;

  iModelUtilsSettingsParams = interface
    ['{064FFEB9-7B3C-4829-B462-D6D3236CC071}']
    function DataBase: string; overload;
    function DataBase(aValue: string): iModelUtilsSettingsParams; overload;
    function UserName: string; overload;
    function UserName(aValue: string): iModelUtilsSettingsParams; overload;
    function Password: string; overload;
    function Password(aValue: string): iModelUtilsSettingsParams; overload;
    function Protocol: string; overload;
    function Protocol(aValue: string): iModelUtilsSettingsParams; overload;
    function HostName: string; overload;
    function HostName(aValue: string): iModelUtilsSettingsParams; overload;
    function Port: string; overload;
    function Port(aValue: string): iModelUtilsSettingsParams; overload;
    function &End: iModelUtilsSettings;
  end;

implementation

end.
