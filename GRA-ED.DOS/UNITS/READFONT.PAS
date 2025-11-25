unit ReadFont;

interface 

uses
     Tools;

const
      MAX_CHARS=256;
      CHAR_HEIGHT=8;

type
     TFont8x8=array[0..CHAR_HEIGHT-1,0..MAX_CHARS-1] of Byte;

var
    Font:TFont8x8;
procedure   LoadFontFromFile(const FileName:string; var Font:TFont8x8);

implementation 

type
     fc=file of char;

function    ReadHexaByteFromFile(var F:fc):byte;

  var
      b:byte;
      c:char;

  begin 
   ReadHexaByteFromFile:=0;
   b:=0;
   if Eof(f) then 
      exit;
     repeat
       read(f, c);
     until  not (eof(f) or (c in [chr(9),chr(10),chr(13),',',' ']));
   if Eof(f) then 
      exit;
   while c in ['0'..'9','a'..'f','A'..'F','x'] do
         begin 
          b:=(b shl 4)+hex2byte(c);
          read(f, c);
         end;
   ReadHexaByteFromFile:=b;
  end;

procedure   LoadFontFromFile(const FileName:string; var Font:TFont8x8);

  var
      F:FC;
      Line:string;
      CharIndex,RowIndex,PosIndex:Integer;
      Parts:array[0..31] of string;
      Count,I:Integer;

  begin 
   Assign(F, FileName);
   Reset(F);
   for RowIndex:=0 to 7 do
       for CharIndex:=0 to 255 do
           Font[RowIndex,CharIndex]:=ReadHexaByteFromFile(F);
   Close(F);
  end;

end.