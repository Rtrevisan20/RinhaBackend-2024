unit Rinha.Model.Log.Interfaces;

interface

type

  iModelLog = interface
    ['{EB0BCBCE-01FB-4A86-9CD4-83CF0B665EE2}']
    function SalvarLog: iModelLog;
    function LogMensage(aValue: string): iModelLog;
  end;


implementation

end.
