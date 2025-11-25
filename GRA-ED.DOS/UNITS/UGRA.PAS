
{- vim: ft=pascal:textwidth=125:nowrap
-}
unit UGRA;

interface 

uses
     VesaGrph,UPoint,Tools;

const
      gra_styles:array[0..4] of char
          ='ASDF?';

type
     TPixel=0..3;
     TPaleta=array[0..3] of 0..15;
     PGRA=^TGRA;
     PPole=^TPole;
     TPole=
       object
         coords:TPoint;
         gra:PGRA;
         pal:TPaleta;
         pixels:array[0..7,0..7] of TPixel;

         constructor Init(_gra:PGRA; at:TPoint; pa:TPaleta; pix:TPixel);
         constructor copy(P:TPole; x,y:Word);
         procedure   fill(pix:TPixel);
         procedure   save(var F:file);
         procedure   load(var F:file);
         procedure   drawBig(P:TPoint);{ at P+coords*4 }
         procedure   drawSmall(P:TPoint);{ at P+coords }
         function    isEqual(P:PPole):boolean;
         function    isNilOrEqual(P:PPole):boolean;

       end;

     TGRA=
       object
         SmallP,BigP:TPoint;
         pal:array[0..15] of TColor;
         defPole:PPole;
         obsah:array[0..19,0..24] of PPole;

         constructor Init;
         procedure   destroy;{ dealokuje vse }
         procedure   save(var F:file);
         procedure   load(var F:file);
         procedure   drawBig;{ at BigP }
         procedure   drawSmall;{ at SmallP }
         function    Pole_RGB_at(x,y:word; st:byte):TColor;
         procedure   Set_pixel(x,y:word; st:byte);

       end;


implementation 

constructor TPole. Init(_gra:PGRA; at:TPoint; pa:TPaleta; pix:TPixel);

  begin 
   gra:=_gra;
   coords.copyP(at);
   pal:=pa;
   fill(pix);
  end;

constructor TPole. copy(P:TPole; x,y:Word);

  var
      Pt:TPoint;
      i,j:byte;

  begin 
   Pt.init;
   Pt.x:=x;
   PT.y:=y;
   Init(P.gra, Pt, P.pal, P.pixels[0,0]);
   for i:=0 to 7 do
       for j:=0 to 7 do
           pixels[i,j]:=P.pixels[i,j];
  end;

procedure   TPole. fill(pix:TPixel);

  var
      i,j:byte;

  begin 
   for i:=0 to 7 do
       for j:=0 to 7 do
           pixels[i,j]:=pix;
  end;

procedure   TPole. save(var F:file);

  begin 
   BlockWrite(F, coords.x, 1);
   BlockWrite(F, coords.y, 1);
   BlockWrite(F, pal, SizeOf(pal));
   BlockWrite(F, pixels, SizeOf(pixels));
  end;

procedure   TPole. load(var F:file);

  var
      i,j:byte;

  begin 
   BlockRead(F, coords.x, 1);
   BlockRead(F, coords.y, 1);
   BlockRead(F, pal, SizeOf(pal));
   BlockRead(F, pixels, SizeOf(pixels));
   write('TPole[', coords.x, ',', coords.y, '] loaded: pal:');
   for i:=0 to 3 do
       write(Long2Hex(pal[i]), ' ');
   writeln;
   for i:=0 to 7 do
       begin 
        for j:=0 to 7 do
            write(Long2Hex(pixels[i,j]), ' ');
        writeln;
       end;
   writeln;
  end;

procedure   TPole. drawBig(P:TPoint);{ at P+coords*4 }

  var
      i,j,k,l:byte;
      c:TColor;

  begin 
   P.move(coords.x*8*3, coords.y*8*3);
   for i:=0 to 7 do
       for j:=0 to 7 do
           begin 
            c:=gra^.pal[pal[pixels[i,j]]];
            for k:=0 to 1 do
                for l:=0 to 1 do
                    PutPixel(P.x+3*i+k, P.y+3*j+l, c);
           end;
  end;

procedure   TPole. drawSmall(P:TPoint);{ at P+coords }

  var
      i,j:byte;
      c:TColor;

  begin 
   P.move(coords.x*8, coords.y*8);
   for i:=0 to 7 do
       for j:=0 to 7 do
           begin 
            c:=gra^.pal[pal[pixels[i,j]]];
            PutPixel(P.x+i, P.y+j, c);
           end;
  end;

function    TPole. isEqual(P:PPole):boolean;

  var
      i,j:byte;

  begin 
   isEqual:=false;
   for i:=0 to 3 do
       if pal[i]<>P^.pal[i] then 
          exit;
   for i:=0 to 7 do
       for j:=0 to 7 do
           if pixels[i,j]<>P^.pixels[i,j] then 
              exit;
   isEqual:=true;
  end;

