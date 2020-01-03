class Space{
 int colour;
 int col; //
 int row;
 //boolean occupied = false;
 //Piece occupant;
 Space(int no){
   
   col = (no % 8) +1;
   row = floor((no)/8) +1;
   if(col%2 ==0 ^ row%2 ==0)
   {
     colour = 230;
   }else{
     colour =0;
   }
 }
  
  void show()
  {
    fill(colour);
    rect((col-1)*(width/8),(row-1)*(height/8), width/8, height/8);
    
  
  }
  
  
  
  
  
  
}