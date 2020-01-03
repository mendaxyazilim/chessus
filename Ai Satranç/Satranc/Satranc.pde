Space[] spaces = new Space[64]; //all black and white spaces
Piece[] pieces = new Piece[16];//all white pieces
Piece[] piecesBlack = new Piece[16]; // all black pieces
boolean movingPiece = false; //if a peice is currently bwing moved
int pieceBeingMoved; //the piece being move
boolean whiteTurn = true; //is the piece being moved white
int score = 0;
int maxDepth = 3;
int turnNumber = 1; //the turn number for black 

void setup() {
  size(600, 600);
  for (int i = 0; i< spaces.length; i++) //initialise spaces
  {
    spaces[i] = new Space(i);
  }
  for (int i = 0; i< pieces.length; i++)//initialise white pieces
  {
    pieces[i] = new Piece(i, true);
  }
  for (int i = 0; i< piecesBlack.length; i++)//initialise black pieces
  {
    piecesBlack[i] = new Piece(i, false);
  }
}


void draw() {
  background(255);
  //show all spaces and pieces
  for (int i = 0; i< spaces.length; i++)
  {
    spaces[i].show();
  }
  for (int i = 0; i< pieces.length; i++)
  {
    pieces[i].show();
  }
  for (int i = 0; i< piecesBlack.length; i++)
  {
    piecesBlack[i].show();
  }
  fill(100);
  text(score, width/8, height/8);
}

void mousePressed() {
  if (!movingPiece) { //if a piece isnt already being moved then check if a piece is being clicked on
    for (int i =0; i< pieces.length; i++)
    {
      if (whiteTurn && !pieces[i].taken && dist(mouseX, mouseY, pieces[i].posCol*(width/8)-(width/16), pieces[i].posRow*(height/8)-(height/16))<(width/20)) //if clicking on a piece which isnt taken 
      {
        //set the piecce to moving which will make it follow the mouse
        pieces[i].moving = true;
        movingPiece = true;//set global variable
        pieceBeingMoved = i;//identify the piece being moved
        //whiteTurn = true;
        break;
      }
    }
    //for (int i =0; i< piecesBlack.length; i++) //do the same for black pieces
    //{
    //  if (!whiteTurn && !piecesBlack[i].taken && dist(mouseX, mouseY, piecesBlack[i].posCol*(width/8)-50, piecesBlack[i].posRow*(height/8)-50)<40)
    //  {
    //    piecesBlack[i].moving = true;
    //    movingPiece = true;
    //    pieceBeingMoved = i;
    //    //whiteTurn = false;
    //    break;
    //  }
    //}
  } else { //if a piece is already in hand
    for (int i =0; i< spaces.length; i++) // get the space clicked on
    {
      if (dist(mouseX, mouseY, spaces[i].col*(width/8)-(width/16), spaces[i].row*(height/8)-(height/16))<(width/20))
      {
        boolean move = true; //whether the move can be done
        if (whiteTurn) { // if its whites turn
          //set move as false if the space is occupied by a white piece, cannot move to a space with whites own piece on it
          for (int j =0; j< pieces.length; j++)
          {
            if (!pieces[j].taken && pieces[j].posCol == spaces[i].col && pieces[j].posRow == spaces[i].row)
            {
              move = false;
              break;
            }
          }
          //if move is allowed and it obeys the rules of the pieces moves then move the piece 
          if (move && pieces[pieceBeingMoved].canMove(spaces[i].col, spaces[i].row))
          {

            for (int j =0; j< piecesBlack.length; j++) //if moved to a black piece remove that piece
            {
              if (!piecesBlack[j].taken && piecesBlack[j].posCol == spaces[i].col && piecesBlack[j].posRow == spaces[i].row)
              {
                piecesBlack[j].taken = true;
                setScore();
                break;
              }
            }

            //drop and move the piece
            pieces[pieceBeingMoved].firstTurn = false;
            pieces[pieceBeingMoved].posRow = spaces[i].row;
            pieces[pieceBeingMoved].posCol = spaces[i].col;
            pieces[pieceBeingMoved].moving = false;
            movingPiece = false;
            whiteTurn = false;
            //draw();
            //delay(100);
            blackMove();
            break;
          }
        }
        //if (!whiteTurn) //if the mouse is holding a black piece
        //{

        //  for (int j =0; j< piecesBlack.length; j++) //set move to false if the space is occupied by a black piece
        //  {
        //    if (piecesBlack[j].taken == false && piecesBlack[j].posCol == spaces[i].col && piecesBlack[j].posRow == spaces[i].row)
        //    {
        //      move = false;
        //      break;
        //    }
        //  }

        //  if (move && piecesBlack[pieceBeingMoved].canMove(spaces[i].col, spaces[i].row)) //if can be moved too that spot
        //  {
        //    for (int j =0; j< pieces.length; j++)//if there is a white piece on that spot then remove it
        //    {
        //      if (pieces[j].posCol == spaces[i].col && pieces[j].posRow == spaces[i].row)
        //      {
        //        pieces[j].taken = true;
        //        setScore();
        //        break;
        //      }
        //    }
        //    //drop the balck piece
        //    piecesBlack[pieceBeingMoved].posRow = spaces[i].row;
        //    piecesBlack[pieceBeingMoved].posCol = spaces[i].col;
        //    piecesBlack[pieceBeingMoved].moving = false;
        //    piecesBlack[pieceBeingMoved].firstTurn = false;
        //    movingPiece = false;
        //    whiteTurn = true;
        //    break;
        //  }
        //}
      }
    }
    if (movingPiece == true)
    {
      if (whiteTurn)
      {
        pieces[pieceBeingMoved].moving = false;
        movingPiece = false;
      } else {
        piecesBlack[pieceBeingMoved].moving = false;
        movingPiece = false;
      }
    }
  }
}

