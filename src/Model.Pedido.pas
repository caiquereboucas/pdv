unit Model.Pedido;

interface

uses
  Generics.Collections, Model.Cliente, Model.Produto;

type
  TPedidoItem = class;

  TPedidoItens = class(TObjectList<TPedidoItem>);

  TPedido = class
  private
    FItens: TPedidoItens;
    FNumero: Integer;
    FEmissao: TDate;
    FCliente: TCliente;
    function GetValorTotal: Currency;
    procedure SetCliente(const ACliente: TCliente);
  public
    property Numero: Integer read FNumero;
    property Emissao: TDate read FEmissao;
    property ValorTotal: Currency read GetValorTotal;
    property Cliente: TCliente read FCliente write SetCliente;
    property Itens: TPedidoItens read FItens;

    constructor Create;
    destructor Destroy; override;

    procedure AddItem(APedidoItem: TPedidoItem);
    procedure RemoveItem(APedidoItem: TPedidoItem);
    procedure Salvar;
    procedure Excluir;
    class function Find(ANumeroPedido: Integer): TPedido;
  end;

  TPedidoItem = class
  private
    FValorUnitario: Currency;
    FId: Integer;
    FQuantidade: Double;
    FProduto: TProduto;
    function GetValorTotal: Currency;
    procedure SetQuantidade(const Value: Double);
    procedure SetValorUnitario(const Value: Currency);
    procedure SetProduto(const Value: TProduto);
  public
    constructor Create;
    destructor Destroy; override;
    property Id: Integer read FId;
    property Produto: TProduto read FProduto write SetProduto;
    property Quantidade: Double read FQuantidade write SetQuantidade;
    property ValorUnitario: Currency read FValorUnitario write SetValorUnitario;
    property ValorTotal: Currency read GetValorTotal;

    procedure Salvar(ANumeroPedido: Integer);
  end;

implementation

uses
  DataModulo, FireDAC.Comp.DataSet, FireDAC.Comp.Client, SysUtils, System.Math;

{ TPedido }

constructor TPedido.Create;
begin
  FCliente := nil;
  FItens := TPedidoItens.Create;
end;

destructor TPedido.Destroy;
begin
  FItens.Free;
  if Assigned(FCliente) then
    FCliente.Free;
  inherited;
end;

procedure TPedido.Excluir;
var
  Query: TFDQuery;
begin
  if FNumero = 0 then
    Exit;

  Query := DM.BuildQuery;
  try
    Query.ExecSQL(
      'DELETE FROM TB_PEDIDOS WHERE NUMERO_PK = :NUMERO_PK',
      [FNumero]);
  finally
    Query.Free;
  end;
end;

class function TPedido.Find(ANumeroPedido: Integer): TPedido;
var
  Query: TFDQuery;
  Item: TPedidoItem;
begin
  if ANumeroPedido = 0 then
    Exit(nil);

  Query := DM.BuildQuery;
  try
    Query.Open(
      'SELECT EMISSAO, CODIGO_CLIENTE_FK, VALOR_TOTAL '+
      'FROM TB_PEDIDOS WHERE NUMERO_PK = :NUMERO_PK ',
      [ANumeroPedido]);

    if Query.Eof then
      raise EUserError.CreateFmt('Pedido não encontrado! (%d)', [ANumeroPedido]);

    Result := TPedido.Create;
    Result.FNumero := ANumeroPedido;
    Result.FEmissao := Query.FieldByName('EMISSAO').AsDatetime;
    Result.FCliente := TCLiente.Create;
    Result.FCliente.Assign(TCliente.Find(Query.FieldByName('CODIGO_CLIENTE_FK').AsInteger));

    Query.Close;
    Query.SQL.Clear;
    Query.Open(
      'SELECT '+
        'ID_PK, CODIGO_PRODUTO_FK, QUANTIDADE, '+
        'VALOR_UNITARIO, VALOR_TOTAL '+
      'FROM TB_PEDIDO_ITENS '+
      'WHERE NUMERO_PEDIDO_FK = :NUMERO_PEDIDO_FK', [Result.FNumero]);

    while not Query.Eof do
    begin
      Item := TPedidoItem.Create;
      Item.FId := Query.FieldByName('ID_PK').AsInteger;
      Item.FProduto := TProduto.Create;
      Item.FProduto.Assign(
        TProduto.Find(
          Query.FieldByName('CODIGO_PRODUTO_FK').AsInteger));
      Item.FQuantidade := Query.FieldByName('QUANTIDADE').AsFloat;
      Item.FValorUnitario := Query.FieldByName('VALOR_UNITARIO').AsCurrency;
      Result.AddItem(Item);
      Query.Next;
    end;
  finally
    Query.Free;
  end;
