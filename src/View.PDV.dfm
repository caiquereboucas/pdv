object ViewPDV: TViewPDV
  Left = 0
  Top = 0
  BorderStyle = bsSingle
  Caption = 'Pedido de venda'
  ClientHeight = 442
  ClientWidth = 628
  Color = 16448250
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Arial'
  Font.Style = []
  KeyPreview = True
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  OnShow = FormShow
  TextHeight = 16
  object PnCabecalho: TPanel
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 622
    Height = 150
    Align = alTop
    BevelOuter = bvNone
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 0
    object PnLancamentoProduto: TPanel
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 427
      Height = 144
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 0
      ExplicitWidth = 423
      ExplicitHeight = 125
      DesignSize = (
        427
        144)
      object LbQuantidade: TLabel
        Left = 0
        Top = 90
        Width = 74
        Height = 16
        Caption = 'Quantidade'
      end
      object LbValorUnitario: TLabel
        Left = 121
        Top = 87
        Width = 114
        Height = 16
        Caption = 'Valor unit'#225'rio (R$)'
      end
      object LbProduto: TLabel
        Left = 0
        Top = 45
        Width = 50
        Height = 16
        Caption = 'Produto'
      end
      object LbCliente: TLabel
        Left = 0
        Top = 0
        Width = 45
        Height = 16
        Caption = 'Cliente'
      end
      object EdtQuantidade: TEdit
        Left = 0
        Top = 105
        Width = 115
        Height = 24
        Alignment = taRightJustify
        TabOrder = 2
        OnExit = EdtQuantidadeExit
        OnKeyPress = DefaultDecimalKeyPress
      end
      object EdtValorUnitario: TEdit
        Left = 121
        Top = 105
        Width = 115
        Height = 24
        Alignment = taRightJustify
        TabOrder = 3
        OnExit = EdtValorUnitarioExit
        OnKeyPress = DefaultDecimalKeyPress
      end
      object BtnLancarProduto: TButton
        AlignWithMargins = True
        Left = 242
        Top = 105
        Width = 28
        Height = 24
        Caption = '+'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -19
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 4
        OnClick = BtnLancarProdutoClick
        OnKeyPress = DefaultKeyPress
      end
      object EdtProduto: TEdit
        Left = 0
        Top = 60
        Width = 270
        Height = 24
        MaxLength = 45
        TabOrder = 1
        OnExit = EdtProdutoExit
        OnKeyPress = DefaultKeyPress
      end
      object EdtCliente: TEdit
        AlignWithMargins = True
        Left = 0
        Top = 15
        Width = 270
        Height = 24
        Anchors = [akLeft, akTop, akRight]
        CharCase = ecUpperCase
        MaxLength = 45
        TabOrder = 0
        OnChange = EdtClienteChange
        OnExit = EdtClienteExit
        OnKeyPress = DefaultKeyPress
      end
    end
    object PnBotoesPedido: TPanel
      AlignWithMargins = True
      Left = 436
      Top = 3
      Width = 183
      Height = 144
      Align = alRight
      BevelOuter = bvNone
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -19
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 1
      ExplicitLeft = 432
      ExplicitHeight = 125
      object BtnGravarPedido: TButton
        AlignWithMargins = True
        Left = 3
        Top = 106
        Width = 177
        Height = 35
        Align = alBottom
        Caption = 'Gravar pedido'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        OnClick = BtnGravarPedidoClick
        OnKeyPress = DefaultKeyPress
        ExplicitLeft = 0
      end
      object BtnCancelarPedido: TButton
        AlignWithMargins = True
        Left = 3
        Top = 65
        Width = 177
        Height = 35
        Align = alBottom
        Caption = 'Cancelar pedido'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
        OnClick = BtnCancelarPedidoClick
        OnKeyPress = DefaultKeyPress
        ExplicitLeft = 0
      end
      object BtnCarregarPedido: TButton
        AlignWithMargins = True
        Left = 3
        Top = 24
        Width = 177
        Height = 35
        Align = alBottom
        Caption = 'Carregar pedido'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 2
        OnClick = BtnCarregarPedidoClick
        OnKeyPress = DefaultKeyPress
        ExplicitTop = 5
      end
    end
  end
  object PnRodape: TPanel
    AlignWithMargins = True
    Left = 3
    Top = 364
    Width = 622
    Height = 75
    Align = alBottom
    BevelOuter = bvNone
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 1
    ExplicitTop = 363
    ExplicitWidth = 618
    object GbTotalPedido: TGroupBox
      AlignWithMargins = True
      Left = 434
      Top = 3
      Width = 185
      Height = 69
      Align = alRight
      Caption = 'Total do pedido'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 0
      ExplicitLeft = 430
      object LbTotalPedido: TLabel
        Left = 2
        Top = 18
        Width = 181
        Height = 49
        Align = alClient
        Alignment = taRightJustify
        Caption = 'R$ 0,00'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -24
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        Layout = tlCenter
        ExplicitLeft = 100
        ExplicitWidth = 83
        ExplicitHeight = 29
      end
    end
  end
  object LvProdutosPedido: TListView
    AlignWithMargins = True
    Left = 3
    Top = 159
    Width = 622
    Height = 199
    Align = alClient
    Columns = <
      item
        Caption = 'C'#243'digo'
        Width = 60
      end
      item
        Caption = 'Descri'#231#227'o'
        Width = 285
      end
      item
        Alignment = taRightJustify
        Caption = 'Quantidade'
        Width = 80
      end
      item
        Alignment = taRightJustify
        Caption = 'Vlr. unit'#225'rio'
        Width = 80
      end
      item
        Alignment = taRightJustify
        Caption = 'Vlr. total'
        Width = 80
      end>
    ReadOnly = True
    RowSelect = True
    TabOrder = 2
    ViewStyle = vsReport
    OnDblClick = LvProdutosPedidoDblClick
    OnEnter = LvProdutosPedidoEnter
    OnExit = LvProdutosPedidoExit
    OnKeyDown = LvProdutosPedidoKeyDown
    ExplicitTop = 140
    ExplicitWidth = 618
    ExplicitHeight = 217
  end
end
