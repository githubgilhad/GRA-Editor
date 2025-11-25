program GrafDemo;

uses Graph, Crt;

var
  gd, gm : Integer;
  x, y   : Integer;
  s,s1,s2:string;

begin
  gd := Detect;
  InitGraph(gd, gm, '.'); { nebo cesta k BGI, např. 'C:\BP\BGI\' }

  if GraphResult <> grOk then
  begin
    Writeln('Chyba grafiky: ', GraphErrorMsg(GraphResult));
    Halt(1);
  end;

  { souřadnice středu }
  x := GetMaxX div 2;
  y := GetMaxY div 2;

  { pozadí }
  SetBkColor(Black);
  ClearDevice;

  { různé barvy čar }
  SetColor(LightRed);   Line(0,        0,        GetMaxX, GetMaxY);
  SetColor(LightBlue);  Line(GetMaxX,  0,        0,        GetMaxY);
  SetColor(Yellow);     Line(0,        y,        GetMaxX,  y);
  SetColor(LightGreen); Line(x,        0,        x,        GetMaxY);

  { bod uprostřed }
  PutPixel(x, y, White);

  { text doprostřed obrazovky }
  SetTextStyle(DefaultFont, HorizDir, 2);
  SetColor(White);
  OutTextXY(x - TextWidth('Hello world') div 2,
            y - TextHeight('Hello world') div 2,
            'Hello world');

  Str(GetMaxX,s1);
  Str(GetMaxY,s2);
  s:=s1+' x '+s2;
  OutTextXY( 10, 10, s);
  Str(gd,s1);Str(gm,s2);s:=s1+':'+s2;
  OutText(s);
  { čekání na klávesu }
  ReadLn;

  CloseGraph;
end.