end;

function TPedido.GetValorTotal: Currency;
var
  Item: TPedidoItem;
begin
  Result := 0;
  for Item in FItens do
    Result := Result + Item.ValorTotal;
end;

procedure TPedido.Salvar;
var
  Query: TFDQuery;
  Item: TPedidoItem;
begin
  Query := DM.BuildQuery;
  try
    DM.Connection.StartTransaction;
    try
      if FNumero = 0 then
      begin
        Query.ExecSQL(
          'INSERT INTO TB_PEDIDOS(EMISSAO, CODIGO_CLIENTE_FK, VALOR_TOTAL) '+
          'VALUES(:EMISSAO, :CODIGO_CLIENTE_FK, :VALOR_TOTAL) ',
          [Now, FCliente.Codigo, GetValorTotal]);

        FNumero := DM.GetLastId;

        for Item in FItens do
          Item.Salvar(FNumero);
      end
      else
      begin
        Query.ExecSQL(
          'UPDATE TB_PEDIDOS SET '+
            'CODIGO_CLIENTE_FK = :CODIGO_CLIENTE_FK, '+
            'VALOR_TOTAL = :VALOR_TOTAL '+
          'WHERE NUMERO_PK = :NUMERO_PK',
          [FCliente.Codigo, GetValorTotal, FNumero]);

        Query.Close;
        Query.SQL.Clear;
        for Item in FItens do
          Item.Salvar(FNumero);
      end;
      DM.Connection.Commit;
    except
      on Ex: Exception do
      begin
        DM.Connection.Rollback;
        if Ex.Message.Contains('deadlock') then
        begin
          Randomize;
          Sleep(RandomRange(100, 1000));
          raise EUserError.Create('Tente novamente.');
        end
        else
        begin
          raise;
        end;
      end;
    end;
  finally
    Query.Free;
  end;
end;

procedure TPedido.SetCliente(const ACliente: TCliente);
begin
  if Assigned(FCliente) then
    FCliente.Free;

  FCliente := TCliente.Create;
  FCliente.Assign(ACliente);
end;


procedure TPedido.AddItem(APedidoItem: TPedidoItem);
begin
  FItens.Add(APedidoItem);
end;

procedure TPedido.RemoveItem(APedidoItem: TPedidoItem);
begin
  FItens.Remove(APedidoItem);
end;

{ TPedidoItem }

constructor TPedidoItem.Create;
begin
  FProduto := nil;
end;

destructor TPedidoItem.Destroy;
begin
  FProduto.Free;

  inherited;
end;

function TPedidoItem.GetValorTotal: Currency;
begin
  Result := FQuantidade * FValorUnitario;
end;

procedure TPedidoItem.Salvar(ANumeroPedido: Integer);
var
  Query: TFDQuery;
begin
  Query := DM.BuildQuery;
  try
    if FId = 0 then
    begin
      Query.ExecSQL(
      'INSERT INTO TB_PEDIDO_ITENS('+
        'NUMERO_PEDIDO_FK, CODIGO_PRODUTO_FK, QUANTIDADE, '+
        'VALOR_UNITARIO, VALOR_TOTAL) '+
      'VALUES('+
        ':NUMERO_PEDIDO_FK, :CODIGO_PRODUTO_FK, :QUANTIDADE, '+
        ':VALOR_UNITARIO, :VALOR_TOTAL) ',
      [ANumeroPedido, FProduto.Codigo, FQuantidade, FValorUnitario, GetValorTotal]);
      FId := DM.GetLastId;
    end
    else
    begin
      Query.ExecSQL(
        'UPDATE TB_PEDIDO_ITENS SET '+
          'QUANTIDADE = :QUANTIDADE, '+
          'VALOR_UNITARIO = :VALOR_UNITARIO, '+
          'VALOR_TOTAL = :VALOR_TOTAL '+
        'WHERE ID_PK = :ID_PK',
        [FQuantidade, FValorUnitario, GetValorTotal, FId]);
    end;
  finally
    Query.Free;
  end;
end;

procedure TPedidoItem.SetProduto(const Value: TProduto);
begin
  if Assigned(FProduto) then
    FProduto.Free;

  FProduto := TProduto.Create;
  FProduto.Assign(Value);
end;

procedure TPedidoItem.SetQuantidade(const Value: Double);
begin
  if Value <= 0 then
    raise EUserError.CreateFmt('Quantidade inválida! (%d)', [Value]);

  FQuantidade := Value;
end;

procedure TPedidoItem.SetValorUnitario(const Value: Currency);
begin
  if Value <= 0 then
    raise EUserError.CreateFmt('Valor inválido! (%d)', [Value]);

  FValorUnitario := Value;
end;

end.
