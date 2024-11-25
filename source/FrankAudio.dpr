program FrankAudio;

uses
  Vcl.Forms,
  FAMainForm in 'FAMainForm.pas' {FAmainF},
  Membuf in 'Membuf.pas',
  ConManager in 'ConManager.pas',
  CodecU in 'CodecU.pas',
  workTcpThread in 'workTcpThread.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFAmainF, FAmainF);
  Application.Run;
end.
