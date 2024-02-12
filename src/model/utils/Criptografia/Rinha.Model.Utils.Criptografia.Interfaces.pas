unit Rinha.Model.Utils.Criptografia.Interfaces;

interface

type
  iModelUtilsCryptography = interface
    ['{22FD1BB1-E6AC-47AE-932B-9086178FA8F4}']
    function Encrypt(aValue: String): String;
    function Decrypt(aValue: String): String;
  end;

implementation

end.