void setScore() {
  score =0;
  for (int i =0; i< pieces.length; i++)
  {
    score -= pieces[i].getValue();
  }

  for (int i =0; i< piecesBlack.length; i++)
  {
    score += piecesBlack[i].getValue();
  }
}
void blackMove() {
  Board CurrentBoard = new Board(piecesBlack, pieces, 0);
  maxDepth = 4;
  if (turnNumber == 1)
  {
    CurrentBoard.bestPiece = 11;
    CurrentBoard.bestCol = 4;
    CurrentBoard.bestRow = 4;
  } else {
    println("value goin for " + getMaxAB(CurrentBoard, -10000, 10000));
    //print("by moving piece:" + CurrentBoard.bestPiece);
    print("by moving piece:" + CurrentBoard.bestPiece + " to cr " + CurrentBoard.bestCol + " " + CurrentBoard.bestRow);
  }
  piecesBlack[CurrentBoard.bestPiece].firstTurn = false;
  piecesBlack[CurrentBoard.bestPiece].posCol = CurrentBoard.bestCol; 
  piecesBlack[CurrentBoard.bestPiece].posRow = CurrentBoard.bestRow; 
  for (int j =0; j< pieces.length; j++)//if there is a white piece on that spot then remove it
  {
    if (pieces[j].posCol == CurrentBoard.bestCol && pieces[j].posRow == CurrentBoard.bestRow)
    {
      pieces[j].taken = true;
      setScore();
      break;
    }
  }
  turnNumber +=1;
  whiteTurn = true;
}

