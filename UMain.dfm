object FMain: TFMain
  Left = 0
  Top = 0
  Caption = 'Main'
  ClientHeight = 442
  ClientWidth = 619
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 10
    Top = 56
    Width = 289
    Height = 65
    Caption = 'Build With Classes'
    TabOrder = 0
    object btnBuildClasses: TButton
      Left = 2
      Top = 15
      Width = 285
      Height = 25
      Align = alTop
      Caption = 'BuildClasses'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 0
      OnClick = btnBuildClassesClick
      ExplicitLeft = 40
      ExplicitTop = 24
      ExplicitWidth = 75
    end
    object cbbAlgorithm: TComboBox
      Left = 2
      Top = 40
      Width = 285
      Height = 21
      Align = alTop
      TabOrder = 1
      Text = 'Elija algoritmo'
      Items.Strings = (
        'HS256'
        'HS384'
        'HS512'
        'HS256')
      ExplicitLeft = 16
      ExplicitTop = 48
      ExplicitWidth = 145
    end
  end
  object Full: TGroupBox
    Left = 10
    Top = 239
    Width = 284
    Height = 167
    Caption = 'Full'
    TabOrder = 1
    object memoJSON: TMemo
      Left = 2
      Top = 15
      Width = 280
      Height = 150
      Align = alClient
      TabOrder = 0
      ExplicitTop = 16
    end
  end
  object Compact: TGroupBox
    Left = 316
    Top = 239
    Width = 284
    Height = 167
    Caption = 'Compact'
    TabOrder = 2
    object memoCompact: TMemo
      Left = 2
      Top = 15
      Width = 280
      Height = 150
      Align = alClient
      TabOrder = 0
      ExplicitLeft = 3
    end
  end
  object Option: TGroupBox
    Left = 305
    Top = 51
    Width = 200
    Height = 101
    Caption = 'Options (Primero Generar Token)'
    TabOrder = 3
    object btnBuildTJOSE: TButton
      Left = 2
      Top = 40
      Width = 196
      Height = 25
      Align = alTop
      Caption = 'BuildToken'
      TabOrder = 0
      OnClick = btnBuildTJOSEClick
      ExplicitTop = 15
      ExplicitWidth = 285
    end
    object btnTestClaims: TButton
      Left = 2
      Top = 15
      Width = 196
      Height = 25
      Align = alTop
      Caption = 'TestClaims'
      TabOrder = 1
      OnClick = btnTestClaimsClick
      ExplicitLeft = 4
      ExplicitTop = 23
    end
    object btnBuildProducer: TButton
      Left = 2
      Top = 65
      Width = 196
      Height = 25
      Align = alTop
      Caption = 'BuildProducer'
      TabOrder = 2
      OnClick = btnBuildProducerClick
      ExplicitLeft = -2
      ExplicitTop = 76
    end
  end
  object btnVerifyTJOSE: TButton
    Left = 8
    Top = 127
    Width = 289
    Height = 25
    Caption = 'VerifyTJOSE'
    TabOrder = 4
    OnClick = btnVerifyTJOSEClick
  end
  object DeserializeTJOSE: TButton
    Left = 8
    Top = 154
    Width = 289
    Height = 25
    Caption = 'DeserializeToken'
    TabOrder = 5
    OnClick = DeserializeTJOSEClick
  end
  object VerifyClasses: TButton
    Left = 8
    Top = 185
    Width = 289
    Height = 25
    Caption = 'VerifyClasses'
    TabOrder = 6
    OnClick = VerifyClassesClick
  end
  object edtSecret: TLabeledEdit
    Left = 8
    Top = 29
    Width = 284
    Height = 21
    EditLabel.Width = 47
    EditLabel.Height = 13
    EditLabel.Caption = 'edtSecret'
    TabOrder = 7
  end
end
