unit main;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, echo;

type
  TForm1 = class(TForm)
    Button1: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    echod:TTCPEchoDaemon;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.FormCreate(Sender: TObject);
begin
 echod:=TTCPEchoDaemon.create;
 echod.blksize:=512;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
 echod.Terminate;
 sleep(1000);
 //echod.Destroy;
end;

end.
