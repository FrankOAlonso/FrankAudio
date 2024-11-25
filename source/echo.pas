unit echo;

interface

uses
  Classes, blcksock, synsock,blockbuf;
const
  bsize=256;

type
 TTCPEchoThrd = class(TThread)
  private
    Sock:TTCPBlockSocket;
    CSock: TSocket;
    fBufsize:integer;
  public
    Constructor Create (hsock:tSocket;blksize:integer);
    procedure Execute; override;
  end;

  TTCPEchoDaemon = class(TThread)
  private
    Sock:TTCPBlockSocket;
    aconex:array [0..9] of TTCPEchoThrd;
    conexcount:integer;
    Fblksize:integer;
  public
    Constructor Create;
    Destructor Destroy; override;
    procedure Execute; override;
    procedure Terminate;
    property blksize: integer read Fblksize write Fblksize;
  end;



implementation

{ TEchoDaemon }

Constructor TTCPEchoDaemon.Create;
var
  i:integer;
begin
  inherited create(false);
  Fblksize:=bsize;
  for i:=0 to 9  do
     aconex[i]:=nil;
  conexcount:=0;
  sock:=TTCPBlockSocket.create;
  FreeOnTerminate:=true;
end;

Destructor TTCPEchoDaemon.Destroy;
begin

end;
procedure TTCPEchoDaemon.Terminate;
var
 i:integer;
begin
 for i:=0 to 9  do
    if  aconex[i]<>nil then
      aconex[i].Terminate;

    inherited;
end;
procedure TTCPEchoDaemon.Execute;
var
  ClientSock:TSocket;
begin
  with sock do
    begin
      CreateSocket;
      setLinger(true,10000);
      bind('0.0.0.0','22134');
      listen;
      repeat
        if terminated then break;
        if canread(1000) then
          begin
            ClientSock:=accept;
            if lastError=0 then begin
               aconex[conexcount]:=TTCPEchoThrd.create(ClientSock,Fblksize);
               inc(conexcount);
            end;
          end;
      until false;
    end;
end;

{ TEchoThrd }

Constructor TTCPEchoThrd.Create(Hsock:TSocket;blksize:integer);
begin
  inherited create(false);
  Csock := Hsock;
  fBufsize:=blksize*sizeof(sample);
  FreeOnTerminate:=true;
end;

procedure TTCPEchoThrd.Execute;
var

  //abuff:array[1..bsize] of sample;
  Pbtemp:pblock;
begin
  Pbtemp:=GetMemory(fBufsize);
  sock:=TTCPBlockSocket.create;
  try
    Sock.socket:=CSock;
    sock.GetSins;
    with sock do
      begin
        repeat
          RecvBufferEx(Pbtemp,fBufsize,2000);
          if lastError=0then begin
            sendBuffer(Pbtemp,fBufsize);
            if lastError<>0 then break;
          end;
          yield;
        until terminated;
      end;
  finally
    Sock.Free;
  end;
end;

end.
