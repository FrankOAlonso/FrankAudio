unit SKFCDM;

interface

uses
  Windows, Messages, SysUtils, Classes, Forms, DDSPBase, DVSTModule, DDynamics;

type
  TSKFC = class(TSoftKneeFeedbackCompressor)
  protected
    procedure RatioThresholdChanged; override;
  public
    function ProcessSample(Input : Double):Double; override;
    constructor Create; override;
  end;

  TSKFCDataModule = class(TVSTModule)
    procedure VSTModuleEditOpen(Sender: TObject; var GUI: TForm);
    procedure VSTModuleCreate(Sender: TObject);
    procedure VSTModuleDestroy(Sender: TObject);
    procedure VSTModuleProcess(const Inputs, Outputs: TArrayOfSingleDynArray; sampleframes: Integer);
    procedure SLThresholdChange(Sender: TObject; const Index: Integer; var Value: Single);
    procedure SLRatioChange(Sender: TObject; const Index: Integer; var Value: Single);
    procedure SLAttackChange(Sender: TObject; const Index: Integer; var Value: Single);
    procedure SLReleaseChange(Sender: TObject; const Index: Integer; var Value: Single);
    procedure SKFCMakeupGainChange(Sender: TObject;
      const Index: Integer; var Value: Single);
  private
    fSKFCs : Array [0..1] of TSKFC;
  public
  end;

implementation

{$R *.DFM}

uses Math, EditorFrm;

{ TSKFC }

constructor TSKFC.Create;
begin
 inherited;
 fMakeUpGaindB  := 0;
 fMakeUpGain[0] := 1;
end;

function TSKFC.ProcessSample(Input: Double): Double;
var a : Double;
begin
 result := fGain * Input;
 if abs(result)>fPeak
  then fPeak := abs(result) + (fPeak - abs(result)) * fAttackFactor
  else fPeak := abs(result) + (fPeak - abs(result)) * fDecayFactor;

 a := Power(fPeak, fRatioReciprocal);
 fGain := (1 - 0.8 * a / (a + 3)) * fThresholdReciprocal;
 result := fMakeUpGain[0] * fThreshold * result;
end;

procedure TSKFC.RatioThresholdChanged;
var a : Double;
begin
 inherited;
 a := Power(fPeak, fRatioReciprocal);
 fMakeUpGain[0] := 1 / ((1 - 0.8 * a / (a + 3)) * fThresholdReciprocal);
end;

{ TSKFCDataModule }

procedure TSKFCDataModule.SLThresholdChange(
  Sender: TObject; const Index: Integer; var Value: Single);
begin
 fSKFCs[0].Threshold := Value;
 fSKFCs[1].Threshold := Value;
 if Assigned(EditorForm) then
  with EditorForm As TEditorForm do
   if SBThreshold.Position <> Round(Value) then
    begin
     SBThreshold.Position := Round(Value);
     LbThresholdValue.Caption := IntToStr(SBThreshold.Position) + ' dB';
    end;
end;

procedure TSKFCDataModule.SLRatioChange(
  Sender: TObject; const Index: Integer; var Value: Single);
begin
 fSKFCs[0].Ratio := 1 / Value;
 fSKFCs[1].Ratio := 1 / Value;
 if Assigned(EditorForm) then
  with EditorForm As TEditorForm do
   if SBRatio.Position <> Round(100 * Log10(Value)) then
    begin
     SBRatio.Position := Round(100 * Log10(Value));
     LbRatioValue.Caption := '1 : ' + FloatToStrF(Value, ffGeneral, 4, 4);
    end;
end;

procedure TSKFCDataModule.SLReleaseChange(Sender: TObject; const Index: Integer; var Value: Single);
begin
 fSKFCs[0].Decay := Value;
 fSKFCs[1].Decay := Value;
 if Assigned(EditorForm) then
  with EditorForm As TEditorForm do
   if SBRelease.Position <> Round(Value) then
    begin
     SBRelease.Position := Round(1000 * Log10(Value));
     LbReleaseValue.Caption := FloatToStrF(Value, ffGeneral, 4, 5) + ' ms';
    end;
end;

procedure TSKFCDataModule.SKFCMakeupGainChange(Sender: TObject; const Index: Integer; var Value: Single);
begin
 fSKFCs[0].MakeUpGaindB := Value;
 fSKFCs[1].MakeUpGaindB := Value;
 if Assigned(EditorForm) then
  with EditorForm As TEditorForm do
   if SBMakeupGain.Position <> round(100 * Value) then
    begin
     SBMakeupGain.Position := round(100 * Value);
     LbMakeupGainValue.Caption := FloatToStrF(Value, ffGeneral, 4, 2) + ' dB';
    end;
end;

procedure TSKFCDataModule.SLAttackChange(Sender: TObject; const Index: Integer; var Value: Single);
begin
 fSKFCs[0].Attack := Value;
 fSKFCs[1].Attack := Value;
 if Assigned(EditorForm) then
  with EditorForm As TEditorForm do
   if SBAttack.Position <> Round(100 * Log10(Value)) then
    begin
     SBAttack.Position := Round(100 * Log10(Value));
     LbAttackValue.Caption := FloatToStrF(Value, ffGeneral, 4, 2) + ' ms';
    end;
end;

procedure TSKFCDataModule.VSTModuleCreate(Sender: TObject);
begin
 fSKFCs[0] := TSKFC.Create;
 fSKFCs[1] := TSKFC.Create;
end;

procedure TSKFCDataModule.VSTModuleDestroy(Sender: TObject);
begin
 FreeAndNil(fSKFCs[0]);
 FreeAndNil(fSKFCs[1]);
end;

procedure TSKFCDataModule.VSTModuleEditOpen(Sender: TObject; var GUI: TForm);
begin
  GUI := TEditorForm.Create(Self);
end;

procedure TSKFCDataModule.VSTModuleProcess(const Inputs,
  Outputs: TArrayOfSingleDynArray; sampleframes: Integer);
var i : Integer;
begin
 for i := 0 to sampleframes - 1 do
  begin
    Outputs[0,i] := fSKFCs[0].ProcessSample(Inputs[0,i]);
    Outputs[1,i] := fSKFCs[1].ProcessSample(Inputs[1,i]);
  end;
end;

end.