int getMaxAB(Board b, int alpha, int beta)
{

  //int winningPiece = 0;
  if (b.depth == maxDepth) // if at the max depth get the score of the board and send it back up the recursion
  {
    println("Depth: " + b.depth + " = " + b.getScore());
    return b.getScore();
  }
  //if not set the board value as 1000 ie infinity
  b.score = -1000;
  Board newB;
  int child;
  for (int n = b.black.length -1; n >=0; n--) //for each piece generate all moves and call min 
  {
    println("test piece " + n);
    if (!b.black[n].taken) {

      switch(b.black[n].id) {
      case "p": //if the current piece is a pawn
        if (b.canMove(b.black[n], b.black[n].posCol, b.black[n].posRow +2))
        {
          newB = new Board(b.black, b.white, b.depth +1);
          newB.black[n].posRow +=2;
          for (int j =0; j< newB.white.length; j++) //if moved to a position with a white piece on it take it
          {
            if (!newB.white[j].taken && newB.white[j].posCol == newB.black[n].posCol && newB.white[j].posRow == newB.black[n].posRow)
            {
              println("take " + newB.white[j].id);
              newB.white[j].taken = true;
              break;
            }
          }
          newB.black[n].firstTurn = false;
          child = getMinAB(newB, alpha, beta);
          if (b.score < child) {
            b.score = child;
            newB.chosen = true;
            b.bestPiece = n;
            b.bestCol = newB.black[n].posCol;
            b.bestRow = newB.black[n].posRow;
          }
          if (child >= beta) {
            return b.score;
          }
          if (child > alpha) {
            alpha = child;
          }
          //generate the move and return the score of that board or something
        }
        if (b.canMove(b.black[n], b.black[n].posCol, b.black[n].posRow+1))//if the pawn can move 1 space forward
        {
          newB = new Board(b.black, b.white, b.depth +1);//create a new board with the same pieces as the current one
          newB.black[n].posRow +=1; //move the piece -------------------------------------------you need to ddo more than move the piece
          for (int j =0; j< newB.white.length; j++) //if moved to a position with a white piece on it take it
          {
            if (!newB.white[j].taken && newB.white[j].posCol == newB.black[n].posCol && newB.white[j].posRow == newB.black[n].posRow)
            {
              println("take " + newB.white[j].id);
              newB.white[j].taken = true;
              break;
            }
          }
          newB.black[n].firstTurn = false;
          child = getMinAB(newB, alpha, beta); //get the best move for the white player
          if (b.score < child) { //if this is the best score for black
            b.score = child;//set the score to be the score of this child
            newB.chosen = true; // set the best piece and move for this board
            b.bestPiece = n;
            b.bestCol = newB.black[n].posCol;
            b.bestRow = newB.black[n].posRow;
          }
          if (child >= beta) {//if the score is better than the current best move for white then white will never oog down this branch therefore return.
            return b.score;
          }
          if (child > alpha) {//if the move is the current best move for black
            alpha = child;
          }
        }
        
        if (b.canMove(b.black[n], b.black[n].posCol+1, b.black[n].posRow+1))
        {
          newB = new Board(b.black, b.white, b.depth +1);
          newB.black[n].posRow +=1;
          newB.black[n].posCol +=1;
          for (int j =0; j< newB.white.length; j++) //if moved to a position with a white piece on it take it
          {
            if (!newB.white[j].taken && newB.white[j].posCol == newB.black[n].posCol && newB.white[j].posRow == newB.black[n].posRow)
            {
              println("take " + newB.white[j].id);
              newB.white[j].taken = true;
              break;
            }
          }
          newB.black[n].firstTurn = false;
          child = getMinAB(newB, alpha, beta);
          if (b.score < child) {
            b.score = child;
            newB.chosen = true;
            b.bestPiece = n;
            b.bestCol = newB.black[n].posCol;
            b.bestRow = newB.black[n].posRow;
          }
          if (child >= beta) {
            return b.score;
          }
          if (child > alpha) {
            alpha = child;
          }
          //generate the move and return the score of that board or something
        }
        if (b.canMove(b.black[n], b.black[n].posCol-1, b.black[n].posRow+1))
        {
          newB = new Board(b.black, b.white, b.depth +1);
          newB.black[n].posRow +=1;
          newB.black[n].posCol -=1;
          for (int j =0; j< newB.white.length; j++) //if moved to a position with a white piece on it take it
          {
            if (!newB.white[j].taken && newB.white[j].posCol == newB.black[n].posCol && newB.white[j].posRow == newB.black[n].posRow)
            {
              println("take " + newB.white[j].id);
              newB.white[j].taken = true;
              break;
            }
          }
          newB.black[n].firstTurn = false;
          child = getMinAB(newB, alpha, beta);
          if (b.score < child) {
            b.score = child;
            newB.chosen = true;
            b.bestPiece = n;
            b.bestCol = newB.black[n].posCol;
            b.bestRow = newB.black[n].posRow;
          }
          if (child >= beta) {
            return b.score;
          }
          if (child > alpha) {
            alpha = child;
          }
          //generate the move and return the score of that board or something
        }
        break; 

      case "R":
        for (int row = 1; row < 9; row++)
        {
          if (row!=b.black[n].posRow && b.canMove(b.black[n], b.black[n].posCol, row))
          {
            newB = new Board(b.black, b.white, b.depth +1);
            newB.black[n].posRow = row;
            // newB.black[n].posCol +=1;
            for (int j =0; j< newB.white.length; j++) //if moved to a position with a white piece on it take it
            {
              if (!newB.white[j].taken && newB.white[j].posCol == newB.black[n].posCol && newB.white[j].posRow == newB.black[n].posRow)
              {
                println("take " + newB.white[j].id);
                newB.white[j].taken = true;
                break;
              }
            }
            newB.black[n].firstTurn = false;
            child = getMinAB(newB, alpha, beta);
            if (b.score < child) {
              b.score = child;
              newB.chosen = true;
              b.bestPiece = n;
              b.bestCol = newB.black[n].posCol;
              b.bestRow = newB.black[n].posRow;
            }
            if (child >= beta) {
              return b.score;
            }
            if (child > alpha) {
              alpha = child;
            }
            //generate the move and return the score of that board or something
          }
        }
        for (int col = 1; col < 9; col++)
        {
          if (col!= b.black[n].posCol && b.canMove(b.black[n], col, b.black[n].posRow))
          {
            newB = new Board(b.black, b.white, b.depth +1);
            //newB.black[n].posRow -=1;
            newB.black[n].posCol = col;
            for (int j =0; j< newB.white.length; j++) //if moved to a position with a white piece on it take it
            {
              if (!newB.white[j].taken && newB.white[j].posCol == newB.black[n].posCol && newB.white[j].posRow == newB.black[n].posRow)
              {
                println("take " + newB.white[j].id);
                newB.white[j].taken = true;
                break;
              }
            }
            newB.black[n].firstTurn = false;
            child = getMinAB(newB, alpha, beta);
            if (b.score < child) {
              b.score = child;
              newB.chosen = true;
              b.bestPiece = n;
              b.bestCol = newB.black[n].posCol;
              b.bestRow = newB.black[n].posRow;
              ;
            }
            if (child >= beta) {
              return b.score;
            }
            if (child > alpha) {
              alpha = child;
            }
            //generate the move and return the score of that board or something
          }
        }
        break;

      case "Kn":
        for (int i=-1; i<2; i+=2)
        {
          for (int j = -1; j<2; j+=2)
          {
            if (b.canMove(b.black[n], b.black[n].posCol+(2*i), b.black[n].posRow+(1*j)))
            {
              newB = new Board(b.black, b.white, b.depth +1);
              newB.black[n].posCol += (2*i);
              newB.black[n].posRow += 1*j;
              for (int h =0; h< newB.white.length; h++) //if moved to a position with a white piece on it take it
              {
                if (!newB.white[h].taken && newB.white[h].posCol == newB.black[n].posCol && newB.white[h].posRow == newB.black[n].posRow)
                {
                  println("take " + newB.white[h].id);
                  newB.white[h].taken = true;
                  break;
                }
              }
              newB.black[n].firstTurn = false;
              child = getMinAB(newB, alpha, beta);
              if (b.score < child) {
                b.score = child;
                newB.chosen = true;
                b.bestPiece = n;
                b.bestCol = newB.black[n].posCol;
                b.bestRow = newB.black[n].posRow;
              }
              if (child >= beta) {
                return b.score;
              }
              if (child > alpha) {
                alpha = child;
              }
              //generate
            }
            if (b.canMove(b.black[n], b.black[n].posCol+(1*i), b.black[n].posRow+(2*j)))
            {
              newB = new Board(b.black, b.white, b.depth +1);
              newB.black[n].posCol += (1*i);
              newB.black[n].posRow += 2*j;
              for (int h =0; h< newB.white.length; h++) //if moved to a position with a white piece on it take it
              {
                if (!newB.white[h].taken && newB.white[h].posCol == newB.black[n].posCol && newB.white[h].posRow == newB.black[n].posRow)
                {
                  println("take " + newB.white[h].id);
                  newB.white[h].taken = true;
                  break;
                }
              }
              newB.black[n].firstTurn = false;
              child = getMinAB(newB, alpha, beta);
              if (b.score < child) {
                b.score = child;
                newB.chosen = true;
                b.bestPiece = n;
                b.bestCol = newB.black[n].posCol;
                b.bestRow = newB.black[n].posRow;
              }
              if (child >= beta) {
                return b.score;
              }
              if (child > alpha) {
                alpha = child;
                //generate
              }
            }
          }
        }
        break;



        //if ((abs(c - posCol)==2 && abs(r- posRow) ==1) ||(abs(c - posCol)==1 && abs(r- posRow) ==2))
        //{
        //  return true;
        //} else {
        //  return false;
        //}

      case "B":
        for (int i=1-b.black[n].posCol; i<9-b.black[n].posCol; i++)
        {
          for (int j =-1; j<2; j+=2)
          {
            if (i!=0) {
              if (b.canMove(b.black[n], b.black[n].posCol +i, b.black[n].posRow+ j*abs(i)))
              {
                newB = new Board(b.black, b.white, b.depth +1);
                newB.black[n].posCol += i;
                newB.black[n].posRow += j*abs(i);
                for (int h =0; h< newB.white.length; h++) //if moved to a position with a white piece on it take it
                {
                  if (!newB.white[h].taken &&newB.white[h].posCol == newB.black[n].posCol && newB.white[h].posRow == newB.black[n].posRow)
                  {
                    println("take " + newB.white[h].id);
                    newB.white[h].taken = true;
                    break;
                  }
                }
                newB.black[n].firstTurn = false;
                child = getMinAB(newB, alpha, beta);
                if (b.score < child) {
                  b.score = child;
                  newB.chosen = true;
                  b.bestPiece = n;
                  b.bestCol = newB.black[n].posCol;
                  b.bestRow = newB.black[n].posRow;
                }
                if (child >= beta) {
                  return b.score;
                }
                if (child > alpha) {
                  alpha = child;
                  //doshit
                }
              }
            }
          }
        }
        break;

      case "Q":
        for (int i=1-b.black[n].posCol; i<9-b.black[n].posCol; i+=1)
        {
          for (int j =-1; j<2; j+=2)
          {
            if (i!=0) {
              if (b.canMove(b.black[n], b.black[n].posCol +i, b.black[n].posRow+ j*abs(i)))
              {
                newB = new Board(b.black, b.white, b.depth +1);
                newB.black[n].posCol += i;
                newB.black[n].posRow += j*abs(i);
                for (int h =0; h< newB.white.length; h++) //if moved to a position with a white piece on it take it
                {
                  if (!newB.white[h].taken && newB.white[h].posCol == newB.black[n].posCol && newB.white[h].posRow == newB.black[n].posRow)
                  {
                    println("take " + newB.white[h].id);
                    newB.white[h].taken = true;
                    break;
                  }
                }
                newB.black[n].firstTurn = false;
                child = getMinAB(newB, alpha, beta);
                if (b.score < child) {
                  b.score = child;
                  newB.chosen = true;
                  b.bestPiece = n;
                  b.bestCol = newB.black[n].posCol;
                  b.bestRow = newB.black[n].posRow;
                }
                if (child >= beta) {
                  return b.score;
                }
                if (child > alpha) {
                  alpha = child;
                }
              }
            }
          }
        }
        for (int row = 1; row < 9; row++)
        {
          if (row!=b.black[n].posRow && b.canMove(b.black[n], b.black[n].posCol, row))
          {
            newB = new Board(b.black, b.white, b.depth +1);
            newB.black[n].posRow = row;
            // newB.black[n].posCol +=1;
            for (int j =0; j< newB.white.length; j++) //if moved to a position with a white piece on it take it
            {
              if (!newB.white[j].taken && newB.white[j].posCol == newB.black[n].posCol && newB.white[j].posRow == newB.black[n].posRow)
              {
                println("take " + newB.white[j].id);
                newB.white[j].taken = true;
                break;
              }
            }
            newB.black[n].firstTurn = false;
            child = getMinAB(newB, alpha, beta);
            if (b.score < child) {
              b.score = child;
              newB.chosen = true;
              b.bestPiece = n;
              b.bestCol = newB.black[n].posCol;
              b.bestRow = newB.black[n].posRow;
            }
            if (child >= beta) {
              return b.score;
            }
            if (child > alpha) {
              alpha = child;
            }
            //generate the move and return the score of that board or something
          }
        }
        for (int col = 1; col < 9; col++)
        {
          if (col!= b.black[n].posCol && b.canMove(b.black[n], col, b.black[n].posRow))
          {
            newB = new Board(b.black, b.white, b.depth +1);
            //newB.black[n].posRow -=1;
            newB.black[n].posCol = col;
            for (int j =0; j< newB.white.length; j++) //if moved to a position with a white piece on it take it
            {
              if (!newB.white[j].taken && newB.white[j].posCol == newB.black[n].posCol && newB.white[j].posRow == newB.black[n].posRow)
              {
                println("take " + newB.white[j].id);
                newB.white[j].taken = true;
                break;
              }
            }
            newB.black[n].firstTurn = false;
            child = getMinAB(newB, alpha, beta);
            if (b.score < child) {
              b.score = child;
              newB.chosen = true;
              b.bestPiece = n;
              b.bestCol = newB.black[n].posCol;
              b.bestRow = newB.black[n].posRow;
            }
            if (child >= beta) {
              return b.score;
            }
            if (child > alpha) {
              alpha = child;
            }
            //generate the move and return the score of that board or something
          }
        }
        break;

      case "K":
        for (int i =-1; i<2; i++)
        {
          for (int j=-1; j<2; j++)
          {

            if (b.canMove(b.black[n], b.black[n].posCol+i, b.black[n].posRow+j))
            {
              newB = new Board(b.black, b.white, b.depth +1);
              newB.black[n].posCol+= i;
              newB.black[n].posRow += j;
              for (int h =0; h< newB.white.length; h++) //if moved to a position with a white piece on it take it
              {
                if (!newB.white[h].taken && newB.white[h].posCol == newB.black[n].posCol && newB.white[h].posRow == newB.black[n].posRow)
                {
                  println("take " + newB.white[h].id);
                  newB.white[h].taken = true;
                  break;
                }
              }
              newB.black[n].firstTurn = false;
              child = getMinAB(newB, alpha, beta);
              if (b.score < child) {
                b.score = child;
                newB.chosen = true;
                b.bestPiece = n;
                b.bestCol = newB.black[n].posCol;
                b.bestRow = newB.black[n].posRow;
              }
              if (child >= beta) {
                return b.score;
              }
              if (child > alpha) {
                alpha = child;
              }
              //generate
            }
          }
        }
        break;
      }
    }
  }

  return b.score;
}

