program VesaDemo;

uses
     Dos,Crt,ReadFont,Tools,VesaGrph;

procedure   DrawDots;

  begin 
   PutPixel(110, 10, 255, 0, 0);
   PutPixel(120, 20, 0, 255, 0);
   PutPixel(130, 30, 0, 0, 255);
   PutPixel(140, 40, 255, 255, 0);
   PutPixel(150, 50, 255, 0, 255);
  end;
{-----------------------------------------------------------}
{-- main program --}

var
    x,y:Word;
    ch:Char;
    XRes,YRes,BytesPerPixel,GranKB:Word;
    BankSizeKB:longint;

begin 
 LoadFontFromFile('font.txt', Font);
 VesaInfo;
 VesaWriteInfo;
 writeln('Press Enter');
 readln;
{-- zapamatuj parametry --}
 XRes:=MInfo.XRes;
 YRes:=MInfo.YRes;
 BytesPerPixel:=MInfo.BitsPerPixel div 8;
 BankSizeKB:=MInfo.WinSize;
 GranKB:=MInfo.WinGranularity;
{--- nastav bankovaný mód 0x118 ---}
 VesaInit;
{--- černá obrazovka ---}
 for y:=0 to YRes-1 do
     for x:=0 to XRes-1 do
         PutPixel(x, y, 0, 0, 0);
{--- červený rámeček ---}
 DrawHLine(100, XRes-100, 100, 255, 0, 0);
 DrawHLine(100, XRes-100, YRes-100, 255, 0, 0);
 DrawVLine(100, YRes-100, 100, 255, 0, 0);
 DrawVLine(100, YRes-100, XRes-100, 255, 0, 0);
{--- modrá čára pod rámečkem ---}
 DrawHLine(100, XRes-100, YRes-90, 0, 0, 255);
{--- barevné body --- }
 DrawDots;
{--- Hello World doprostřed --- }
 DrawText8x8('Hello World', XRes div 2-32, YRes div 2-4, 255, 255, 255);
{--- VESA parametry vlevo nahoře --- }
 DrawText8x8('XRes='+IntToStr(XRes), 10, 10, 255, 255, 255);
 DrawText8x8('YRes='+IntToStr(YRes), 10, 20, 255, 255, 255);
 DrawText8x8('BPP='+IntToStr(MInfo.BitsPerPixel), 10, 30, 255, 255, 255);
 DrawText8x8('BankSizeKB='+IntToStr(BankSizeKB), 10, 40, 255, 255, 255);
 DrawText8x8('GranKB='+IntToStr(GranKB), 10, 50, 255, 255, 255);
{--- čekání na klávesy a výpis kódů --- }
   repeat
     if KeyPressed then 
        begin 
         ch:=ReadKey;
         DrawText8x8('Key='+IntToStr(Ord(ch))+'  ', 10, 60, 255, 255, 255);
        end;
   until ch='q';
 VesaDone;
end.