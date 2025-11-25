
program VesaDiag;

uses Dos;

type
  TModeInfo = record
    ModeAttributes: Word;
    WinAAttributes: Byte;
    WinBAttributes: Byte;
    WinGranularity: Word;
    WinSize: Word;
    WinASegment: Word;
    WinBSegment: Word;
    WinFuncPtr: LongInt;
    BytesPerScanline: Word;
    XRes: Word;
    YRes: Word;
    XCharSize: Byte;
    YCharSize: Byte;
    Planes: Byte;
    BitsPerPixel: Byte;
    Banks: Byte;
    MemoryModel: Byte;
    BankSize: Byte;
    NumImagePages: Byte;
    Reserved1: Byte;
    RedMaskSize: Byte;
    RedMaskPos: Byte;
    GreenMaskSize: Byte;
    GreenMaskPos: Byte;
    BlueMaskSize: Byte;
    BlueMaskPos: Byte;
    ReservedMaskSize: Byte;
    ReservedMaskPos: Byte;
    DirectColorModeInfo: Byte;
    PhysBasePtr: LongInt;
    OffscreenMemOffset: LongInt;
    OffscreenMemSize: Word;
    Reserved2: array[1..206] of Byte;
  end;
function HexStr(num:longint; size:integer):string;
var
   s,h:string;

begin
h:='0123456789ABCDEF';
s:='';

repeat
s:=h[1+(num and 15)]+s;
num:=num shr 4;
until num=0;

Hexstr:=s;
end;
var
  Regs: Registers;
  M: TModeInfo;

begin
  Regs.AX := $4F01;
  Regs.CX := $118;
  Regs.ES := Seg(M);
  Regs.DI := Ofs(M);
  Intr($10, Regs);

  if Regs.AX <> $004F then
  begin
    Writeln('Mode info error');
    Halt;
  end;

  Writeln('Mode 118h info:');
  Writeln(' Resolution: ', M.XRes, ' x ', M.YRes);
  Writeln(' BitsPerPixel: ', M.BitsPerPixel);
  Writeln(' BytesPerScanline: ', M.BytesPerScanline);
  Writeln(' Window segment: ', HexStr(M.WinASegment, 4));
  Writeln(' Window segment: ', M.WinASegment);
  Writeln(' Window size (KB): ', M.WinSize);
  Writeln(' Granularity (KB): ', M.WinGranularity);
end.
