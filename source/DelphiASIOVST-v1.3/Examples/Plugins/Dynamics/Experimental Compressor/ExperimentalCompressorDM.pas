unit ExperimentalCompressorDM;

interface

uses 
  Windows, Messages, SysUtils, Classes, Forms, DDSPBase, DVSTModule, DDynamics;

type
  TExperimentalCompressorDataModule = class(TVSTModule)
    procedure VSTModuleEditOpen(Sender: TObject; var GUI: TForm);
    procedure VSTModuleCreate(Sender: TObject);
    procedure VSTModuleDestroy(Sender: TObject);
    procedure VSTModuleProcess(const Inputs, Outputs: TArrayOfSingleDynArray; sampleframes: Integer);
    procedure SLThresholdChange(Sender: TObject; const Index: Integer; var Value: Single);
    procedure SLRatioChange(Sender: TObject; const Index: Integer; var Value: Single);
    procedure SLAttackChange(Sender: TObject; const Index: Integer; var Value: Single);
    procedure SLReleaseChange(Sender: TObject; const Index: Integer; var Value: Single);
    procedure ECOnReleaseShapeChange(Sender: TObject; const Index: Integer; var Value: Single);
  private
    fExperimentalCompressors : Array [0..1] of TExperimentalCompressor;
  public
  end;

implementation

{$R *.DFM}

uses Math, EditorFrm;

procedure TExperimentalCompressorDataModule.VSTModuleCreate(Sender: TObject);
begin
 fExperimentalCompressors[0] := TExperimentalCompressor.Create;
 fExperimentalCompressors[1] := TExperimentalCompressor.Create;
end;

procedure TExperimentalCompressorDataModule.VSTModuleDestroy(Sender: TObject);
begin
 FreeAndNil(fExperimentalCompressors[0]);
 FreeAndNil(fExperimentalCompressors[1]);
end;

procedure TExperimentalCompressorDataModule.VSTModuleEditOpen(Sender: TObject; var GUI: TForm);
begin
  GUI := TEditorForm.Create(Self);
end;

procedure TExperimentalCompressorDataModule.SLThresholdChange(
  Sender: TObject; const Index: Integer; var Value: Single);
begin
 fExperimentalCompressors[0].Threshold := Value;
 fExperimentalCompressors[1].Threshold := Value;
 if Assigned(EditorForm) then
  with EditorForm As TEditorForm do
   if SBThreshold.Position <> Round(Value) then
    begin
     SBThreshold.Position := Round(Value);
     LbThresholdValue.Caption := IntToStr(SBThreshold.Position) + ' dB';
    end;
end;

procedure TExperimentalCompressorDataModule.SLRatioChange(
  Sender: TObject; const Index: Integer; var Value: Single);
begin
 fExperimentalCompressors[0].Ratio := 1 / Value;
 fExperimentalCompressors[1].Ratio := 1 / Value;
 if Assigned(EditorForm) then
  with EditorForm As TEditorForm do
   if SBRatio.Position <> Round(100 * Log10(Value)) then
    begin
     SBRatio.Position := Round(100 * Log10(Value));
     LbRatioValue.Caption := '1 : ' + FloatToStrF(Value, ffGeneral, 4, 4);
    end;
end;

procedure TExperimentalCompressorDataModule.SLAttackChange(
  Sender: TObject; const Index: Integer; var Value: Single);
begin
 fExperimentalCompressors[0].Attack := Value;
 fExperimentalCompressors[1].Attack := Value;
 if Assigned(EditorForm) then
  with EditorForm As TEditorForm do
   if SBAttack.Position <> Round(100 * Log10(Value)) then
    begin
     SBAttack.Position := Round(100 * Log10(Value));
     LbAttackValue.Caption := FloatToStrF(Value, ffGeneral, 4, 2) + ' ms';
    end;
end;

procedure TExperimentalCompressorDataModule.SLReleaseChange(
  Sender: TObject; const Index: Integer; var Value: Single);
begin
 fExperimentalCompressors[0].Decay := Value;
 fExperimentalCompressors[1].Decay := Value;
 if Assigned(EditorForm) then
  with EditorForm As TEditorForm do
   if SBRelease.Position <> Round(Value) then
    begin
     SBRelease.Position := Round(1000 * Log10(Value));
     LbReleaseValue.Caption := FloatToStrF(Value, ffGeneral, 4, 5) + ' ms';
    end;
end;

procedure TExperimentalCompressorDataModule.ECOnReleaseShapeChange(
  Sender: TObject; const Index: Integer; var Value: Single);
begin
 fExperimentalCompressors[0].ReleaseShape := Value;
 fExperimentalCompressors[1].ReleaseShape := Value;
 if Assigned(EditorForm) then
  with EditorForm As TEditorForm do
   if SBReleaseShape.Position <> Round(Value) then
    begin
     SBReleaseShape.Position := Round(1000 * Value);
     LbReleaseShapeValue.Caption := FloatToStrF(Value, ffGeneral, 4, 5) + ' ms';
    end;
end;

procedure TExperimentalCompressorDataModule.VSTModuleProcess(const Inputs,
  Outputs: TArrayOfSingleDynArray; sampleframes: Integer);
var i : Integer;
begin
 for i := 0 to sampleframes - 1 do
  begin
    Outputs[0,i] := fExperimentalCompressors[0].ProcessSample(Inputs[0,i]);
    Outputs[1,i] := fExperimentalCompressors[1].ProcessSample(Inputs[1,i]);
  end;
end;

end.
