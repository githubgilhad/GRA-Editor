unit VesaGrph;

Interface 

uses
     Dos,Crt,ReadFont,Tools;

type
     TModeInfo=
         record
           ModeAttributes:Word;
           WinAAttributes:Byte;
           WinBAttributes:Byte;
           WinGranularity:Word;
           WinSize:Word;
           WinASegment:Word;
           WinBSegment:Word;
           WinFuncPtr:LongInt;
           BytesPerScanline:Word;
           XRes:Word;
           YRes:Word;
           XCharSize:Byte;
           YCharSize:Byte;
           Planes:Byte;
           BitsPerPixel:Byte;
           Banks:Byte;
           MemoryModel:Byte;
           BankSize:Byte;
           NumImagePages:Byte;
           Reserved1:Byte;
           RedMaskSize:Byte;
           RedMaskPos:Byte;
           GreenMaskSize:Byte;
           GreenMaskPos:Byte;
           BlueMaskSize:Byte;
           BlueMaskPos:Byte;
           ReservedMaskSize:Byte;
           ReservedMaskPos:Byte;
           DirectColorModeInfo:Byte;
           PhysBasePtr:LongInt;
           OffscreenMemOffset:LongInt;
           OffscreenMemSize:Word;
           Reserved2:array[1..206] of Byte;
{-- more info --}
           BytesPerPixel:Byte;{ bits div 8 }
           BankSizeKB:LongInt;{ WinSize as LongInt for computing }
         end;

     TColor=LongInt;

const
      colRed:TColor
          =$00ff0000;
      colGreen:TColor
          =$0000ff00;
      colBlue:TColor
          =$000000ff;
      colWhite:TColor
          =$00ffffff;
      colBlack:TColor
          =$00000000;

var
    MInfo:TModeInfo;
procedure   VesaInfo;{ Fill MInfo }
procedure   VesaWriteInfo;
procedure   VesaInit;
procedure   VesaDone;
procedure   PutPixel(x,y:Word; Color:TColor);
procedure   DrawHLine(x1,x2,y:Word; Color:TColor);
procedure   DrawVLine(x,y1,y2:Word; Color:TColor);
procedure   DrawChar8x8(ch:Char; X,Y:Word; Color:TColor);{ uses Font }
procedure   DrawText8x8(s:string; X,Y:Word;Color:TColor);
{--}
function    RGB2Color(r,g,b:Byte):TColor;
function    Color2R(C:TColor):byte;
function    Color2G(C:TColor):byte;
function    Color2B(C:TColor):byte;
{--}
procedure   FillScreen(Color:TColor);
procedure   FillRect(X1,Y1,X2,Y2:Word; Color:TColor);

Implementation
{--- nastav banku ---}

procedure   SetBank(Bank:Word);assembler;

  asm
      mov     ax , 4F05h
      xor     bx , bx
      mov     dx , Bank
      int     10h
  end;
{--- vykresli pixel 32-bit ---}

procedure   PutPixel(x,y:Word;Color:TColor);

  var
      Offset:LongInt;
      Bank,BankOffset:LongInt;
      P:^Byte;

  begin
   Offset:=LongInt(y)*MInfo.BytesPerScanline+LongInt(x)*MInfo.BytesPerPixel;
   Bank:=Offset div (MInfo.BankSizeKB*1024);
   BankOffset:=Offset mod (MInfo.BankSizeKB*1024);
   SetBank(Bank);
   P:=Ptr(MInfo.WinASegment, BankOffset);
                      Move(Color, P^, 4);

  end;
{--- vykresli čáru horizontálně ---}

procedure   DrawHLine(x1,x2,y:Word; Color:TColor);

  var
      i:Word;

  begin
   for i:=x1 to x2 do
       PutPixel(i, y, Color);
  end;
{--- vykresli čáru vertikálně ---}

procedure   DrawVLine(x,y1,y2:Word; Color:TColor);

  var
      i:Word;

  begin
   for i:=y1 to y2 do
       PutPixel(x, i, Color);
  end;
{--- napíše jednoduchý text bitmapově (8x8) ---}

procedure   DrawChar8x8(ch:Char; X,Y:Word; Color:TColor);{ uses Font }

  var
      row,col:Byte;

  begin
   for row:=0 to 7 do
       for col:=0 to 7 do
           if ((Font[row,Ord(ch)] shr (7-col)) and 1)=1 then
              PutPixel(X+col, Y+row, Color)
           else
              PutPixel(X+col, Y+row, colBlack);
  end;
{--- napíše řetězec ---}

procedure   DrawText8x8(s:string; X,Y:Word; Color:TColor);

  var
      i:Byte;

  begin
   for i:=1 to Length(s) do
       begin
        DrawChar8x8(s[i], X+(i-1)*8, Y, Color);
       end;
  end;
{---------------------------------------------------------------------------------------------------------------}

function    RGB2Color(r,g,b:Byte):TColor;

  begin
   RGB2Color:=(LongInt(b)) or (LongInt(g) shl 8) or (LongInt(r) shl 16) or
           $00000000;{ A-byte ignorován }
  end;

