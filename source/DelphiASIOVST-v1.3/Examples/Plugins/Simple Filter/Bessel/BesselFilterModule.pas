unit BesselFilterModule;

{$I ASIOVST.INC}

interface

uses DDSPBase, DVSTModule, DBesselFilter;

type
  TVSTFilter = class(TVSTModule)
    procedure VSTModuleProcess(const inputs, outputs: TArrayOfSingleDynArray; sampleframes: Integer);
    procedure VSTModuleProcessDoubleReplacing(const inputs, outputs: TArrayOfDoubleDynArray; sampleframes: Integer);
    procedure VSTFilterFrequencyChange(Sender: TObject; const Index: Integer; var Value: Single);
    procedure VSTModuleInitialize(Sender: TObject);
    procedure VSTModuleCreate(Sender: TObject);
    procedure VSTModuleDestroy(Sender: TObject);
  private
    fBesselFilters   : array [0..1] of TBesselLP;
  public
  end;

implementation

{$IFNDEF FPC}
{$R *.dfm}
{$ENDIF}

////////////////////////////////////////////////////////////////////////////////
// VST Module Handling
////////////////////////////////////////////////////////////////////////////////

procedure TVSTFilter.VSTModuleCreate(Sender: TObject);
begin
 fBesselFilters[0] := TBesselLP.Create;
 fBesselFilters[1] := TBesselLP.Create;
end;

procedure TVSTFilter.VSTModuleDestroy(Sender: TObject);
begin
 fBesselFilters[0].Free;
 fBesselFilters[1].Free;
end;

procedure TVSTFilter.VSTModuleInitialize(Sender: TObject);
begin
 Parameter[0]:=1000;
 Parameter[1]:=1;
end;


////////////////////////////////////////////////////////////////////////////////
// Parameter 0 Changed (Cutoff Frequency)
////////////////////////////////////////////////////////////////////////////////

procedure TVSTFilter.VSTFilterFrequencyChange(Sender: TObject; const Index: Integer; var Value: Single);
begin
 fBesselFilters[0].Frequency := Parameter[0];
 fBesselFilters[1].Frequency := Parameter[0];
end;


////////////////////////////////////////////////////////////////////////////////
// 32 Bit Processing
////////////////////////////////////////////////////////////////////////////////

procedure TVSTFilter.VSTModuleProcess(const inputs, outputs: TArrayOfSingleDynArray; sampleframes: Integer);
var i         : Integer;
begin
 for i := 0 to sampleFrames - 1 do
  begin
   outputs[0,i] := fBesselFilters[0].ProcessSample(inputs[0,i]);
   outputs[1,i] := fBesselFilters[1].ProcessSample(inputs[1,i]);
  end;
end;


////////////////////////////////////////////////////////////////////////////////
// 64 Bit Processing
////////////////////////////////////////////////////////////////////////////////

procedure TVSTFilter.VSTModuleProcessDoubleReplacing(const inputs,
  outputs: TArrayOfDoubleDynArray; sampleframes: Integer);
var i         : Integer;
begin
 for i := 0 to sampleFrames - 1 do
  begin
   outputs[0,i] := fBesselFilters[0].ProcessSample(inputs[0,i]);
   outputs[1,i] := fBesselFilters[1].ProcessSample(inputs[1,i]);
  end;
end;

end.
