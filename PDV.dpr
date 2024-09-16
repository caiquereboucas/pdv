program PDV;

uses
  Vcl.Forms,
  View.PDV in 'src\View.PDV.pas' {ViewPDV},
  Model.Pedido in 'src\Model.Pedido.pas',
  Model.Produto in 'src\Model.Produto.pas',
  Model.Cliente in 'src\Model.Cliente.pas',
  DataModulo in 'src\DataModulo.pas' {DM: TDataModule},
  Controller.PDV in 'src\Controller.PDV.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TDM, DM);
  Application.CreateForm(TViewPDV, ViewPDV);
  Application.Run;
end.
