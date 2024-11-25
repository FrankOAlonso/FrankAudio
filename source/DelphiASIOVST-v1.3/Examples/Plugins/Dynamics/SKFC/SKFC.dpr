{$J-,H+,T-P+,X+,B-,V-,O+,A+,W-,U-,R-,I-,Q-,D-,L-,Y-,C-}
library SKFC;

uses
  FastMM4,
  Forms,
  DVSTEffect,
  DVSTModule,
  SKFCDM in 'SKFCDM.pas' {SKFCDataModule: TVSTModule},
  EditorFrm in 'EditorFrm.pas' {EditorForm};

function main(audioMaster: TAudioMasterCallbackFunc): PVSTEffect; cdecl; export;
var
  SKFCDataModule: TSKFCDataModule;
begin
  try
    SKFCDataModule := TSKFCDataModule.Create(Application);
    SKFCDataModule.AudioMaster := audioMaster;
    with SKFCDataModule do
    begin
      Effect^.user := SKFCDataModule;
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
