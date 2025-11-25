
{- vim: ft=pascal:textwidth=125:nowrap 
-}
unit Cursor;

interface 

uses
     VesaGrph,UPoint;

type
     TCursor=
       object
         x,y:Integer;{ souradnice }
         origin_x,origin_y:word;{ zde ma 0,0 }
         max_x,max_y:word;{ o kolik muze vys 160,200 }
         step_x,step_y:word;{ o kolik se posouva }
         size_x,size_y:word;
         c_show,c_hide:TColor;
         status,max_status:byte;

         constructor init(_origin_x,_origin_y:word;{ zde ma 0,0 -} 
             _max_x,_max_y:word;{ zde ma 0,0 -} 
             _step_x,_step_y:word;{ o kolik se posouva -} 
             _size_x,_size_y:word);
         procedure   show;
         procedure   hide;
         procedure   fix;{ orizne do limitu }
         procedure   move(dx,dy:integer);{ relativni pohyb }
         procedure   move_to(nx,ny:word);{ absolutni }
         procedure   draw(Color:TColor);
         function    event(c:char):boolean;{ zareaguje na znak - pohyby, true, pokud reagoval }
         procedure   rotate;

       end;


implementation 

constructor TCursor. init(_origin_x,_origin_y:word; _max_x,_max_y:word; _step_x,_step_y:word; 
        _size_x,_size_y:word);

  begin 
   origin_x:=_origin_x;
   origin_y:=_origin_y;
   max_x:=_max_x;
   max_y:=_max_y;
   step_x:=_step_x;
   step_y:=_step_y;
   size_x:=_size_x;
   size_y:=_size_y;
{--}
   x:=0;
   y:=0;
   c_show:=colWhite;
   c_hide:=RGB2Color(20,20,20);
   max_status:=4;
   status:=max_status;
   fix;
  end;

procedure   TCursor. show;

  begin 
   draw(c_show);
  end;

procedure   TCursor. hide;

  begin 
   draw(c_hide);
  end;

procedure   TCursor. fix;{ orizne do limitu }

  begin 
   while x>=max_x do
         x:=x-max_x;
   while x<0 do
         x:=x+max_x;
   while y>=max_y do
         y:=y-max_y;
   while y<0 do
         y:=y+max_y;
  end;

procedure   TCursor. move(dx,dy:integer);{ relativni pohyb }

  begin 
   hide;
   x:=x+dx;
   y:=y+dy;
   fix;
   show;
  end;

procedure   TCursor. move_to(nx,ny:word);{ absolutni }

  begin 
   hide;
   x:=nx;
   y:=ny;
   fix;
   show;
  end;

procedure   TCursor. draw(Color:TColor);

  begin
   DrawHLine(origin_x+x*step_x-1, origin_x+x*step_x+size_x-1, origin_y+y*step_y-1,
       Color);
   DrawHLine(origin_x+x*step_x-1, origin_x+x*step_x+size_x-1, origin_y+y*step_y+size_y-1,
       Color);
   DrawVLine(origin_x+x*step_x-1, origin_y+y*step_y, origin_y+y*step_y+size_y-1,
       Color);
   DrawVLine(origin_x+x*step_x+size_x-1, origin_y+y*step_y, origin_y+y*step_y+size_y-1,
       Color);
  end;

function    TCursor. event(c:char):boolean;{ zareaguje na znak - pohyby, true, pokud reagoval }

  begin
   event:=true;
    case c of
         '1':move(-1, 1);
         '2':move(0, 1);
         '3':move(1, 1);
         '4':move(-1, 0);
         '6':move(1, 0);
         '7':move(-1, -1);
         '8':move(0, -1);
         '9':move(1, -1);
         chr(75):move(-8,0);
         chr(77):move(8,0);
         chr(72):move(0,-8);
         chr(80):move(0,8);
         else
              event:=false;
    end ;
  end;

procedure   TCursor. rotate;

  begin 
   inc(status);
   if status>max_status then 
      status:=0;
  end;

end.
