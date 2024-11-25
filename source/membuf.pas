unit Membuf;

{$POINTERMATH ON}

interface

uses
  Classes, SysUtils;

const
  MaxSamples=20000;
  ceroWord=0;
type

    sample=single;

    Pblock=^sample;

    TMemBuf=class(TObject)
      private
        Fini,Ffin,Fusado:integer;
        mb:Array [0..2*MaxSamples] of sample;
      protected
        FNumSamples,FActualSamples:integer;
        ojo:integer;
        ojoblockNumBytes:integer;
      public
        constructor create(numSamples:integer);
        function PutMem(mSize:integer):Pblock;
        function PutMemCopy(mSize:integer;porig:pblock):Pblock;

        function GetMem(mSize:integer):Pblock;
        function GetMemCopy(mSize:integer;pdest:pblock):Pblock;

        function used:integer;
        function caben:integer;
        //util
        procedure clearMem;
        //properties
        Property ini : integer Read Fini;
        Property fin : integer Read Ffin;

    end;


implementation
  function TMemBuf.used:integer;
  begin
    result:=Fusado;
    //result:=(Ffin+FActualSamples-Fini)mod FActualSamples;
  end;
  function TMemBuf.caben:integer;
  begin
    result:=FNumSamples-used;
  end;

  //limpiar e iniciar memoria
  procedure TMemBuf.clearMem;

  begin
     Fini:=0;
     Ffin:=0;
     Fusado:=0;
     FActualSamples:=FNumSamples;
     //limpiar memoria
     //for i:=0 to FNumSamples-1 do
     // mb[i]:=ceroWord;
  end;


  constructor TMemBuf.create(numSamples:integer);
  begin
     if numSamples>MaxSamples then
       raise Exception.Create('Too big number of samples in MemBuf');

     FNumSamples:=numSamples;
     clearmem;
     //la memoria ya esta en mb.
  end;



  //pone el buffer circular y devuelve un puntero don de copiar los datos
  function    TMemBuf.PutMem(mSize:integer):Pblock;
  begin
    result:=nil;
    if mSize<=0 then
      raise Exception.Create('Membuf Negative size');

    if mSize<=(FNumSamples-Ffin) then begin
        //cabe normalmente
        result:=@mb[Ffin];
        Ffin:=(Ffin+mSize)mod Fnumsamples;
        Fusado:=Fusado+mSize;
    end else
      //si no cabe totalmente, empezamos añl principio para no fraccionar
      if mSize<=Fini then  begin
         FActualSamples:=Ffin;
         result:=@mb[0];
         Ffin:=mSize;
         Fusado:=Fusado+mSize;
      end;

  end;
  //pone el buffer circular y copiar los datos desde poric al buffer
  function TMemBuf.PutMemCopy(mSize:integer;porig:pblock):Pblock;

  begin
    result:=Putmem(msize);
    if result<>nil then
      //CopyMemory(result,porig,msize*sizeof(sample));
      Move(porig^,result^,msize*sizeof(sample));

  end;

  function    TMemBuf.GetMem(mSize:integer):Pblock;
  var
    faltan,j:integer;
    Po,Pd:Pblock;

  begin
    result:=nil;
    if mSize<=0 then
      raise Exception.Create('Membuf Negative size');
    if mSize<=Fusado then
    begin
      if msize<=FActualSamples-Fini then begin
        result:=@mb[Fini];
        Fini:=(Fini+msize)mod FActualSamples;
        Fusado:=Fusado-mSize;
        if Fusado=0 then
           FFin:=Fini;
      end else begin
        //hay que copiar parte del principio al final para tener un bloque contiguo
        result:=@mb[Fini];
        Po:=@mb[0];
        Pd:=@mb[Factualsamples];
        faltan:=mSize-(FActualSamples-Fini);
        for j:=0 to faltan-1 do
          Pd[j]:=Po[j];
        //recolocar Fini
        Fini:=(Fini+msize)mod FActualSamples;
        Fusado:=Fusado-mSize;
      end;
    end;
  end;

   function TMemBuf.GetMemCopy(mSize:integer;pdest:pblock):Pblock;
  
   begin
     result:=Getmem(msize);
    if result<>nil then
       //CopyMemory(pdest,result,msize*sizeof(sample));
       move(result^,pdest^,msize*sizeof(sample));

   end;


 
end.

