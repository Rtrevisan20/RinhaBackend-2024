unit Rinha.Model.Utils.Criptografia;

interface

uses
  System.SysUtils,
  System.Classes,
  Rinha.Model.Utils.Criptografia.Interfaces;

type
  TModelUtilsCryptography = class(TInterfacedObject, iModelUtilsCryptography)
  private
    function AsciiToInt(aCaracter: Char): integer;
  public
    constructor Create;
    destructor Destroy; override;
    class function New: iModelUtilsCryptography;
    function Encrypt(aValue: String): String;
    function Decrypt(aValue: String): String;
  end;

const
  Key = 6;

implementation

{ TModelUtilsCryptography }

function TModelUtilsCryptography.AsciiToInt(aCaracter: Char): integer;
var
  i:integer;
begin
  i := 0;
  while i < 255 do
  begin
    if Chr(i) = aCaracter then
    Break;
    i := i + 1;
  end;
  Result := i;
end;

constructor TModelUtilsCryptography.Create;
begin

end;

function TModelUtilsCryptography.Decrypt(aValue: String): String;
var
  aCont: integer;
  aRetorno: string;
begin
  if aValue = '' then
  begin
    Result := aValue;
  end else
  begin
    aRetorno := '';
    for aCont := 1 to Length(aValue) do
     aRetorno := aRetorno + Chr(AsciiToInt(aValue[aCont])-Key);
  end;
  Result := aRetorno;
end;

destructor TModelUtilsCryptography.Destroy;
begin

  inherited;
end;

function TModelUtilsCryptography.Encrypt(aValue: String): String;
var
  aCont: integer;
  aRetorno: string;
begin
  if aValue = '' then
  begin
    Result := aValue;
  end
  else
  begin
    aRetorno := '';
    for aCont := 1 to Length(aValue) do
      aRetorno := aRetorno + Chr(AsciiToInt(aValue[aCont])+Key);
  end;
  Result := aRetorno;
end;

class function TModelUtilsCryptography.New: iModelUtilsCryptography;
begin
  Result := Self.Create;
end;

end.