function    TPole. isNilOrEqual(P:PPole):boolean;

  begin 
   isNilOrEqual:=true;
   if P=Nil then 
      exit;
   isNilOrEqual:=isEqual(P);
  end;

const
      defpal:TPaleta
          =(0,
            1,
            2,
            3);

constructor TGRA. Init;

  var
      i,j:byte;
      P:Tpoint;

  begin 
   BigP.copy(100, 50);
   SmallP.copy(700, 50);
   P.copy(255, 255);
   pal[0]:=0;
   pal[1]:=colRed;
   pal[2]:=colGreen;
   pal[3]:=colBlue;
   new(defPole);
   defPole^.Init(@self, P, defpal, 0);
   for i:=0 to 19 do
       for j:=0 to 24 do
           obsah[i,j]:=Nil;
  end;

procedure   TGRA. destroy;{ dealokuje vse }

  var
      i,j:byte;

  begin 
   dispose(defPole);
   for i:=0 to 159 do
       for j:=0 to 199 do
           dispose(obsah[i,j]);
  end;

procedure   TGRA. save(var F:file);

  var
      i,j:byte;

  begin 
   BlockWrite(F, pal, SizeOf(pal));
   defPole^.save(f);
   for i:=0 to 19 do
       for j:=0 to 24 do
           if  not defPole^.isNilOrEqual(obsah[i,j]) then 
              obsah[i,j]^.save(f);
  end;

procedure   TGRA. load(var F:file);

  var
      i,j:byte;
      pp:PPole;
      P:Tpoint;

  begin 
   P.copy(255, 255);
   BlockRead(F, pal, SizeOf(pal));
   write('TGRA loaded pal:');
   for i:=0 to 15 do
       write(Long2Hex(pal[i]), ' ');
   writeln;
   defPole^.load(f);
   while  not eof(F) do
         begin 
          new(pp);
          pp^.Init(@self, P, defpal, 0);
          pp^.load(F);
          obsah[pp^.coords.x,pp^.coords.y]:=pp;
         end;
  end;

procedure   TGRA. drawBig;{ at BigP }

  var
      i,j:byte;
      c:TColor;

  begin
   c:=RGB2Color(20, 20, 20);
   FillRect(BigP.x-2, BigP.y-2, BigP.x+3*160+2, BigP.y+3*200+2, c);
   DrawHLine(BigP.x-3, BigP.x+3*160+2, BigP.y+3*200+2, RGB2Color(128,128,128));
   DrawHLine(BigP.x-3, BigP.x+3*160+2, BigP.y-3, RGB2Color(255,255,255));
   DrawVLine(BigP.x-3, BigP.y-3,  BigP.y+3*200+2, RGB2Color(255,255,255));
   DrawVLine(BigP.x+3*160+2, BigP.y-2, BigP.y+3*200+2, RGB2Color(128,128,128));
   for i:=0 to 19 do
       for j:=0 to 24 do
           if obsah[i,j]<>Nil then
              obsah[i,j]^.drawBig(BigP);
  end;

procedure   TGRA. drawSmall;{ at SmallP }

  var
      i,j:byte;
      c:TColor;

  begin
   c:=RGB2Color(20, 20, 20);
   FillRect(SmallP.x-2, SmallP.y-2, SmallP.x+160+2, SmallP.y+200+2, c);
   for i:=0 to 19 do
       for j:=0 to 24 do
           if obsah[i,j]<>Nil then 
              obsah[i,j]^.drawSmall(SmallP);
  end;

function    TGRA. Pole_RGB_at(x,y:word; st:byte):TColor;

  begin 
   if obsah[x div 8,y div 8]<>Nil then 
      Pole_RGB_at:=pal[obsah[x div 8,y div 8]^.pal[st]]
   else 
      Pole_RGB_at:=colBlack;
  end;

procedure   TGRA. set_pixel(x,y:word; st:byte);

  var
      pp:PPole;
      P:Tpoint;

  begin 
   if st>3 then 
      exit;
   if obsah[x div 8,y div 8]=Nil then 
      begin 
       P.copy(x div 8, y div 8);
       new(pp);
       pp^.Init(@self, P, defpal, 0);
       obsah[p.x,p.y]:=pp;
      end;
   obsah[x div 8,y div 8]^.pixels[x mod 8,y mod 8]:=st;
   obsah[x div 8,y div 8]^.drawSmall(SmallP);
   obsah[x div 8,y div 8]^.drawBig(BigP);
  end;

end.