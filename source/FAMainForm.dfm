object FAmainF: TFAmainF
  Left = 291
  Top = 266
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Frank Audio Virtual Room'
  ClientHeight = 471
  ClientWidth = 693
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  TextHeight = 13
  object Lb_Drivername: TLabel
    Left = 54
    Top = 8
    Width = 52
    Height = 22
    Alignment = taRightJustify
    Caption = 'Driver:'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -18
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object Lb_Channels: TLabel
    Left = 19
    Top = 82
    Width = 87
    Height = 22
    Alignment = taRightJustify
    Caption = 'Out  Chan:'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -18
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object LbFreq: TLabel
    Left = 7
    Top = 320
    Width = 50
    Height = 13
    Caption = 'Frequency'
  end
  object Label3: TLabel
    Left = 11
    Top = 44
    Width = 95
    Height = 22
    Alignment = taRightJustify
    Caption = 'Input Chan:'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -18
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object Label4: TLabel
    Left = 36
    Top = 228
    Width = 65
    Height = 22
    Caption = 'IP envio'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -18
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object Label5: TLabel
    Left = 265
    Top = 223
    Width = 50
    Height = 22
    Caption = 'IP.Rec'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -18
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object Label6: TLabel
    Left = 71
    Top = 262
    Width = 32
    Height = 22
    Caption = 'Port'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -18
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object Label7: TLabel
    Left = 269
    Top = 253
    Width = 32
    Height = 22
    Caption = 'Port'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -18
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object LabelStatus: TLabel
    Left = 8
    Top = 289
    Width = 49
    Height = 22
    Caption = 'Status'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -18
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object Label1: TLabel
    Left = 367
    Top = 41
    Width = 121
    Height = 22
    Caption = 'Bit Rate Kb/sec'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -18
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object Label2: TLabel
    Left = 367
    Top = 103
    Width = 82
    Height = 22
    Caption = 'Protocol'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -18
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object DriverCombo: TComboBox
    Left = 112
    Top = 8
    Width = 233
    Height = 30
    Style = csDropDownList
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -18
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    OnChange = DriverComboChange
  end
  object Bt_CP: TButton
    Left = 112
    Top = 115
    Width = 121
    Height = 31
    Caption = 'Control Panel'
    Enabled = False
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -18
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    OnClick = Bt_CPClick
  end
  object OutputChannelBox: TComboBox
    Left = 112
    Top = 79
    Width = 233
    Height = 30
    Style = csDropDownList
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -18
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
    OnChange = OutputChannelBoxChange
  end
  object Bt_Play: TButton
    Left = 552
    Top = 187
    Width = 121
    Height = 40
    Caption = 'Start Audio'
    Default = True
    Enabled = False
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -18
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 3
    OnClick = Bt_PlayClick
  end
  object InputChannelBox: TComboBox
    Left = 112
    Top = 44
    Width = 233
    Height = 30
    Style = csDropDownList
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -18
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 4
    OnChange = InputChannelBoxChange
  end
  object EditIPOut: TEdit
    Left = 107
    Top = 220
    Width = 137
    Height = 30
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -18
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 5
    Text = '192.168.0.16'
  end
  object EditIpIn: TEdit
    Left = 328
    Top = 220
    Width = 153
    Height = 30
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -18
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 6
    Text = '192.168.0.16'
  end
  object EditPortOut: TEdit
    Left = 112
    Top = 254
    Width = 73
    Height = 30
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -18
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 7
    Text = '22134'
  end
  object Memo1: TMemo
    Left = 8
    Top = 320
    Width = 665
    Height = 143
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -18
    Font.Name = 'Tahoma'
    Font.Style = []
    Lines.Strings = (
      'Memo1')
    ParentFont = False
    ScrollBars = ssVertical
    TabOrder = 8
  end
  object CBEnviar: TCheckBox
    Left = 112
    Top = 197
    Width = 97
    Height = 17
    Caption = 'Enviar'
    Checked = True
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -18
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    State = cbChecked
    TabOrder = 9
  end
  object CBrecibir: TCheckBox
    Left = 328
    Top = 197
    Width = 97
    Height = 17
    Caption = 'Recibir'
    Checked = True
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -18
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    State = cbChecked
    TabOrder = 10
  end
  object EditPortSelf: TEdit
    Left = 328
    Top = 253
    Width = 73
    Height = 30
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -18
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 11
    Text = '22134'
  end
  object CBloopback: TCheckBox
    Left = 559
    Top = 266
    Width = 114
    Height = 17
    Alignment = taLeftJustify
    Caption = 'LoopBack'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -18
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 12
    OnClick = CBloopbackClick
  end
  object EscucharBut: TButton
    Left = 552
    Top = 96
    Width = 121
    Height = 42
    Caption = 'Escuchar'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -18
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 13
    OnClick = EscucharButClick
  end
  object ConectarBut: TButton
    Left = 552
    Top = 144
    Width = 121
    Height = 37
    Caption = 'Conectar'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -18
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 14
    OnClick = ConectarButClick
  end
  object DesconBut: TButton
    Left = 552
    Top = 48
    Width = 121
    Height = 42
    Caption = 'Desconectar'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -18
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 15
    OnClick = DesconButClick
  end
  object PanelState: TPanel
    Left = 552
    Top = 8
    Width = 121
    Height = 33
    BevelOuter = bvLowered
    Caption = 'Desconectado'
    Color = clPurple
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -18
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentBackground = False
    ParentFont = False
    TabOrder = 16
  end
  object CBcopyDirect: TCheckBox
    Left = 559
    Top = 243
    Width = 114
    Height = 17
    Alignment = taLeftJustify
    Caption = 'Copy Direct'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -18
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 17
    OnClick = CBloopbackClick
  end
  object CBExtLoopbak: TCheckBox
    Left = 559
    Top = 289
    Width = 114
    Height = 17
    Alignment = taLeftJustify
    Caption = 'Ext LoopB'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -18
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 18
    OnClick = CBExtLoopbakClick
  end
  object CBCompress: TCheckBox
    Left = 367
    Top = 16
    Width = 114
    Height = 17
    Caption = 'Compress'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -18
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 19
    OnClick = CBCompressClick
  end
  object CBBitRate: TComboBox
    Left = 367
    Top = 69
    Width = 145
    Height = 30
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -18
    Font.Name = 'Tahoma'
    Font.Style = []
    ItemIndex = 2
    ParentFont = False
    TabOrder = 20
    Text = '64'
    OnChange = CBBitRateChange
    Items.Strings = (
      '256'
      '128'
      '64'
      '32'
      '16')
  end
  object CBProtocol: TComboBox
    Left = 367
    Top = 131
    Width = 145
    Height = 30
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -18
    Font.Name = 'Tahoma'
    Font.Style = []
    ItemIndex = 1
    ParentFont = False
    TabOrder = 21
    Text = 'UDP'
    OnChange = CBProtocolChange
    Items.Strings = (
      'TCP'
      'UDP')
  end
  object CBSepThread: TCheckBox
    Left = 407
    Top = 256
    Width = 105
    Height = 17
    Alignment = taLeftJustify
    Caption = 'Sep Thread'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -18
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 22
    OnClick = CBSepThreadClick
  end
  object Bt_Reset: TButton
    Left = 239
    Top = 115
    Width = 106
    Height = 31
    Caption = 'Reset Audio'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -18
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 23
    OnClick = Bt_ResetClick
  end
  object ASIOHost: TASIOHost
    CanDos = []
    PreventClipping = pcDigital
    PreFillOutBuffer = bpfZero
    ConvertOptimizations = [coSSE]
    SelectorSupport = [assEngineVersion, assResetRequest, assBufferSizeChange, assResyncRequest, assLatenciesChanged]
    SampleRate = 44100.000000000000000000
    ASIOTime.SamplePos = 0
    ASIOTime.Speed = 1.000000000000000000
    ASIOTime.SampleRate = 44100.000000000000000000
    ASIOTime.Flags = [atSystemTimeValid, atSamplePositionValid, atSampleRateValid, atSpeedValid]
    OnBufferSwitch32 = ASIOHostBufferSwitch32Complex
    Left = 52
    Top = 120
  end
  object Timer1: TTimer
    Interval = 500
    OnTimer = Timer1Timer
    Left = 8
    Top = 120
  end
end