int getMinAB(Board b, int alpha, int beta)
{

  //int winningPiece = 0;
  if (b.depth == maxDepth) // if at the max depth get the score of the board and send it back up the recursion
  {
    println("min at depth: " + b.depth +  " = " + b.getScore());
    //println(b.getScore());
    return b.getScore();
  }
  //if not set the board value as 1000 ie infinity
  b.score = 1000;
  Board newB;


  for (int n = 0; n < b.black.length; n++) //for each piece generate all moves and call min 
  {
    if (!b.white[n].taken) {
      int child;
      switch(b.white[n].id) {
      case "p": //if the current piece is a pawn
        if (b.canMove(b.white[n], b.white[n].posCol, b.white[n].posRow-1))//if the pawn can move 1 space forward
        {
          newB = new Board(b.black, b.white, b.depth +1);//create a new board with the same pieces as the current one
          newB.white[n].posRow -=1; //move the piece
          for (int j =0; j< newB.black.length; j++) //if moved to a position with a white piece on it take it
          {
            if (!newB.black[j].taken && newB.black[j].posCol == newB.white[n].posCol && newB.black[j].posRow == newB.white[n].posRow)
            {
              newB.black[j].taken = true;
              break;
            }
          }
          newB.white[n].firstTurn = false;
          child = getMaxAB(newB, alpha, beta); //get the best move for the white player
          if (b.score > child) { //if this is the best score for black
            b.score = child;//set the score to be the score of this child
            newB.chosen = true; // set the best piece and move for this board
            b.bestPiece = n;
            b.bestCol = newB.white[n].posCol;
            b.bestRow = newB.white[n].posRow;
          }
          if (child <= alpha) {//if the score is better than the current best move for black then black will never oog down this branch therefore return.
            return b.score;
          }
          if (child < beta) {//if the move is the current best move for white
            beta = child;
          }
        }
        if (b.canMove(b.white[n], b.white[n].posCol, b.white[n].posRow -2))
        {
          newB = new Board(b.black, b.white, b.depth +1);
          newB.white[n].posRow -=2;
          for (int j =0; j< newB.black.length; j++) //if moved to a position with a white piece on it take it
          {
            if (!newB.black[j].taken && newB.black[j].posCol == newB.white[n].posCol && newB.black[j].posRow == newB.white[n].posRow)
            {
              newB.black[j].taken = true;
              break;
            }
          }
          newB.white[n].firstTurn = false;
          child = getMaxAB(newB, alpha, beta);
          if (b.score > child) {
            b.score = child;
            newB.chosen = true;
            b.bestPiece = n;
            b.bestCol = newB.white[n].posCol;
            b.bestRow = newB.white[n].posRow;
          }
          if (child <= alpha) {
            return b.score;
          }
          if (child < beta) {
            beta = child;
          }
          //generate the move and return the score of that board or something
        }
        if (b.canMove(b.white[n], b.white[n].posCol+1, b.white[n].posRow-1))
        {
          newB = new Board(b.black, b.white, b.depth +1);
          newB.white[n].posRow -=1;
          newB.white[n].posCol +=1;
          for (int j =0; j< newB.black.length; j++) //if moved to a position with a white piece on it take it
          {
            if (!newB.black[j].taken && newB.black[j].posCol == newB.white[n].posCol && newB.black[j].posRow == newB.white[n].posRow)
            {
              newB.black[j].taken = true;
              break;
            }
          }
          newB.white[n].firstTurn = false;
          child = getMaxAB(newB, alpha, beta);
          if (b.score > child) {
            b.score = child;
            newB.chosen = true;
            b.bestPiece = n;
            b.bestCol = newB.white[n].posCol;
            b.bestRow = newB.white[n].posRow;
          }
          if (child <= alpha) {
            return b.score;
          }
          if (child < beta) {
            beta = child;
          }
          //generate the move and return the score of that board or something
        }
        if (b.canMove(b.white[n], b.white[n].posCol-1, b.white[n].posRow-1))
        {
          newB = new Board(b.black, b.white, b.depth +1);
          newB.white[n].posRow -=1;
          newB.white[n].posCol -=1;
          for (int j =0; j< newB.black.length; j++) //if moved to a position with a white piece on it take it
          {
            if (!newB.black[j].taken && newB.black[j].posCol == newB.white[n].posCol && newB.black[j].posRow == newB.white[n].posRow)
            {
              newB.black[j].taken = true;
              break;
            }
          }
          newB.white[n].firstTurn = false;
          child = getMaxAB(newB, alpha, beta);
          if (b.score > child) {
            b.score = child;
            newB.chosen = true;
            b.bestPiece = n;
            b.bestCol = newB.white[n].posCol;
            b.bestRow = newB.white[n].posRow;
          }
          if (child <= alpha) {
            return b.score;
          }
          if (child < beta) {
            beta = child;
          }
          //generate the move and return the score of that board or something
        }
        break; 

      case "R":
        for (int row = 1; row < 9; row++)
        {
          if (row!=b.white[n].posRow && b.canMove(b.white[n], b.white[n].posCol, row))
          {
            newB = new Board(b.black, b.white, b.depth +1);
            newB.white[n].posRow = row;
            // newB.black[n].posCol +=1;
            for (int j =0; j< newB.black.length; j++) //if moved to a position with a white piece on it take it
            {
              if (!newB.black[j].taken && newB.black[j].posCol == newB.white[n].posCol && newB.black[j].posRow == newB.white[n].posRow)
              {
                newB.black[j].taken = true;
                break;
              }
            }
            newB.white[n].firstTurn = false;
            child = getMaxAB(newB, alpha, beta);
            if (b.score > child) {
              b.score = child;
              newB.chosen = true;
              b.bestPiece = n;
              b.bestCol = newB.white[n].posCol;
              b.bestRow = newB.white[n].posRow;
            }
            if (child <= alpha) {
              return b.score;
            }
            if (child < beta) {
              beta = child;
            }
            //generate the move and return the score of that board or something
          }
        }
        for (int col = 1; col < 9; col++)
        {
          if (col!= b.white[n].posCol && b.canMove(b.white[n], col, b.white[n].posRow))
          {
            newB = new Board(b.black, b.white, b.depth +1);
            //newB.black[n].posRow -=1;
            newB.white[n].posCol = col;
            for (int j =0; j< newB.black.length; j++) //if moved to a position with a white piece on it take it
            {
              if (!newB.black[j].taken && newB.black[j].posCol == newB.white[n].posCol && newB.black[j].posRow == newB.white[n].posRow)
              {
                newB.black[j].taken = true;
                break;
              }
            }
            newB.white[n].firstTurn = false;
            child = getMaxAB(newB, alpha, beta);
            if (b.score > child) {
              b.score = child;
              newB.chosen = true;
              b.bestPiece = n;
              b.bestCol = newB.white[n].posCol;
              b.bestRow = newB.white[n].posRow;
            }
            if (child <= alpha) {
              return b.score;
            }
            if (child < beta) {
              beta = child;
            }
            //generate the move and return the score of that board or something
          }
        }
        break;

      case "Kn":
        for (int i=-1; i<2; i+=2)
        {
          for (int j = -1; j<2; j+=2)
          {
            if (b.canMove(b.white[n], b.white[n].posCol+(2*i), b.white[n].posRow+(1*j)))
            {
              newB = new Board(b.black, b.white, b.depth +1);
              newB.white[n].posCol += (2*i);
              newB.white[n].posRow += 1*j;
              for (int h =0; h< newB.black.length; h++) //if moved to a position with a white piece on it take it
              {
                if (!newB.black[h].taken && newB.black[h].posCol == newB.white[n].posCol && newB.black[h].posRow == newB.white[n].posRow)
                {
                  newB.black[h].taken = true;
                  break;
                }
              }
              newB.white[n].firstTurn = false;
              child = getMaxAB(newB, alpha, beta);
              if (b.score > child) {
                b.score = child;
                newB.chosen = true;
                b.bestPiece = n;
                b.bestCol = newB.white[n].posCol;
                b.bestRow = newB.white[n].posRow;
              }
              if (child <= alpha) {
                return b.score;
              }
              if (child < beta) {
                beta = child;
              }
              //generate
            }
            if (b.canMove(b.white[n], b.white[n].posCol+(1*i), b.white[n].posRow+(2*j)))
            {
              newB = new Board(b.black, b.white, b.depth +1);
              newB.white[n].posCol += (1*i);
              newB.white[n].posRow += 2*j;
              for (int h =0; h< newB.black.length; h++) //if moved to a position with a white piece on it take it
              {
                if (!newB.black[h].taken && newB.black[h].posCol == newB.white[n].posCol && newB.black[h].posRow == newB.white[n].posRow)
                {
                  newB.black[h].taken = true;
                  break;
                }
              }
              newB.white[n].firstTurn = false;
              child = getMaxAB(newB, alpha, beta);
              if (b.score > child) {
                b.score = child;
                newB.chosen = true;
                b.bestPiece = n;
                b.bestCol = newB.white[n].posCol;
                b.bestRow = newB.white[n].posRow;
              }
              if (child <= alpha) {
                return b.score;
              }
              if (child < beta) {
                beta = child;
                //generate
              }
            }
          }
        }
        break;

      case "B":
        for (int i=1-b.white[n].posCol; i<9-b.white[n].posCol; i+=1)
        {
          for (int j =-1; j<2; j+=2)
          {
            if (i!=0) {
              if (b.canMove(b.white[n], b.white[n].posCol +i, b.white[n].posRow+ j*abs(i)))
              {
                newB = new Board(b.black, b.white, b.depth +1);
                newB.white[n].posCol += i;
                newB.white[n].posRow += j*abs(i);
                for (int h =0; h< newB.black.length; h++) //if moved to a position with a white piece on it take it
                {
                  if (!newB.black[h].taken && newB.black[h].posCol == newB.white[n].posCol && newB.black[h].posRow == newB.white[n].posRow)
                  {
                    newB.black[h].taken = true;
                    break;
                  }
                }
                newB.white[n].firstTurn = false;
                child = getMaxAB(newB, alpha, beta);
                if (b.score > child) {
                  b.score = child;
                  newB.chosen = true;
                  b.bestPiece = n;
                  b.bestCol = newB.white[n].posCol;
                  b.bestRow = newB.white[n].posRow;
                }
                if (child <= alpha) {
                  return b.score;
                }
                if (child < beta) {
                  beta = child;
                  //doshit
                }
              }
            }
          }
        }
        break;

      case "Q":
        for (int i=1-b.white[n].posCol; i<9-b.white[n].posCol; i+=1)
        {
          for (int j =-1; j<2; j+=2)
          {
            if (i!=0) {
              if (b.canMove(b.white[n], b.white[n].posCol +i, b.white[n].posRow+ j*abs(i)))
              {
                newB = new Board(b.black, b.white, b.depth +1);
                newB.white[n].posCol += i;
                newB.white[n].posRow += j*abs(i);
                for (int h =0; h< newB.black.length; h++) //if moved to a position with a white piece on it take it
                {
                  if (!newB.black[h].taken && newB.black[h].posCol == newB.white[n].posCol && newB.black[h].posRow == newB.white[n].posRow)
                  {
                    newB.black[h].taken = true;
                    break;
                  }
                }
                newB.white[n].firstTurn = false;
                child = getMaxAB(newB, alpha, beta);
                if (b.score > child) {
                  b.score = child;
                  newB.chosen = true;
                  b.bestPiece = n;
                  b.bestCol = newB.white[n].posCol;
                  b.bestRow = newB.white[n].posRow;
                }
                if (child <= alpha) {
                  return b.score;
                }
                if (child < beta) {
                  beta = child;
                }
              }
            }
          }
        }
        for (int row = 1; row < 9; row++)
        {
          if (row!=b.white[n].posRow && b.canMove(b.white[n], b.white[n].posCol, row))
          {
            newB = new Board(b.black, b.white, b.depth +1);
            newB.white[n].posRow = row;
            // newB.black[n].posCol +=1;
            for (int j =0; j< newB.black.length; j++) //if moved to a position with a white piece on it take it
            {
              if (!newB.black[j].taken && newB.black[j].posCol == newB.white[n].posCol && newB.black[j].posRow == newB.white[n].posRow)
              {
                newB.black[j].taken = true;
                break;
              }
            }
            newB.white[n].firstTurn = false;
            child = getMaxAB(newB, alpha, beta);
            if (b.score > child) {
              b.score = child;
              newB.chosen = true;
              b.bestPiece = n;
              b.bestCol = b.white[n].posCol;
              b.bestRow = row;
            }
            if (child <= alpha) {
              return b.score;
            }
            if (child < beta) {
              beta = child;
            }
            //generate the move and return the score of that board or something
          }
        }
        for (int col = 1; col < 9; col++)
        {
          if (col!= b.white[n].posCol && b.canMove(b.white[n], col, b.white[n].posRow))
          {
            newB = new Board(b.black, b.white, b.depth +1);
            //newB.black[n].posRow -=1;
            newB.white[n].posCol = col;
            for (int j =0; j< newB.black.length; j++) //if moved to a position with a white piece on it take it
            {
              if (!newB.black[j].taken && newB.black[j].posCol == newB.white[n].posCol && newB.black[j].posRow == newB.white[n].posRow)
              {
                newB.black[j].taken = true;
                break;
              }
            }
            newB.white[n].firstTurn = false;
            child = getMaxAB(newB, alpha, beta);
            if (b.score > child) {
              b.score = child;
              newB.chosen = true;
              b.bestPiece = n;
              b.bestRow = b.white[n].posRow;
              b.bestCol = col;
            }
            if (child <= alpha) {
              return b.score;
            }
            if (child < beta) {
              beta = child;
            }
            //generate the move and return the score of that board or something
          }
        }
        break;

      case "K":
        for (int i =-1; i<2; i++)
        {
          for (int j=-1; j<2; j++)
          {

            if (b.canMove(b.white[n], b.white[n].posCol+i, b.white[n].posRow+j))
            {
              newB = new Board(b.black, b.white, b.depth +1);
              newB.white[n].posCol += i;
              newB.white[n].posRow += j;
              for (int h =0; h< newB.black.length; h++) //if moved to a position with a white piece on it take it
              {
                if (!newB.black[h].taken && newB.black[h].posCol == newB.white[n].posCol && newB.black[h].posRow == newB.white[n].posRow)
                {
                  newB.black[h].taken = true;
                  break;
                }
              }
              newB.white[n].firstTurn = false;
              child = getMaxAB(newB, alpha, beta);
              if (b.score > child) {
                b.score = child;
                newB.chosen = true;
                b.bestPiece = n;
                b.bestCol = newB.white[n].posCol;
                b.bestRow = newB.white[n].posRow;
              }
              if (child <= alpha) {
                return b.score;
              }
              if (child < beta) {
                beta = child;
              }
              //generate
            }
          }
        }
        break;
      }
    }
  }

  return b.score;
}


