import de.bezier.guido.*;
public static int NUM_ROWS = 20;
public static int NUM_COLS = 20;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> mines; //ArrayList of just the minesweeper buttons that are mined

void setup ()
{
    size(400, 400);
    textAlign(CENTER,CENTER);
    
    // make the manager
    Interactive.make( this );
    
    //your code to initialize buttons goes here
    
   buttons = new MSButton[NUM_ROWS][NUM_COLS]; 
   for(int r = 0; r < NUM_ROWS; r++){
     for(int c = 0; c < NUM_COLS; c++){
       buttons[r][c] = new MSButton(r,c);
     }
   }
   mines = new ArrayList <MSButton>();
   setMines();
}
public void setMines()
{
  for(int i = 0; i < 30; i++){
   int row = (int)(Math.random()*20);
   int col = (int)(Math.random()*20);
   if(mines.contains(buttons[row][col]) == false){
     mines.add(buttons[row][col]);
   }
  }
   
}

public void draw ()
{
    background( 0 );
    if(isWon() == true)
        displayWinningMessage();
}
public boolean isWon()
{
    int markMines= 0;
    for(int i = 0; i < mines.size(); i++)
    {
        if(mines.get(i).isFlagged() == true)
        {
            markMines++;
        }
    }
    if(markMines == mines.size())
    {
        return true;
    }
    return false;
}
public void displayLosingMessage()
{
    for(int i = 0; i < mines.size(); i++){
      mines.get(i).clicked = true;
    }
    buttons[9][8].setLabel("Y");
    buttons[9][9].setLabel("O");
    buttons[9][10].setLabel("U");
    buttons[10][8].setLabel("L");
    buttons[10][9].setLabel("O");
    buttons[10][10].setLabel("S");
    buttons[10][11].setLabel("E");
}
public void displayWinningMessage()
{
    buttons[9][8].setLabel("Y");
    buttons[9][9].setLabel("O");
    buttons[9][10].setLabel("U");
    buttons[10][8].setLabel("W");
    buttons[10][9].setLabel("I");
    buttons[10][10].setLabel("N");
    buttons[10][11].setLabel("!");
}
public boolean isValid(int r, int c)
{
    if(r>=0 && r<NUM_ROWS && c>=0 && c<NUM_COLS){
      return true;
    }
    return false;
}
public int countMines(int row, int col)
{
    int numMines = 0;
    for(int i = row-1; i <= row+1; i++){
      for(int j = col-1; j <= col+1; j++){
        if(isValid(i,j) && mines.contains(buttons[i][j])){
          numMines++;
        }
      }
    }
    return numMines;
}
public class MSButton
{
    private int myRow, myCol;
    private float x,y, width, height;
    private boolean clicked, flagged;
    private String myLabel;
    
    public MSButton ( int row, int col )
    {
        width = 400/NUM_COLS;
        height = 400/NUM_ROWS;
        myRow = row;
        myCol = col; 
        x = myCol*width;
        y = myRow*height;
        myLabel = "";
        flagged = clicked = false;
        Interactive.add( this ); // register it with the manager
    }

    // called by manager
    public void mousePressed () 
    {
        clicked = true;
        if(mouseButton == RIGHT && flagged == false){
          flagged = true;
        }
        else if(mouseButton == RIGHT){
          flagged = false;
          clicked = false;
        }
        else if(mines.contains(this)){
          displayLosingMessage();
        }
        else if(countMines(myRow,myCol) > 0){
          myLabel = "" + countMines(myRow,myCol);
        }
        else{
          for(int i = myRow-1; i <= myRow+1; i++){
            for(int j = myCol-1; j <= myCol+1; j++){
               if(isValid(i,j) == true && buttons[i][j].clicked == false){
                  buttons[i][j].mousePressed();
               }  
            } 
          }
        }
    }
    public void draw () 
    {    
        if (flagged)
            fill(0);
        else if( clicked && mines.contains(this) ) 
            fill(255,0,0);
        else if(clicked)
            fill( 200 );
        else 
            fill( 100 );

        rect(x, y, width, height);
        fill(0);
        text(myLabel,x+width/2,y+height/2);
    }
    public void setLabel(String newLabel)
    {
        myLabel = newLabel;
    }
    public void setLabel(int newLabel)
    {
        myLabel = ""+ newLabel;
    }
    public boolean isFlagged()
    {
        return flagged;
    }
}
