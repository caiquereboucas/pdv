unit DataModulo;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.VCLUI.Wait,
  Data.DB, FireDAC.Comp.Client, FireDAC.Phys.MySQLDef, FireDAC.Phys.MySQL,
  FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt,
  FireDAC.Comp.DataSet;

type
  EUserError = class(Exception);

  TDM = class(TDataModule)
    Connection: TFDConnection;
    FDPhysMySQLDriverLink1: TFDPhysMySQLDriverLink;
    procedure DataModuleCreate(Sender: TObject);
  private
    procedure ConfigureDB;
  public
    function BuildQuery: TFDQuery;
    function GetLastId: Integer;
  end;

var
  DM: TDM;

implementation

uses
  Winapi.Windows, System.IniFiles, Dialogs;

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

{ TDM }

procedure TDM.DataModuleCreate(Sender: TObject);
begin
  ConfigureDB;
end;

function TDM.GetLastId: Integer;
var
  Query: TFDQuery;
begin
  Query := BuildQuery;
  try
    Query.Open('SELECT LAST_INSERT_ID()', []);
    if not Query.Eof then
      Result := Query.Fields[0].AsInteger
    else
      Result := 0;
  finally
    Query.Free;
  end;
end;

function TDM.BuildQuery: TFDQuery;
begin
  Result := TFDQuery.Create(nil);
  Result.Connection := Connection;
end;

procedure TDM.ConfigureDB;
var
  IniFile: TIniFile;
  DLLPath: string;
begin
  IniFile := TIniFile.Create(GetCurrentDir()+'\dbconfig.ini');
  try
    try
      DLLPath := IniFile.ReadString('MySQL', 'DLLPath', '');
      if DLLPath <> '' then
      begin
        if FileExists(DLLPath) then
          FDPhysMySQLDriverLink1.VendorLib := DLLPath
        else
          raise Exception.CreateFmt('DLL não encontrado: %s', [DLLPath]);
      end;

      Connection.DriverName := IniFile.ReadString('Database', 'DriverID', 'mysql');
      Connection.Params.Database := IniFile.ReadString('Database', 'Database', '');
      Connection.Params.UserName := IniFile.ReadString('Database', 'User_Name', '');
      Connection.Params.Password := IniFile.ReadString('Database', 'Password', '');
      Connection.Params.Add('Server=' + IniFile.ReadString('Database', 'Server', 'localhost'));
      Connection.Params.Add('Port=' + IniFile.ReadString('Database', 'Port', '3306'));

      Connection.Connected := True;
    except
      on Ex: Exception do
        ShowMessage('Falha ao se conectar no banco de dados: '+Ex.Message);
    end;
  finally
    IniFile.Free;
    Connection.Connected := False;
  end;
end;

end.
