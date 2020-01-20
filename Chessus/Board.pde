class Board {
  Piece[] white = new Piece[16];
  Piece[] black = new Piece[16];

  int score = 0;
  int depth;
  boolean chosen = false;
  int bestPiece;
  int bestCol;
  int bestRow;


  Board(Piece[] b, Piece[] w, int d) {
    //set white and black as clones of b and w
    for (int i =0; i<w.length; i++)
    {
      white[i] = w[i].clone();
    }
    for (int i = 0; i<b.length; i++)
    {
      black[i] = b[i].clone();
    }

    depth = d;
  }

  int getScore()
  {
    score = 0;
    for (int i =0; i<white.length; i++)
    {
      score -= white[i].getValue();
    }
    for (int i = 0; i<black.length; i++)
    {
      score += black[i].getValue();
    }
    return score;
  }
  boolean clearLine(Piece p, int c, int r) {
    int testR = p.posRow;
    int testC = p.posCol;
    while (true)
    {

      if (c > p.posCol)
      {
        testC +=1;
      }
      if (c < p.posCol)
      {
        testC -=1;
      }
      if (r > p.posRow)
      {
        testR +=1;
      }
      if (r < p.posRow)
      {
        testR -=1;
      }
      if (testR == r && testC == c)
      {
        return true;
      }
      for (int i = 0; i<white.length; i++)
      {
        if (!white[i].taken && white[i].posCol == testC && white[i].posRow == testR)
        {
          return false;
        }
      }
      for (int i = 0; i<black.length; i++)
      {
        if (!black[i].taken && black[i].posCol == testC && black[i].posRow == testR)
        {
          return false;
        }
      }
    }
  }

  boolean canMove(Piece p, int c, int r)
  {
    if (c<1 || c>8 || r<1 || r>8 || (c == p.posCol && r ==p.posRow))
    {
      return false;
    }
    if (p.id != "Kn" && !clearLine(p, c, r))
    {
      return false;
    }
    if (p.isWhite) {
      for (int j =0; j< white.length; j++) //set move to false if the space is occupied by a white piece
      {
        if (!white[j].taken && white[j].posCol == c && white[j].posRow == r)
        {
          return false;
        }
      }
    }else{
      for (int j =0; j< black.length; j++) //set move to false if the space is occupied by a black piece
      {
        if (!black[j].taken && black[j].posCol == c && black[j].posRow == r)
        {
          return false;
        }
      }
    }
    switch(p.id) {
    case "p": 
      int moveDistance = 1;
      boolean attack = false;
      if (p.isWhite) {

        for (int i = 0; i<black.length; i++)
        {
          if (!black[i].taken && black[i].posCol == c && black[i].posRow == r)
          {
            attack = true;
          }
        }
      } else {

        for (int i = 0; i<white.length; i++)
        {
          if (!white[i].taken && white[i].posCol == c && white[i].posRow == r)
          {
            attack = true;
          }
        }
      }

      if (attack) {

        if (p.isWhite)
        { 
          if (abs(c-p.posCol) == 1  && r == p.posRow -1)
          {
            return true;
          } else {
            return false;
          }
        } else {
          if (abs(c-p.posCol) == 1  && r == p.posRow +1)
          {
            return true;
          } else {
            return false;
          }
        }
      } else {
        if (p.firstTurn)
        {
          moveDistance = 2;
        }
        if (p.isWhite)
        { 
          if (c == p.posCol && (r == p.posRow - moveDistance || r== p.posRow - 1))
          {
            return true;
          } else {
            return false;
          }
        } else {
          if (c == p.posCol && (r == p.posRow + moveDistance|| r== p.posRow +1))
          {
            return true;
          } else {
            return false;
          }
        }
      }

    case "R":
      if (c == p.posCol || r == p.posRow)
      {
        return true;
      } else {
        return false;
      }

    case "Kn":
      if ((abs(c - p.posCol)==2 && abs(r- p.posRow) ==1) ||(abs(c - p.posCol)==1 && abs(r- p.posRow) ==2))
      {
        return true;
      } else {
        return false;
      }

    case "B":
      if (abs(c- p.posCol)== abs(r-p.posRow))
      {
        return true;
      } else {
        return false;
      }

    case "Q":
      if (abs(c- p.posCol)== abs(r-p.posRow) || (c == p.posCol || r == p.posRow)) {
        return true;
      } else {
        return false;
      }
    case "K":
      if (abs(c- p.posCol) <=1 && abs(r- p.posRow) <=1)
      {
        return true;
      } else {
        return false;
      }
    default:
      return false;
    }
  }
}