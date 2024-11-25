unit BlockBuf;

{$POINTERMATH ON}

interface

uses
  Classes, SysUtils;

const
  MaxNumBlocks=1023;
  ceroWord=0;
type

    sample=smallint;

    Pblock=^sample;

    TBlockBuf=class(TObject)
      private
        Fini,Ffin,FNumB:integer;
        cb:Array [0..MaxNumBlocks] of Pblock;
      protected
        FNumblocks:integer;
        FBlockSize:integer;
        blockNumBytes:integer;
        procedure clearBlock(pb:pblock);
      public
        constructor create(numBlocks,bSize:integer);
        destructor destroy;override;
        function NextPblock:Pblock;
        function PutBlock():boolean;
        function GetBlock(var pb:Pblock):boolean;
        function PeekBlock(num:integer):pblock;
        function dif:integer;
        procedure copyBlock(Porig,pDestino: Pblock);
        //util
         procedure reset;
        //properties
        Property ini : integer Read Fini;
        Property fin : integer Read Ffin;
        Property NumB: integer Read FNumB;
        Property blockSize: integer Read FBlockSize;





    end;


implementation
  function TBlockBuf.dif:integer;
  begin
    result:=(Ffin+Fnumblocks-Fini)mod FNumblocks;
  end;
  //limpiar un bloque de memoria
  procedure TBlockBuf.clearBlock(pb:pblock);
  var
   i:integer;
  begin
     for I := 0 to FBlockSize-1 do
       pb[i]:=ceroWord;
  end;

  constructor TBlockBuf.create(numBlocks,bSize:integer);
  var
    pb:Pblock;
    i:integer;
  begin
     blockNumBytes:=bsize*sizeof(sample);
     FNumblocks:=numBlocks;
     FBlockSize:=bSize;
     Fini:=0;
     Ffin:=0;
     FNumB:=0;
     //alocar memoria para los bloques
     for i:=0 to FNumblocks-1 do
     begin
       GetMem (pb,blockNumBytes);
       clearBlock(pb);
       cb[i]:=pb;
       //

     end;
  end;

  destructor TBlockBuf.destroy;
  var
    i:Integer;
  begin
    for i:=0 to FNumblocks-1 do
       FreeMem (cb[i],FBlockSize*sizeof(sample));

    inherited;
  end;

  function    TBlockBuf.NextPblock:Pblock;
  begin
    if FNumB<FNumblocks then
      result:=cb[Ffin]
    else
      result:=nil;

  end;

  function    TBlockBuf.PutBlock():boolean;
  begin
    result:=false;
    if FNumB<FNumblocks then
    begin
      //cb[Ffin]:=pb;
      inc(FNumB);
      Ffin:=(Ffin+1) mod FNumblocks;
      result:=true;
    end;

  end;

  function    TBlockBuf.GetBlock(var pb:Pblock):boolean;
  begin
    result:=false;
    if FNumB>0 then
    begin
      pb:=cb[Fini];
      dec(FNumB);
      Fini:=(Fini+1) mod FNumblocks;
      result:=true;
    end;

  end;
  function TBlockBuf.PeekBlock(num:integer):pblock;
  begin
    result:=nil;
    if num <= FNumB then
      result:=cb[(Fini+num)mod FNumblocks];
  end;

  procedure TBlockBuf.reset;
  var
    i:integer;
  begin
     Fini:=0;
     Ffin:=0;
     FNumB:=0;
     //limpiar memoria
     for i:=0 to FNumblocks-1 do
       clearBlock(cb[i]);
  end;

  procedure TBlockBuf.copyBlock(pOrig,pDestino :Pblock);
  begin
    if (Porig<>NIL) and (pDestino<>NIL) then
      Move(Porig^,pDestino^,blockNumBytes);
  end;
end.

