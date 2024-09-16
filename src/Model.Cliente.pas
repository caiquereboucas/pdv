unit Model.Cliente;

interface

type
  TCliente = class
  private
    FUF: string;
    FCodigo: Integer;
    FNome: string;
    FCidade: string;
  public
    property Codigo: Integer read FCodigo;
    property Nome: string read FNome;
    property Cidade: string read FCidade;
    property UF: string read FUF;

    procedure Assign(ACliente: TCliente);
    procedure Clear;
    class function Find(ACodigoCliente: Integer): TCliente;
  end;

implementation

uses
  DataModulo, FireDAC.Comp.DataSet, FireDAC.Comp.Client;

{ TCliente }

procedure TCliente.Assign(ACliente: TCliente);
begin
  if Assigned(ACliente) then
  begin
    FUF := ACliente.FUF;
    FCodigo := ACliente.FCodigo;
    FNome := ACliente.FNome;
    FCidade := ACliente.FCidade;
  end
  else
  begin
    Clear;
  end;
end;

procedure TCliente.Clear;
begin
  FUF := '';
  FCodigo := 0;
  FNome := '';
  FCidade := '';
end;

class function TCliente.Find(ACodigoCliente: Integer): TCliente;
var
  Query: TFDQuery;
begin
  Query := DM.BuildQuery;
  try
    Query.Open(
      'SELECT CODIGO, NOME, CIDADE, UF '+
      'FROM TB_CLIENTES '+
      'WHERE CODIGO = :CODIGO', [ACodigoCliente]);

    if Query.Eof then
      raise EUserError.CreateFmt(
        'Cliente não encontrado! (%d)', [ACodigoCliente]);

    Result := TCliente.Create;
    Result.FCodigo := Query.FieldByName('CODIGO').AsInteger;
    Result.FNome := Query.FieldByName('NOME').AsString;
    Result.FCidade := Query.FieldByName('CIDADE').AsString;
    Result.FUF := Query.FieldByName('UF').AsString;
  finally
    Query.Free;
  end;
end;

end.
