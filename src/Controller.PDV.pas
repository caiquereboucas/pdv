unit Controller.PDV;

interface

uses
  Model.Pedido, Model.Produto, Model.Cliente;

type
  TCtrlPDV = class
  private
    FPedidoAtual: TPedido;
    FProdutoAtual: TProduto;
  public
    function AddItem(AQuantidade: Double; AValorUnitario: Currency): TPedidoItem;
    procedure CarregarPedido(ANumeroPedido: Integer);
    procedure CarregarPedidoItem(const AItem: TPedidoItem);
    procedure ClearPedidoAtual;
    procedure ClearProdutoAtual;
    procedure ExcluirPedido;
    procedure GravarPedido;
    procedure RemoverPedidoItem(AItem: TPedidoItem);
    procedure SetCliente(ACodigoCliente: Integer);
    procedure SetProduto(ACodigoProduto: Integer); overload;
    procedure SetProduto(AProduto: TProduto); overload;

    constructor Create;
    destructor Destroy; override;

    property PedidoAtual: TPedido read FPedidoAtual;
    property ProdutoAtual: TProduto read FProdutoAtual;
  end;

implementation

uses
  DataModulo, System.SysUtils;

{ TCtrlPDV }

constructor TCtrlPDV.Create;
begin
  FPedidoAtual := nil;
  FProdutoAtual := nil;
end;

destructor TCtrlPDV.Destroy;
begin
  if Assigned(FProdutoAtual) then
    FProdutoAtual.Free;

  if Assigned(FPedidoAtual) then
    FPedidoAtual.Free;

  inherited;
end;

procedure TCtrlPDV.ExcluirPedido;
begin
  if Assigned(FPedidoAtual) then
  begin
    FPedidoAtual.Excluir;
    ClearPedidoAtual;
    ClearProdutoAtual;
  end
end;

procedure TCtrlPDV.GravarPedido;
begin
  FPedidoAtual.Salvar;
  ClearPedidoAtual;
  ClearProdutoAtual;
end;

procedure TCtrlPDV.CarregarPedido(ANumeroPedido: Integer);
begin
  ClearPedidoAtual;
  ClearProdutoAtual;
  FPedidoAtual := TPedido.Find(ANumeroPedido);
end;

procedure TCtrlPDV.CarregarPedidoItem(const AItem: TPedidoItem);
begin
  SetProduto(AItem.Produto);
end;

procedure TCtrlPDV.ClearPedidoAtual;
begin
  if Assigned(FPedidoAtual) then
    FreeAndNil(FPedidoAtual);
end;

procedure TCtrlPDV.ClearProdutoAtual;
begin
  if Assigned(FProdutoAtual) then
    FreeAndNil(FProdutoAtual);
end;

procedure TCtrlPDV.SetCliente(ACodigoCliente: Integer);
begin
  if not Assigned(FPedidoAtual) then   
    FPedidoAtual := TPedido.Create;
  FPedidoAtual.Cliente := TCliente.Find(ACodigoCliente);
end;

procedure TCtrlPDV.SetProduto(AProduto: TProduto);
begin
  ClearProdutoAtual;
  FProdutoAtual := TProduto.Create;
  FProdutoAtual.Assign(AProduto);
end;

procedure TCtrlPDV.SetProduto(ACodigoProduto: Integer);
begin
  FProdutoAtual := TProduto.Find(ACodigoProduto);
end;

function TCtrlPDV.AddItem(
  AQuantidade: Double;
  AValorUnitario: Currency): TPedidoItem;
begin
  if not Assigned(FPedidoAtual) then
    raise EUserError.Create('Cliente não encontrado!');
  if not Assigned(FProdutoAtual) then
    raise EUserError.Create('Produto não encontrado!');

  Result := TPedidoItem.Create;
  Result.Produto := FProdutoAtual;
  Result.Quantidade := AQuantidade;
  Result.ValorUnitario := AValorUnitario;
  FPedidoAtual.AddItem(Result);
end;

procedure TCtrlPDV.RemoverPedidoItem(AItem: TPedidoItem);
begin
  FPedidoAtual.RemoveItem(AItem);
end;

end.