//int getMinAB(Board b, int alpha, int beta)
//{

//  //int winningPiece = 0;
//  if (b.depth == maxDepth) // if at the max depth get the score of the board and send it back up the recursion
//  {
//    return b.getScore();
//  }
//  //if not set the board value as 1000 ie infinity
//  b.score = 1000;
//  Board newB;
//  for (int i = 0; i < b.white.length; i++) //for each piece generate all moves and call min 
//  {
//    if (!b.white[i].taken)//dont try and move taken pieces
//    {
//      int child;
//      switch(b.white[i].id) {
//      case "p": //if the current piece is a pawn
//        if (b.white[i].canMove(b.white[i].posCol, b.white[i].posRow-1))//if the pawn can move 1 space forward
//        {
//          newB = new Board(b.black, b.white, b.depth +1);//create a new board with the same pieces as the current one
//          newB.white[i].posRow -=1; //move the piece
//          child = getMinAB(newB, alpha, beta); //get the best move for the white player
//          if (b.score > child) { //if this is the best score for black
//            b.score = child;//set the score to be the score of this child
//            newB.chosen = true; // set the best piece and move for this board
//            b.bestPiece = i;
//            b.bestCol = b.white[i].posCol;
//            b.bestRow = b.white[i].posRow-1;
//          }
//          if (child <= alpha) {//if the score is better than the current best move for black then black will never go down this branch therefore return.
//            return b.score;
//          }
//          if (child < beta) {//if the move is the current best move for white
//            beta = child;
//          }
//        }
//        if (b.white[n].hcanhMove(b.black[i].posCol, b.black[i].posRow -2))
//        {
//          newB = new Board(b.black, b.white, b.depth +1);
//          child = getMinAB(newB, alpha, beta);
//          if (b.score > child) {
//            b.score = child;
//            newB.chosen = true;
//            b.bestPiece = i;
//            b.bestCol = b.black[i].posCol;
//            b.bestRow = b.black[i].posRow-2;
//          }
//          if (child >= beta) {
//            return b.score;
//          }
//          if (child < beta) {
//            beta = child;
//          }
//          //generate the move and return the score of that board or something
//        }
//        if (b.black[i].canMove(b.black[i].posCol+1, b.black[i].posRow-1))
//        {
//          newB = new Board(b.black, b.white, b.depth +1);
//          child = getMinAB(newB, alpha, beta);
//          if (b.score < child) {
//            b.score = child;
//            newB.chosen = true;
//            b.bestPiece = i;
//            b.bestCol = b.black[i].posCol+1;
//            b.bestRow =b.black[i].posRow-1;
//          }
//          if (child >= beta) {
//            return b.score;
//          }
//          if (child > alpha) {
//            alpha = child;
//          }
//          //generate the move and return the score of that board or something
//        }
//        if (b.black[i].canMove(b.black[i].posCol-1, b.black[i].posRow+-1))
//        {
//          newB = new Board(b.black, b.white, b.depth +1);
//          child = getMinAB(newB, alpha, beta);
//          if (b.score < child) {
//            b.score = child;
//            newB.chosen = true;
//            b.bestPiece = i;
//            b.bestCol = b.black[i].posCol -1;
//            b.bestRow = b.black[i].posRow-1;
//          }
//          if (child >= beta) {
//            return b.score;
//          }
//          if (child > alpha) {
//            alpha = child;
//          }
//          //generate the move and return the score of that board or something
//        }
//        break;
//      }
//    }
//  }
//}

//================================================================================minimax==========================================================================