function    Color2R(C:TColor):byte;

  begin
   Color2R:=(C shr 16) and $ff;
  end;

function    Color2G(C:TColor):byte;

  begin
   Color2G:=(C shr 8) and $ff;
  end;

function    Color2B(C:TColor):byte;

  begin
   Color2B:=C and $ff;
  end;

procedure   FillScreen(Color:TColor);

  var
      BankCount:Word;
      Bank:Word;
      P:^Byte;
      BytesPerBank:LongInt;
      TotalBytes:LongInt;
      i:LongInt;

  begin
   TotalBytes:=LongInt(MInfo.XRes)*MInfo.YRes*(MInfo.BitsPerPixel div 8);
   BytesPerBank:=MInfo.BankSizeKB*1024;{ počet bank pro celý framebuffer }
   BankCount:=TotalBytes div BytesPerBank;
   if (TotalBytes mod BytesPerBank)<>0 then
      Inc(BankCount);{ připravíme 32bit barvu BGRA }{ projdeme všechny banky }
   for Bank:=0 to BankCount-1 do
       begin
        SetBank(Bank);
        P:=Ptr(MInfo.WinASegment, 0);
{- Naplnění celé banky — ale ne pixel po pixelu! }
{- Naplníme po 4 bytech (jedna barva) přes Move. }
        i:=0;
        while i<BytesPerBank do
              begin
               Move(Color, P^, 4);
               Inc(P, 4);
               Inc(i, 4);
              end;
       end;
  end;
{---------------------------------------------------------------------------------------------------------------}

procedure   FillRect(X1,Y1,X2,Y2:Word; Color:TColor);

  var
      y:Word;
      startOffset,endOffset:LongInt;
      rowStart,rowEnd:LongInt;
      row:LongInt;
      BankBytes:LongInt;
      Bank,NextBank:Longint;
      P:^Byte;
      writeEnd:LongInt;

  begin{ normalizace souřadnic }
   if X2<X1 then
      Exit;
   if Y2<Y1 then
      Exit;
   BankBytes:=LongInt(MInfo.BankSizeKB)*1024;{ každý řádek obdélníku vykreslíme zvlášť }
   for y:=Y1 to Y2 do
       begin{ začátek a konec řádku obdélníku v bajtech vzhledem k framebufferu }
        rowStart:=LongInt(y)*MInfo.BytesPerScanline+LongInt(X1)*MInfo.BytesPerPixel;
        rowEnd:=LongInt(y)*MInfo.BytesPerScanline+LongInt(X2+1)*MInfo.BytesPerPixel;
{-- offset musí být menší než celkový framebuffer, ne kontrolujeme zde }
        row:=rowStart;
        while row<rowEnd do
              begin{ která banka? }
               Bank:=row div BankBytes;
               SetBank(Bank);{ ukazatel do banky }
               P:=Ptr(MInfo.WinASegment, row mod BankBytes);
{-- kolik byte zbývá v této bance? }
               NextBank:=((row div BankBytes)+1)*BankBytes;
{-- do konce banky, nebo do konce řádku obdélníku — co je kratší }
               if rowEnd<NextBank then
                  writeEnd:=rowEnd
               else
                  writeEnd:=NextBank;{ zapisujeme každé 4 byte = 1 pixel barvy }
               while row<writeEnd do
                     begin
                      Move(Color, P^, 4);
                      Inc(P, 4);
                      Inc(row, 4);
                     end;
              end;
       end;
  end;
{---------------------------------------------------------------------------------------------------------------}
{---------------------------------------------------------------------------------------------------------------}
{---------------------------------------------------------------------------------------------------------------}
{--- zjisti mode info pro 0x118 ---}

procedure   VesaInfo;{ Fill MInfo }

  var
      Regs:Registers;

  begin 
   Regs.AX:=$4F01;
   Regs.CX:=$118;
   Regs.ES:=Seg(MInfo);
   Regs.DI:=Ofs(MInfo);
   Intr($10, Regs);
   if Regs.AX<>$004F then 
      begin
       Writeln('VESA mode info not available.');
       Halt(1);
      end;
   MInfo.BytesPerPixel:=MInfo.BitsPerPixel div 8;
   MInfo.BankSizeKB:=MInfo.WinSize;
  end;

procedure   VesaWriteInfo;

  begin 
   writeln(MInfo.XRes, ' x ', MInfo.YRes, ' BytesPerPixel:', MInfo.BytesPerPixel, 
       ' Bank size:', MInfo.BankSizeKB, 'kB Granularity:', MInfo.WinGranularity,
       'kB;');
  end;
{--- nastav bankovaný mód 0x118 ---}

procedure   VesaInit;

  var
      Regs:Registers;

  begin 
   Regs.AX:=$4F02;
   Regs.BX:=$118;{ bez LFB bitu }
   Intr($10, Regs);
   if Regs.AX<>$004F then 
      begin 
       Writeln('Cannot set mode 0x118.');
       Halt(1);
      end;
  end;
{-----------------------------------------------------------}
{--- návrat do text režimu --- }

procedure   VesaDone;

  var
      Regs:Registers;

  begin 
   Regs.AX:=$0003;
   Intr($10, Regs);
  end;

end.