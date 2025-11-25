Program GraphEd;

uses
     Dos,Crt,ReadFont,Tools,VesaGrph,Cursor;
{-----------------------------------------------------------}

var
    cur:TCursor;
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
 cur.init(100, 600,{ origin -} 
 32, 32,{ max -} 
 4, 4,{ step -} 
 4, 4{ size -}
 );
 VesaInit;
 FillScreen(colBlack);
 FillRect(10, 130, 20, 160, colRed);
 Trace:=colRed;
{--- čekání na klávesy a výpis kódů --- }
 DrawText8x8('Use NumKeys for moving, 5 for change, /*-+ for colors, Enter for hide, q for Quit', 
     10, 10, colWhite);
 cur.show;
 ch:=' ';
   repeat
     if KeyPressed then 
        begin 
         ch:=ReadKey;
         DrawText8x8('Key='+IntToStr(Ord(ch))+'  ', 10, 60, colWhite);
         cur.event(ch);
          case ch of
               '5':
                    begin 
                     if Trace=colRed then 
                        Trace:=colBlue
                     else if Trace=colBlue then 
                        Trace:=colGreen
                     else if Trace=colGreen then 
                        Trace:=colWhite
                     else if Trace=colWhite then 
                        Trace:=colBlack
                     else if Trace=colBlack then 
                        Trace:=colRed
                     else 
                        Trace:=colWhite;
                    end;
               '/':Trace:=colRed;
               '*':Trace:=colGreen;
               '-':Trace:=colBlue;
               '+':Trace:=colWhite;
               chr(13):
                    begin 
                     cur.hide;
                     cur.hidden:= not cur.hidden;
                     cur.show;
                    end;

          end ;
         if cur.hidden then 
            DrawText8x8('Cursor hidden  ', 10, 50, colWhite)
         else 
            DrawText8x8('Cursor visible ', 10, 50, colRed);
        end;
   until ch='q';
 VesaDone;
end.