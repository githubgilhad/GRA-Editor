unit Tools;

interface 

const
      HexChars:array[0..15] of char
          ='0123456789abcdef';
function    IntToStr(i:integer):string;
function    HexStrToByte(const S:string):Byte;
function    byte2hex(b:byte):string;
function    hex2byte(c:char):byte;

implementation 

function    IntToStr(i:integer):string;

  var
      s:string;

  begin 
   Str(i, s);
   IntToStr:=s;
  end;
{--- prevod hex stringu na byte ---}

function    byte2hex(b:byte):string;

  var
      s:string[2];

  begin 
   s:='  ';
   s[1]:=HexChars[b shr 4];
   s[2]:=HexChars[b and 15];
   byte2hex:=s;
  end;

function    hex2byte(c:char):byte;

  var
      b:byte;

  begin 
   hex2byte:=0;
   if (c>='0') and (c<='9') then 
      hex2byte:=ord(c)-ord('0');
   if (c>='a') and (c<='f') then 
      hex2byte:=10+ord(c)-ord('a');
   if (c>='A') and (c<='F') then 
      hex2byte:=10+ord(c)-ord('F');
  end;

function    HexStrToByte(const S:string):Byte;

  var
      I,Code:Integer;

  begin 
   Val('$'+S, I, Code);
   if code<>0 then 
      I:=0;
   HexStrToByte:=I;
  end;

end.