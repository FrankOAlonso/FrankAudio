unit SKFBLDM;

interface

uses 
  Windows, Messages, SysUtils, Classes, Forms, DDSPBase, DVSTModule, DDynamics;

type
  TSKFBLimiterDataModule = class(TVSTModule)
    procedure VSTModuleEditOpen(Sender: TObject; var GUI: TForm);
    procedure VSTModuleCreate(Sender: TObject);
    procedure VSTModuleDestroy(Sender: TObject);
    procedure VSTModuleProcess(const Inputs, Outputs: TArrayOfSingleDynArray; sampleframes: Integer);
    procedure SKLThresholdChange(Sender: TObject; const Index: Integer; var Value: Single);
    procedure SKLRatioChange(Sender: TObject; const Index: Integer; var Value: Single);
    procedure SKLAttackChange(Sender: TObject; const Index: Integer; var Value: Single);
    procedure SKLReleaseChange(Sender: TObject; const Index: Integer; var Value: Single);
    procedure VSTModuleProcessDoubleReplacing(const Inputs, Outputs: TArrayOfDoubleDynArray; sampleframes: Integer);
    procedure VSTModuleSampleRateChange(Sender: TObject; const SampleRate: Single);
    procedure SKLSKFBChange(Sender: TObject; const Index: Integer; var Value: Single);
  private
    fSKFBLimiters : Array [0..1] of TSoftKneeFeedbackLimiter;
  public
  end;

implementation

{$R *.DFM}

uses Math, EditorFrm;

procedure TSKFBLimiterDataModule.VSTModuleCreate(Sender: TObject);
begin
 fSKFBLimiters[0] := TSoftKneeFeedbackLimiter.Create;
 fSKFBLimiters[1] := TSoftKneeFeedbackLimiter.Create;
end;

procedure TSKFBLimiterDataModule.VSTModuleDestroy(Sender: TObject);
begin
 FreeAndNil(fSKFBLimiters[0]);
 FreeAndNil(fSKFBLimiters[1]);
end;

procedure TSKFBLimiterDataModule.VSTModuleEditOpen(Sender: TObject; var GUI: TForm);
begin
 GUI := TEditorForm.Create(Self);
 with TEditorForm(GUI) do
  begin
   SBThreshold.Position := Round(Parameter[0]);
   LbThresholdValue.Caption := IntToStr(SBThreshold.Position) + ' dB';
   SBSKFB.Position := Round(10 * Parameter[4]);
   LbSKFBValue.Caption := FloatToStrF(Parameter[4], ffGeneral, 4, 5);
   SBRatio.Position := Round(100 * Log10(Parameter[1]));
   LbRatioValue.Caption := '1 : ' + FloatToStrF(Parameter[1], ffGeneral, 4, 4);
   SBAttack.Position := Round(1000 * Log10(Parameter[2]));
   LbAttackValue.Caption := FloatToStrF(Parameter[2], ffGeneral, 4, 2) + ' ms';
   SBRelease.Position := Round(1000 * Log10(Parameter[3]));
   LbReleaseValue.Caption := FloatToStrF(Parameter[3], ffGeneral, 4, 5) + ' ms';
  end;
end;

procedure TSKFBLimiterDataModule.SKLThresholdChange(Sender: TObject; const Index: Integer; var Value: Single);
begin
 fSKFBLimiters[0].Threshold := Value;
 fSKFBLimiters[1].Threshold := Value;
 if Assigned(EditorForm) then
  with EditorForm As TEditorForm do
   if SBThreshold.Position <> Round(Value) then
    begin
     SBThreshold.Position := Round(Value);
     LbThresholdValue.Caption := IntToStr(SBThreshold.Position) + ' dB';
    end;
end;

procedure TSKFBLimiterDataModule.SKLSKFBChange(Sender: TObject; const Index: Integer; var Value: Single);
begin
 fSKFBLimiters[0].SoftKnee := Value / 20;
 fSKFBLimiters[1].SoftKnee := Value / 20;
 if Assigned(EditorForm) then
  with EditorForm As TEditorForm do
   if SBSKFB.Position <> Round(10 * Value) then
    begin
     SBSKFB.Position := Round(10 * Value);
     LbSKFBValue.Caption := FloatToStrF(Parameter[4], ffGeneral, 4, 5);
    end;
end;

procedure TSKFBLimiterDataModule.SKLRatioChange(Sender: TObject; const Index: Integer; var Value: Single);
begin
 fSKFBLimiters[0].Ratio := 1 / Value;
 fSKFBLimiters[1].Ratio := 1 / Value;
 if Assigned(EditorForm) then
  with EditorForm As TEditorForm do
   if SBRatio.Position <> Round(100 * Log10(Value)) then
    begin
     SBRatio.Position := Round(100 * Log10(Value));
     LbRatioValue.Caption := '1 : ' + FloatToStrF(Value, ffGeneral, 4, 4);
    end;
end;

procedure TSKFBLimiterDataModule.SKLReleaseChange(Sender: TObject; const Index: Integer; var Value: Single);
begin
 fSKFBLimiters[0].Decay := Value;
 fSKFBLimiters[1].Decay := Value;
 if Assigned(EditorForm) then
  with EditorForm As TEditorForm do
   if SBRelease.Position <> Round(Value) then
    begin
     SBRelease.Position := Round(1000 * Log10(Value));
     LbReleaseValue.Caption := FloatToStrF(Value, ffGeneral, 4, 5) + ' ms';
    end;
end;

procedure TSKFBLimiterDataModule.SKLAttackChange(Sender: TObject; const Index: Integer; var Value: Single);
begin
 fSKFBLimiters[0].Attack := Value;
 fSKFBLimiters[1].Attack := Value;
 if Assigned(EditorForm) then
  with EditorForm As TEditorForm do
   if SBAttack.Position <> Round(1000 * Log10(Value)) then
    begin
     SBAttack.Position := Round(100 * Log10(Value));
     LbAttackValue.Caption := FloatToStrF(Value, ffGeneral, 4, 2) + ' ms';
    end;
end;

procedure TSKFBLimiterDataModule.VSTModuleProcess(const Inputs, Outputs: TArrayOfSingleDynArray; sampleframes: Integer);
var i : Integer;
begin
 for i := 0 to sampleframes - 1 do
  begin
   Outputs[0,i] := fSKFBLimiters[0].ProcessSample(Inputs[0,i]);
   Outputs[1,i] := fSKFBLimiters[1].ProcessSample(Inputs[1,i]);
  end;
end;

procedure TSKFBLimiterDataModule.VSTModuleProcessDoubleReplacing(const Inputs, Outputs: TArrayOfDoubleDynArray; sampleframes: Integer);
var i : Integer;
begin
 for i := 0 to sampleframes - 1 do
  begin
   Outputs[0,i] := fSKFBLimiters[0].ProcessSample(Inputs[0,i]);
   Outputs[1,i] := fSKFBLimiters[1].ProcessSample(Inputs[1,i]);
  end;
end;

procedure TSKFBLimiterDataModule.VSTModuleSampleRateChange(Sender: TObject;
  const SampleRate: Single);
begin
 if Assigned(fSKFBLimiters[0])
  then fSKFBLimiters[0].SampleRate := SampleRate;
 if Assigned(fSKFBLimiters[1])
  then fSKFBLimiters[1].SampleRate := SampleRate;
end;

end.
