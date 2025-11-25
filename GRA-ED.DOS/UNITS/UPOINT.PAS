
{- vim: ft=pascal:textwidth=125:nowrap 
-}
unit UPoint;

interface 

type
     PPoint=^TPoint;
     TPoint=
       object
         x,y:Integer;

         constructor Init;
         procedure copy(_x,_y:Integer);
         procedure copyP(p:TPoint);
         procedure   move(dx,dy:Integer);
         procedure   moveTo(_x,_y:Integer);
         procedure   moveP(P:TPoint);
         procedure   moveToP(P:TPoint);

       end;


implementation 

constructor TPoint. Init;

  begin 
   x:=0;
   y:=0;
  end;

procedure TPoint. copy(_x,_y:Integer);

  begin 
   x:=_x;
   y:=_y;
  end;

procedure TPoint. copyP(p:TPoint);

  begin 
   x:=p.x;
   y:=p.y;
  end;

procedure   TPoint. move(dx,dy:Integer);

  begin 
   x:=x+dx;
   y:=y+dy;
  end;

procedure   TPoint. moveTo(_x,_y:Integer);

  begin 
   x:=_x;
   y:=_y;
  end;

procedure   TPoint. moveP(P:TPoint);

  begin 
   x:=x+P.x;
   y:=y+P.y;
  end;

procedure   TPoint. moveToP(P:TPoint);

  begin 
   x:=P.x;
   y:=P.y;
  end;

end.
