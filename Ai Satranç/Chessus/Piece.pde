class Piece {
  int posCol;
  int posRow;
  boolean moving  = false;
  String id;
  boolean isWhite;
  boolean firstTurn = true;
  boolean taken = false;
  int value = 0;
  Piece()
  {}
  Piece(int no, boolean white)
  {
    isWhite = white;
    posCol = ((no) % 8)+1;

    if (isWhite)
    {
      posRow = 8 -floor((no)/8);
    } else {
      posRow = 1+floor((no)/8);
    }

    switch(no +1) {
    case 1: 
    case 8:
      id = "R" ;  
      value = 5;
      break;
    case 2: 
    case 7:
      id ="Kn";
      value = 3;
      break;
    case 3: 
    case 6:
      id ="B";
      value = 3;
      break; 
    case 4:
      id ="Q";
      value = 9;
      break;
    case 5:
      id = "K";
      value = 100;
      break;
    case 9: 
    case 10: 
    case 11: 
    case 12: 
    case 13: 
    case 14: 
    case 15: 
    case 16:
      id = "p";
      value = 1;
      break;
    }
  }

  void show()
  {
    if (!taken)
    {
      textAlign(CENTER, CENTER);
      textSize(width/12);


      if (isWhite)
      {
        fill(191, 180, 145);
      } else {
        fill(150, 80, 80);
      }
      //stroke(100);
      if (!moving)
      {
        text(id, posCol*(width/8)-(width/16), (posRow)*(height/8)-(height/16));
      } else {
        text(id, mouseX, mouseY);
      }
    }
  }
  boolean clearLine(int c, int r) {
    int testR = posRow;
    int testC = posCol;
    while (true)
    {

      if (c > posCol)
      {
        testC +=1;
      }
      if (c < posCol)
      {
        testC -=1;
      }
      if (r > posRow)
      {
        testR +=1;
      }
      if (r < posRow)
      {
        testR -=1;
      }
      if (testR == r && testC == c)
      {
        return true;
      }
      for (int i = 0; i<pieces.length; i++)
      {
        if (!pieces[i].taken && pieces[i].posCol == testC && pieces[i].posRow == testR)
        {
          return false;
        }
      }
      for (int i = 0; i<piecesBlack.length; i++)
      {
        if (!piecesBlack[i].taken && piecesBlack[i].posCol == testC && piecesBlack[i].posRow == testR)
        {
          return false;
        }
      }
    }
  }

  boolean canMove(int c, int r)
  {
    if (c<1 || c>8 || r<1 || r>8 || (c == posCol && r ==posRow))
    {
      return false;
    }
    if (id != "Kn" && !clearLine(c, r))
    {
      return false;
    }
    if (isWhite) {
      for (int j =0; j< pieces.length; j++) //set move to false if the space is occupied by a white piece
      {
        if (!pieces[j].taken && pieces[j].posCol == c && pieces[j].posRow == r)
        {
          return false;
        }
      }
    }else{
      for (int j =0; j< piecesBlack.length; j++) //set move to false if the space is occupied by a black piece
      {
        if (!piecesBlack[j].taken && piecesBlack[j].posCol == c && piecesBlack[j].posRow == r)
        {
          return false;
        }
      }
    }
    switch(id) {
    case "p": 
      int moveDistance = 1;
      boolean attack = false;
      if (isWhite) {

        for (int i = 0; i<piecesBlack.length; i++)
        {
          if (!piecesBlack[i].taken && piecesBlack[i].posCol == c && piecesBlack[i].posRow == r)
          {
            attack = true;
          }
        }
      } else {

        for (int i = 0; i<pieces.length; i++)
        {
          if (!pieces[i].taken && pieces[i].posCol == c && pieces[i].posRow == r)
          {
            attack = true;
          }
        }
      }

      if (attack) {

        if (isWhite)
        { 
          if (abs(c-posCol) == 1  && r == posRow -1)
          {
            return true;
          } else {
            return false;
          }
        } else {
          if (abs(c-posCol) == 1  && r == posRow +1)
          {
            return true;
          } else {
            return false;
          }
        }
      } else {
        if (firstTurn)
        {
          moveDistance = 2;
        }
        if (isWhite)
        { 
          if (c == posCol && (r == posRow - moveDistance || r== posRow - 1))
          {
            return true;
          } else {
            return false;
          }
        } else {
          if (c == posCol && (r == posRow + moveDistance|| r== posRow + 1))
          {
            return true;
          } else {
            return false;
          }
        }
      }

    case "R":
      if (c == posCol || r == posRow)
      {
        return true;
      } else {
        return false;
      }

    case "Kn":
      if ((abs(c - posCol)==2 && abs(r- posRow) ==1) ||(abs(c - posCol)==1 && abs(r- posRow) ==2))
      {
        return true;
      } else {
        return false;
      }

    case "B":
      if (abs(c- posCol)== abs(r-posRow))
      {
        return true;
      } else {
        return false;
      }

    case "Q":
      if (abs(c- posCol)== abs(r-posRow) || (c == posCol || r == posRow)) {
        return true;
      } else {
        return false;
      }
    case "K":
      if (abs(c- posCol) <=1 && abs(r- posRow) <=1)
      {
        return true;
      } else {
        return false;
      }
    default:
      return false;
    }
  }

  int getValue() {
    if (taken)
    {
      //print("fuck");
      return 0;
    }else{
      return value;
    }
  }

  //void generateMove() {
  //  switch(id) {
  //  case "p": 
  //    if (canMove(posCol, posRow+1))//black
  //    {
  //      //generate the move
  //    }
  //    if (canMove(posCol, posRow +2))
  //    {
  //      //generate the move and return the score of that board or something
  //    }
  //    if (canMove(posCol+1, posRow+1))
  //    {
  //      //generate the move and return the score of that board or something
  //    }
  //    if (canMove(posCol-1, posRow+1))
  //    {
  //      //generate the move and return the score of that board or something
  //    }
  //    break; 

  //  case "R":
  //    for (int row = 0; row < 8; row++)
  //    {
  //      if (row!=posRow && canMove(posCol, row))
  //      {
  //        //generate the move and return the score of that board or something
  //      }
  //    }
  //    for (int col = 0; col < 8; col++)
  //    {
  //      if (col!= posCol && canMove(col, posRow))
  //      {
  //        //generate the move and return the score of that board or something
  //      }
  //    }
  //    break;

  //  case "Kn":
  //    for (int i=-1; i<2; i+=2)
  //    {
  //      for (int j = -1; j<2; j+=2)
  //      {
  //        if (canMove(posCol+(2*i), posRow+(1*j)))
  //        {
  //          //generate
  //        }
  //        if (canMove(posCol+(1*i), posRow+(2*j)))
  //        {
  //          //generate
  //        }
  //      }
  //    }



  //    //if ((abs(c - posCol)==2 && abs(r- posRow) ==1) ||(abs(c - posCol)==1 && abs(r- posRow) ==2))
  //    //{
  //    //  return true;
  //    //} else {
  //    //  return false;
  //    //}

  //  case "B":
  //    for (int i=1-posCol; i<9-posCol; i+=1)
  //    {
  //      for (int j =-1; j<2; j+=2)
  //      {
  //        if (i!=0) {
  //          if (canMove(posCol +i, posRow+ j*abs(i)))
  //          {
  //            //doshit
  //          }
  //        }
  //      }
  //    }
  //    break;

  //  case "Q":
  //    for (int i=1-posCol; i<9-posCol; i+=1)
  //    {
  //      for (int j =-1; j<2; j+=2)
  //      {
  //        if (i!=0) {
  //          if (canMove(posCol +i, posRow+ j*abs(i)))
  //          {
  //            //doshit
  //          }
  //        }
  //      }
  //    }
  //    for (int row = 0; row < 8; row++)
  //    {
  //      if (row!=posRow && canMove(posCol, row))
  //      {
  //        //generate the move and return the score of that board or something
  //      }
  //    }
  //    for (int col = 0; col < 8; col++)
  //    {
  //      if (col!= posCol && canMove(col, posRow))
  //      {
  //        //generate the move and return the score of that board or something
  //      }
  //    }
  //    break;

  //  case "K":
  //    for(int i =-1; i<2 ; i++)
  //    {
  //      for(int j=-1; j<2; j++)
  //      {
          
  //        if(canMove(posCol+i,posRow+j))
  //        {
  //          //generate
          
  //        }
  //      }
  //    }
      
  //  }
  //}
  
  Piece clone()
  {
    Piece p = new Piece();
    p.posCol = posCol;
    p.posRow = posRow;
    p.isWhite = isWhite;
    p.id = id;
    p.taken = taken;
    p.value = value;
    return p;  
  }
}