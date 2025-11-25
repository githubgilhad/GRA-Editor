unit Cursor;

interface 

uses
     VesaGrph;

type
     TCursor=
       object
         x,y:Integer;{ souradnice }
         hidden:boolean;
         origin_x,origin_y:word;{ zde ma 0,0 }
         max_x,max_y:word;{ zde ma 0,0 }
         step_x,step_y:word;{ o kolik se posouva }
         size_x,size_y:word;

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
         procedure   event(c:char);{ zareaguje na znak - pohyby }

       end;


var
    Trace:TColor;

implementation 

constructor TCursor. init(_origin_x,_origin_y:word; _max_x,_max_y:word; _step_x,_step_y:word; 
        _size_x,_size_y:word);

  begin 
   self.origin_x:=_origin_x;
   self.origin_y:=_origin_y;
   self.max_x:=_max_x;
   self.max_y:=_max_y;
   self.step_x:=_step_x;
   self.step_y:=_step_y;
   self.size_x:=_size_x;
   self.size_y:=_size_y;
{--}
   self.x:=0;
   self.y:=0;
   self.fix;
   self.hidden:=false;
  end;

procedure   TCursor. show;

  begin 
   if  not self.hidden then 
      begin 
       FillRect(self.origin_x+self.x*self.step_x, self.origin_y+self.y*self.step_y, 
           self.origin_x+self.x*self.step_x+self.size_x, self.origin_y+self.y*self.step_y+self.size_y, 
           Trace);
       self.draw(colWhite);
      end;
  end;

procedure   TCursor. hide;

  begin 
   if  not self.hidden then 
      self.draw(colBlack);
  end;

procedure   TCursor. fix;{ orizne do limitu }

  begin 
   if self.x>self.max_x then 
      self.x:=0;
   if self.x<0 then 
      self.x:=self.max_x;
   if self.y>self.max_y then 
      self.y:=0;
   if self.y<0 then 
      self.y:=self.max_y;
  end;

procedure   TCursor. move(dx,dy:integer);{ relativni pohyb }

  begin 
   self.hide;
   self.x:=self.x+dx;
   self.y:=self.y+dy;
   self.fix;
   self.show;
  end;

procedure   TCursor. move_to(nx,ny:word);{ absolutni }

  begin 
   self.hide;
   self.x:=nx;
   self.y:=ny;
   self.fix;
   self.show;
  end;

procedure   TCursor. draw(Color:TColor);

  begin 
   DrawHLine(self.origin_x+self.x*self.step_x, self.origin_x+self.x*self.step_x+self.size_x, 
       self.origin_y+self.y*self.step_y, Color);
   DrawHLine(self.origin_x+self.x*self.step_x, self.origin_x+self.x*self.step_x+self.size_x, 
       self.origin_y+self.y*self.step_y+self.size_y, Color);
   DrawVLine(self.origin_x+self.x*self.step_x, self.origin_y+self.y*self.step_y, 
       self.origin_y+self.y*self.step_y+self.size_y, Color);
   DrawVLine(self.origin_x+self.x*self.step_x+self.size_x, self.origin_y+self.y*self.step_y, 
       self.origin_y+self.y*self.step_y+self.size_y, Color);
  end;

procedure   TCursor. event(c:char);{ zareaguje na znak - pohyby }

  begin 
    case c of
         '1':self.move(-1, 1);
         '2':self.move(0, 1);
         '3':self.move(1, 1);
         '4':self.move(-1, 0);
         '6':self.move(1, 0);
         '7':self.move(-1, -1);
         '8':self.move(0, -1);
         '9':self.move(1, -1);

    end ;
  end;

end.