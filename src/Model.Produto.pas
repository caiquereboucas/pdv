unit Model.Produto;

interface

type
  TProduto = class
  private
    FDescricao: string;
    FCodigo: Integer;
    FPrecoVenda: Currency;
  public
    property Codigo: Integer read FCodigo;
    property Descricao: string read FDescricao;
    property PrecoVenda: Currency read FPrecoVenda;

    procedure Assign(AProduto: TProduto);
    procedure Clear;
    class function Find(ACodigoProduto: Integer): TProduto;
  end;

implementation

uses
  DataModulo, FireDAC.Comp.DataSet, FireDAC.Comp.Client;

{ TProduto }

procedure TProduto.Assign(AProduto: TProduto);
begin
  if Assigned(AProduto) then
  begin
    FCodigo := AProduto.FCodigo;
    FDescricao := AProduto.FDescricao;
    FPrecoVenda := AProduto.FPrecoVenda;
  end
  else
  begin
    Clear;
  end;
end;

procedure TProduto.Clear;
begin
  FCodigo := 0;
  FDescricao := '';
  FPrecoVenda := 0;
end;

class function TProduto.Find(ACodigoProduto: Integer): TProduto;
var
  Query: TFDQuery;
begin
  Query := DM.BuildQuery;
  try
    Query.Open(
      'SELECT CODIGO_PK, DESCRICAO, PRECO_VENDA '+
      'FROM TB_PRODUTOS '+
      'WHERE CODIGO_PK = :CODIGO_PK', [ACodigoProduto]);

    if Query.Eof then
      raise EUserError.CreateFmt(
        'Produto não encontrado! (%d)', [ACodigoProduto]);

    Result := TProduto.Create;
    Result.FCodigo := Query.FieldByName('CODIGO_PK').AsInteger;
    Result.FDescricao := Query.FieldByName('DESCRICAO').AsString;
    Result.FPrecoVenda := Query.FieldByName('PRECO_VENDA').AsCurrency;
  finally
    Query.Free;
  end;
end;

end.
