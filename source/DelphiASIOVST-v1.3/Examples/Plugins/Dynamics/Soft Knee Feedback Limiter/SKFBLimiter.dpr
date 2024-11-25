{$J-,H+,T-P+,X+,B-,V-,O+,A+,W-,U-,R-,I-,Q-,D-,L-,Y-,C-}
library SKFBLimiter;

uses
  FastMM4,
  Forms,
  DVSTEffect,
  DVSTModule,
  SKFBLDM in 'SKFBLDM.pas' {SKFBLimiterDataModule: TVSTModule},
  EditorFrm in 'EditorFrm.pas' {EditorForm};

function main(audioMaster: TAudioMasterCallbackFunc): PVSTEffect; cdecl; export;
var
  SKFBLimiterDataModule: TSKFBLimiterDataModule;
begin
  try
    SKFBLimiterDataModule := TSKFBLimiterDataModule.Create(Application);
    SKFBLimiterDataModule.AudioMaster := audioMaster;
    with SKFBLimiterDataModule do
    begin
      Effect^.user := SKFBLimiterDataModule;
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
