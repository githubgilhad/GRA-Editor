
{- vim: ft=pascal:textwidth=125:nowrap 
-}
Program GraphEd;

uses
     Dos,Crt,ReadFont,Tools,VesaGrph,Cursor,UGra,UPoint;
{-----------------------------------------------------------}

var
    F:file;
    gra:TGRA;

var
    cur:TCursor;
{-- main program --}

var
    x,y:Word;
    ch:Char;
    XRes,YRes,BytesPerPixel,GranKB:Word;
    BankSizeKB:longint;

begin
 gra.Init;
 assign(F, 'x.grp');
 Reset(f, 1);
 gra.load(f);
 close(f);
 LoadFontFromFile('font.txt', Font);
 VesaInfo;
 VesaWriteInfo;
 writeln('Press Enter');
 readln;
{-- zapamatuj parametry --}
 XRes:=MInfo.XRes;
 YRes:=MInfo.YRes;
 VesaInit;
 FillScreen(colBlack);
{--- čekání na klávesy a výpis kódů --- }
 DrawText8x8('Use NumKeys for moving, 5 for change, /*-+ for colors, Enter for hide, q for Quit',
     10, 10, colWhite);
 gra.drawBig;
 gra.drawSmall;
 cur.init(100, 50,{ origin -}
 160, 200,{ max -}
 3, 3,{ step -}
 3, 3{ size -}
 );
 cur.show;
 ch:=' ';
   repeat
     if KeyPressed then
        begin
         ch:=ReadKey;
         DrawText8x8('Key='+IntToStr(Ord(ch))+'  ', 10, 30, colWhite);
         if cur.event(ch) and (cur.status<4) then
            begin
             gra.set_pixel(cur.x, cur.y, cur.status);
{-             gra.drawBig(Pt1);
             gra.drawSmall(Pt2); -}
             cur.show;
            end;
          case ch of
               '5':cur.rotate;
               'a','/':cur.status:=0;
               's','*':cur.status:=1;
               'd','-':cur.status:=2;
               'f','+':cur.status:=3;
               '0':cur.status:=4;
               chr(13):cur.rotate;

          end ;
         if cur.status>3 then 
            begin 
             DrawText8x8('Moving    ', 10, 20, colWhite);
             FillRect(10, 40, 20, 50, colWhite);
             FillRect(12, 42, 18, 48, colBlack);
            end
         else 
            begin 
             DrawText8x8('Drawing '+gra_styles[cur.status]+' ', 10, 20, colRed);
             FillRect(10, 40, 20, 50, gra.Pole_RGB_at(cur.x, cur.y, cur.status));
            end;
        end;
   until ch='q';
 VesaDone;
 assign(F, 'y.grp');
 Rewrite(f, 1);
 gra.save(f);
 close(f);
end.