object DM: TDM
  OnCreate = DataModuleCreate
  Height = 480
  Width = 640
  object Connection: TFDConnection
    Params.Strings = (
      'DriverID=MySQL')
    LoginPrompt = False
    Left = 48
    Top = 16
  end
  object FDPhysMySQLDriverLink1: TFDPhysMySQLDriverLink
    Left = 160
    Top = 16
  end
end
