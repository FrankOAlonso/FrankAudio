unit CodecU;
interface

uses
  SysUtils,
  Classes,
  uLibOpus;

const
  isSingle=true;
  debug=true;
  cAPPLICATION = OPUS_APPLICATION_AUDIO;
  cMAX_FRAME_SIZE = 6 * 960;
  cMAX_PACKET_SIZE = 3 * 1276;
  FEC=0; //Flag error correction
type
  TSample=single;
  TPPcm=^TSample;
  TPbytes=^Byte;

  TCodec = class(TObject)
  private
    { private declarations }
   FframeSize:integer;
   FsampleRate:integer;
   FBitRate :integer;
   FChannels:integer;
   Ferr: Integer;
   AbytesOut:  array [0 .. cMAX_PACKET_SIZE - 1] of Byte;
   ASamplesOut:array [0 .. cMAX_FRAME_SIZE - 1]  of TSample;
  protected
    { protected declarations }
   encoder: TOpusEncoder;
   decoder: TOpusDecoder;
   procedure CodecError(s:string);
   procedure setbitrate(br:integer);
  public
    { public declarations }
    constructor Create;
    destructor Destroy;OVERRIDE;
    procedure init;
    function encode(const PCMIn;var bytesOut):integer;
    function decode(const bytes;nbBytes:integer;var PCMOut):integer;
    function bytesOut:TPbytes;
    function samplesOut:TPPcm;
    property frameSize: integer read FframeSize write FframeSize;
    property sampleRate: integer read FsampleRate write FsampleRate;
    property bitRate: integer read FbitRate write SetbitRate;
    property err: Integer read Ferr;

  end;
implementation



{ TCodec }

constructor TCodec.Create;
begin
  inherited;
  FframeSize:=240;
  FsampleRate:=48000;
  FBitRate:=64000;
  FChannels:=1;
  encoder:=nil;
  decoder:=nil;

  //cargar la librería
  LoadLibOpus;

end;

destructor TCodec.Destroy;
begin
  if encoder<>nil then
    opus_encoder_destroy(encoder);
  if decoder<>nil then
    opus_decoder_destroy(decoder);
  inherited;
end;

procedure TCodec.init;
begin
 try
  //crear el encoder
  encoder := opus_encoder_create(FsampleRate,FChannels, cAPPLICATION, Ferr);
  if (Ferr<0) then
     CodecError(Format('failed to create an encoder: %s', [opus_strerror(Ferr)]));

  //
  setbitrate(FBitRate);

  //crear el decoder
  decoder := opus_decoder_create(FsampleRate,FChannels,Ferr);
  if (Ferr<0) then
     CodecError(Format('failed to create decoder: %s', [opus_strerror(Ferr)]));


 except
    on E:Exception do
    begin
      CodecError(E.Classname+ ': '+ E.Message);
    end;
  end;
 end;

 procedure TCodec.setbitrate(br:integer);
 begin
   // Poner el BitRate deseado
   FBitRate := br;
   if encoder <> nil then
   begin
     Ferr := opus_encoder_ctl(encoder, OPUS_SET_BITRATE(FBitRate));
     if (Ferr < 0) then
       CodecError(Format('failed to set bitrate: %s', [opus_strerror(Ferr)]));
   end;
 end;

procedure TCodec.CodecError(s:string);
begin
  raise Exception.Create(s);

end;

function TCodec.bytesOut:TPbytes;
begin
 result:=@AbytesOut;
end;

function TCodec.samplesOut:TPPcm;
begin
 result:=@AsamplesOut;
end;

function TCodec.encode(const PCMIn;var bytesOut):integer;
begin
  // function opus_encode(st: TOpusEncoder; const pcm; frame_size: Integer; var data; max_data_bytes: Integer): Integer;
  // function opus_encode_float(st: TOpusEncoder; const pcm; frame_size: Integer; var data; max_data_bytes: Integer): Integer;
  //result:=opus_encode_float(encoder,PCMin,FframeSize,AbytesOut ,cMAX_PACKET_SIZE);
 if issingle then
    result:=opus_encode_float(encoder,PCMin,FframeSize,bytesOut ,cMAX_PACKET_SIZE)
 else
    result:=opus_encode(encoder,PCMin,FframeSize,bytesOut ,cMAX_PACKET_SIZE);

end;

function TCodec.decode(const bytes;nbBytes:integer;var PCMOut):integer;
begin
  //function opus_decode(st: TOpusDecoder; const data; len: Integer; var pcm; frame_size, decode_fec: Integer): Integer;
  //function opus_decode_float(st: TOpusDecoder; const data; len: Integer; var pcm; frame_size, decode_fec: Integer): Integer;
  //result:=opus_decode_float(decoder,PBytes,nbBytes,AsamplesOut,cMAX_FRAME_SIZE,FEC);
if issingle then
  result:=opus_decode_float(decoder,bytes ,nbBytes,PCMOut,cMAX_FRAME_SIZE,FEC)

  else
  result:=opus_decode(decoder,bytes,nbBytes,PCMOut,cMAX_FRAME_SIZE,FEC);

end;


end.
