{$J-,H+,T-P+,X+,B-,V-,O+,A+,W-,U-,R-,I-,Q-,D-,L-,Y-,C-}
library ExperimentalCompressor;

uses
  FastMM4,
  Forms,
  DVSTEffect,
  DVSTModule,
  ExperimentalCompressorDM in 'ExperimentalCompressorDM.pas' {ExperimentalCompressorDataModule: TVSTModule},
  EditorFrm in 'EditorFrm.pas' {EditorForm};

function main(audioMaster: TAudioMasterCallbackFunc): PVSTEffect; cdecl; export;
var
  ExperimentalCompressorDataModule: TExperimentalCompressorDataModule;
begin
  try
    ExperimentalCompressorDataModule := TExperimentalCompressorDataModule.Create(Application);
    ExperimentalCompressorDataModule.AudioMaster := audioMaster;
    with ExperimentalCompressorDataModule do
    begin
      Effect^.user := ExperimentalCompressorDataModule;
      Result := Effect;
    end;
  except
    Result := nil;
  end;
end;

exports Main name 'main';
exports Main name 'VSTPluginMain';

begin
end.
