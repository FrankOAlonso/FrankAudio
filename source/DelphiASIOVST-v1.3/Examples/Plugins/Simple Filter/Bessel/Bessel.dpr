{$J-,H+,T-P+,X+,B-,V-,O+,A+,W-,U-,R-,I-,Q-,D-,L-,Y-,C-}
library Bessel;

uses
  Forms,
  DVSTEffect,
  DVSTModule,
  BesselFilterModule in 'BesselFilterModule.pas' {VSTFilter: TVSTModule};

function main(audioMaster: TAudioMasterCallbackFunc): PVSTEffect; cdecl; export;
var VSTModule1 : TVSTFilter;
begin
  VSTModule1:=TVSTFilter.Create(nil);
  VSTModule1.Effect^.user:=VSTModule1;
  VSTModule1.AudioMaster:=audioMaster;
  Result := VSTModule1.Effect;

  with VSTModule1 do
  try
    Flags := [effFlagsCanReplacing, effFlagsCanDoubleReplacing];
    Version := '1.0';
    EffectName := 'Delphi Bessel Filter';
    ProductName := 'Delphi Bessel Filter';
    VendorName := 'Delphi VST';
    PlugCategory := vpcEffect;
    TailSize := 0;
    CanDos := [vcdplugAsChannelInsert, vcdplugAsSend, vcd1in1out, vcd1in2out,
               vcd2in1out, vcd2in2out];
    SampleRate := 44100.0;
    KeysRequired := False;
    UniqueID := 'Besl';
    OnProcess := VSTModuleProcess;
    OnProcessReplacing := VSTModuleProcess;
    OnProcessDoubleReplacing := VSTModuleProcessDoubleReplacing;
    OnInitialize := VSTModuleInitialize;
    OnCreate := VSTModuleCreate;
    OnDestroy := VSTModuleDestroy;

    with (Programs.Add) do
    begin
      DisplayName := 'Preset 1';
      VSTModule:=VSTModule1;
    end;
    with (Programs.Add) do
    begin
      DisplayName := 'Preset 2';
      VSTModule:=VSTModule1;
    end;
    with (Programs.Add) do
    begin
      DisplayName := 'Preset 3';
      VSTModule:=VSTModule1;
    end;

    with (ParameterProperties.Add) do
    begin
      VSTModule := VSTModule1;
      Min := 20.0;
      Max := 20000.0;
      Curve := ctLogarithmic;
      DisplayName := 'Cutoff Frequency';
      Units := 'Hz';
      CurveFactor := 1000.0;
      SmoothingFactor := 1.0;
      CanBeAutomated := True;
      ReportVST2Properties := False;
      StepFloat := 100.0;
      SmallStepFloat := 100.0;
      LargeStepFloat := 1000.0;
      Flags := [];
      MinInteger := 20;
      MaxInteger := 20000;
      StepInteger := 100;
      LargeStepInteger := 1000;
      ShortLabel := 'Cutoff';
      OnParameterChange := VSTFilterFrequencyChange;
    end;
    CurrentProgram := 0;
    if Assigned(OnCreate) then OnCreate(VSTModule1);
    if Assigned(OnInitialize) then OnInitialize(VSTModule1);
  except
  end;
end;

exports Main name 'main';
exports Main name 'VSTPluginMain';

begin
end.
