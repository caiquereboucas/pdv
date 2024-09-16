unit View.PDV;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls, Vcl.ExtCtrls,
  Controller.PDV, Vcl.AppEvnts;

type
  TViewPDV = class(TForm)
    PnCabecalho: TPanel;
    PnRodape: TPanel;
    GbTotalPedido: TGroupBox;
    LbTotalPedido: TLabel;
    LvProdutosPedido: TListView;
    PnLancamentoProduto: TPanel;
    LbQuantidade: TLabel;
    LbValorUnitario: TLabel;
    LbProduto: TLabel;
    EdtQuantidade: TEdit;
    EdtValorUnitario: TEdit;
    BtnLancarProduto: TButton;
    EdtProduto: TEdit;
    PnBotoesPedido: TPanel;
    BtnGravarPedido: TButton;
    BtnCancelarPedido: TButton;
    BtnCarregarPedido: TButton;
    LbCliente: TLabel;
    EdtCliente: TEdit;
    procedure DefaultKeyPress(Sender: TObject; var Key: Char);
    procedure BtnLancarProdutoClick(Sender: TObject);
    procedure DefaultDecimalKeyPress(Sender: TObject; var Key: Char);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure EdtClienteChange(Sender: TObject);
    procedure EdtQuantidadeExit(Sender: TObject);
    procedure EdtValorUnitarioExit(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure EdtProdutoExit(Sender: TObject);
    procedure EdtClienteExit(Sender: TObject);
    procedure BtnCarregarPedidoClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure LvProdutosPedidoEnter(Sender: TObject);
    procedure LvProdutosPedidoExit(Sender: TObject);
    procedure LvProdutosPedidoKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure BtnCancelarPedidoClick(Sender: TObject);
    procedure BtnGravarPedidoClick(Sender: TObject);
    procedure LvProdutosPedidoDblClick(Sender: TObject);
  private
    FCtrl: TCtrlPDV;
    FEditingItemIndex: Integer;

    procedure AtualizarTotalPedido;
    function DesformatarDecimal(AValor: string): string;
    procedure LimparLancamentoProduto;
    procedure LimparPedido;
    procedure EditarPedidoItem(AListItem: TListItem);
  public
    { Public declarations }
  end;

var
  ViewPDV: TViewPDV;

implementation

{$R *.dfm}

uses
  DataModulo, Model.Pedido, Model.Produto, Model.Cliente;

procedure TViewPDV.FormCreate(Sender: TObject);
begin
  FCtrl := TCtrlPDV.Create;
  BtnCarregarPedido.Visible := True;
  LimparLancamentoProduto;
  FEditingItemIndex := -1;
end;

procedure TViewPDV.FormDestroy(Sender: TObject);
begin
  FCtrl.Free;
end;

procedure TViewPDV.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key in [VK_DOWN, VK_UP] then
    LvProdutosPedido.SetFocus
end;

procedure TViewPDV.FormShow(Sender: TObject);
begin
  EdtCliente.SetFocus;
end;

procedure TViewPDV.LimparLancamentoProduto;
begin
  EdtProduto.Clear;
  EdtQuantidade.Text := '1,0000';
  EdtValorUnitario.Text := '0,00';
  FCtrl.ClearProdutoAtual;
  FEditingItemIndex := -1;
end;

procedure TViewPDV.LimparPedido;
begin
  FCtrl.ClearPedidoAtual;
  EdtCliente.Clear;
  LimparLancamentoProduto;
  LvProdutosPedido.Items.Clear;
  AtualizarTotalPedido;
end;

procedure TViewPDV.LvProdutosPedidoDblClick(Sender: TObject);
var
  LvItem: TListItem;
begin
  LvItem := LvProdutosPedido.ItemFocused;
  if Assigned(LvItem) then
    EditarPedidoItem(LvItem);
end;

procedure TViewPDV.LvProdutosPedidoEnter(Sender: TObject);
begin
  if LvProdutosPedido.Items.Count > 0 then
    LvProdutosPedido.ItemIndex := Succ(LvProdutosPedido.ItemIndex);
end;

procedure TViewPDV.LvProdutosPedidoExit(Sender: TObject);
begin
  LvProdutosPedido.ItemIndex := -1;
end;

procedure TViewPDV.LvProdutosPedidoKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  LvItem: TListItem;
  Item: TPedidoItem;
  sDescricao: string;
begin
  if (Key = VK_RETURN) then
  begin
    Key := 0;
    LvItem := LvProdutosPedido.ItemFocused;
    if Assigned(LvItem) then
      EditarPedidoItem(LvItem);
  end
  else if (Key = VK_DELETE) then
  begin
    Key := 0;
    LvItem := LvProdutosPedido.ItemFocused;
    sDescricao := LvItem.SubItems.Strings[0];

    if Assigned(LvItem) and (MessageBox(Self.Handle, PChar(Format(
        'Deseja deletar o item %s?', [sDescricao])), 'Atenção',
      MB_TOPMOST + MB_ICONQUESTION + MB_DEFBUTTON2 + MB_YESNO) = mrYes) then
    begin
      Item := LvItem.SubItems.Objects[0] as TPedidoItem;
      FCtrl.RemoverPedidoItem(Item);
      LvProdutosPedido.Items.Delete(LvItem.Index);
      LimparLancamentoProduto;
      EdtProduto.SetFocus;
    end;
  end;
end;

procedure TViewPDV.AtualizarTotalPedido;
begin
  if Assigned(FCtrl.PedidoAtual) then
    LbTotalPedido.Caption := FormatFloat('R$ ,0.00',
      FCtrl.PedidoAtual.ValorTotal)
  else
    LbTotalPedido.Caption := 'R$ 0,00';
end;

procedure TViewPDV.BtnCancelarPedidoClick(Sender: TObject);
var
  iNumPedido: Integer;
  sNumPedido: string;
begin
  InputQuery('Carregar pedido','Preencha o número do pedido', sNumPedido);
  if TryStrToInt(sNumPedido, iNumPedido) then
  begin
    FCtrl.CarregarPedido(iNumPedido);
    FCtrl.ExcluirPedido;
    LimparPedido;
    EdtCliente.SetFocus;
  end;
end;

procedure TViewPDV.BtnCarregarPedidoClick(Sender: TObject);
var
  iNumPedido: Integer;
  sNumPedido: string;
  LvItem: TListItem;
  Item: TPedidoItem;
begin
  InputQuery('Carregar pedido','Preencha o número do pedido', sNumPedido);
  if TryStrToInt(sNumPedido, iNumPedido) then
    try
      LimparPedido;
      FCtrl.CarregarPedido(iNumPedido);
      EdtCliente.Text := FCtrl.PedidoAtual.Cliente.Nome;
      LvProdutosPedido.Items.Clear;
      for Item in FCtrl.PedidoAtual.Itens do
      begin
        LvItem := LvProdutosPedido.Items.Add;
        LvItem.Caption := IntToStr(Item.Produto.Codigo);
        LvItem.SubItems.AddObject(Item.Produto.Descricao, Item);
        LvItem.SubItems.Add(FormatFloat(',0.0000', Item.Quantidade));
        LvItem.SubItems.Add(FormatFloat(',0.00', Item.ValorUnitario));
        LvItem.SubItems.Add(FormatFloat(',0.00', Item.ValorTotal));
      end;
    finally
      AtualizarTotalPedido;
      EdtProduto.SetFocus;
    end;
end;

procedure TViewPDV.BtnLancarProdutoClick(Sender: TObject);
var
  LvItem: TListItem;
  Item: TPedidoItem;
begin
  try
    if FEditingItemIndex < 0 then
    begin
      Item := FCtrl.AddItem(
        StrToFloatDef(DesformatarDecimal(EdtQuantidade.Text), 0),
        StrToCurrDef(DesformatarDecimal(EdtValorUnitario.Text), 0));
      LvItem := LvProdutosPedido.Items.Add;
      LvItem.Caption := IntToStr(Item.Produto.Codigo);
      LvItem.SubItems.AddObject(Item.Produto.Descricao, Item);
      LvItem.SubItems.Add(FormatFloat(',0.0000', Item.Quantidade));
      LvItem.SubItems.Add(FormatFloat(',0.00', Item.ValorUnitario));
      LvItem.SubItems.Add(FormatFloat(',0.00', Item.ValorTotal));
    end
    else
    begin
      LvItem := LvProdutosPedido.Items.Item[FEditingItemIndex];
      Item := LvItem.SubItems.Objects[0] as TPedidoItem;
      Item.Quantidade :=
        StrToFloatDef(DesformatarDecimal(EdtQuantidade.Text), 0);
      Item.ValorUnitario :=
        StrToCurrDef(DesformatarDecimal(EdtValorUnitario.Text), 0);

      LvItem.SubItems.Strings[1] := FormatFloat(',0.0000', Item.Quantidade);
      LvItem.SubItems.Strings[2] := FormatFloat(',0.00', Item.ValorUnitario);
      LvItem.SubItems.Strings[3] := FormatFloat(',0.00', Item.ValorTotal);
    end;

    LimparLancamentoProduto;
    AtualizarTotalPedido;
  finally
    EdtProduto.ReadOnly := False;
    EdtProduto.SetFocus;
  end;
end;

procedure TViewPDV.BtnGravarPedidoClick(Sender: TObject);
begin
  FCtrl.GravarPedido;
  LimparPedido;
  EdtCliente.SetFocus;
end;

procedure TViewPDV.DefaultKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    Key := #0;
    Perform(WM_NEXTDLGCTL, 0, 0);
  end
  else if Key = #27 then
  begin
    Key := #0;
    if FEditingItemIndex >= 0 then
    begin
      LimparLancamentoProduto;
    end
    else if Assigned(FCtrl.PedidoAtual) then
    begin
      LimparPedido;
    end
    else if (MessageBox(Self.Handle, 'Encerrar sistema?', 'Atenção',
      MB_TOPMOST + MB_ICONQUESTION + MB_DEFBUTTON2 + MB_YESNO) = mrYes) then
    begin
      Application.Terminate;
    end;
  end;
end;

function TViewPDV.DesformatarDecimal(AValor: string): string;
begin
  Result := AValor.Replace('.', '', [rfReplaceAll]);
end;

procedure TViewPDV.EditarPedidoItem(AListItem: TListItem);
var
  Item: TPedidoItem;
begin
  Item := AListItem.SubItems.Objects[0] as TPedidoItem;
  EdtProduto.ReadOnly := True;
  EdtProduto.Text := Item.Produto.Descricao;
  EdtQuantidade.Text := FormatFloat(',0.0000', Item.Quantidade);
  EdtValorUnitario.Text := FormatFloat(',0.00', Item.ValorUnitario);
  FCtrl.CarregarPedidoItem(Item);
  EdtProduto.SetFocus;
  FEditingItemIndex := AListItem.Index;
end;

procedure TViewPDV.EdtClienteChange(Sender: TObject);
var
  bClienteIsEmpty: Boolean;
begin
  bClienteIsEmpty := Trim(EdtCliente.Text).IsEmpty;
  BtnCancelarPedido.Visible := bClienteIsEmpty;
  BtnCarregarPedido.Visible := bClienteIsEmpty;
end;

procedure TViewPDV.EdtClienteExit(Sender: TObject);
begin
  if not Trim(EdtCliente.Text).IsEmpty then
    try
      FCtrl.SetCliente(StrToIntDef(EdtCliente.Text, 0));
      EdtCliente.Text := FCtrl.PedidoAtual.Cliente.Nome;
    except
      EdtCliente.Clear;
      EdtCliente.SetFocus;
      raise;
    end;
end;

procedure TViewPDV.EdtProdutoExit(Sender: TObject);
var
  iCodigoProduto: Integer;
begin
  if TryStrToInt(EdtProduto.Text, iCodigoProduto) and (iCodigoProduto > 0) then
    try
      FCtrl.SetProduto(iCodigoProduto);
      EdtProduto.Text := FCtrl.ProdutoAtual.Descricao;
      EdtValorUnitario.Text := FormatFloat(',0.00',
        FCtrl.ProdutoAtual.PrecoVenda);
    except
      EdtProduto.Clear;
      EdtProduto.SetFocus;
      raise;
    end;
end;

procedure TViewPDV.EdtQuantidadeExit(Sender: TObject);
begin
  EdtQuantidade.Text := FormatFloat(',0.0000',
    StrToFloatDef(DesformatarDecimal(EdtQuantidade.Text), 0));
end;

procedure TViewPDV.EdtValorUnitarioExit(Sender: TObject);
begin
  EdtValorUnitario.Text := FormatFloat(',0.00',
    StrToCurrDef(DesformatarDecimal(EdtValorUnitario.Text), 0));
end;

procedure TViewPDV.DefaultDecimalKeyPress(Sender: TObject;
  var Key: Char);
var
  E: TEdit;
begin
  if CharInSet(Key, ['0'..'9', ',', '.', #8]) then
  begin
    if Key = '.' then
      Key := ',';

    E := Sender as TEdit;

    if (Key = ',') and (String(E.Text).Contains(',')) then
      Key := #0;
  end
  else if Key = #13 then
  begin
    Key := #0;
    Perform(WM_NEXTDLGCTL, 0, 0);
  end
  else if Key = #27 then
  begin
    Key := #0;
    if (MessageBox(Self.Handle, 'Encerrar sistema?', 'Atenção',
      MB_TOPMOST + MB_ICONQUESTION + MB_DEFBUTTON2 + MB_YESNO) = mrYes) then
      Application.Terminate;

  end
  else
  begin
    Key := #0;
  end;
end;

end.
