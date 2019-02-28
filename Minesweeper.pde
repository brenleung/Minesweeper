import de.bezier.guido.*;
public final static int NUM_ROWS = 20;
public final static int NUM_COLS = 20;
public int NUM_BOMBS = 20;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> bombs = new ArrayList<MSButton>(); //ArrayList of just the minesweeper buttons that are mined

void setup ()
{
    size(500, 500);
    textAlign(CENTER,CENTER);
    
    // make the manager
    Interactive.make( this );
    
    //your code to initialize buttons goes here
    buttons = new MSButton[20][20];
    for (int r = 0; r < NUM_ROWS; r++) {
        for (int c = 0; c < NUM_COLS; c++) {
            buttons[r][c] = new MSButton(r,c);
        }
    }
    
    
    
    setBombs();
}
public void setBombs()
{
    while (bombs.size() < NUM_BOMBS) {
        int r = (int)(Math.random() * 20);
        int c = (int)(Math.random() * 20);
        if (bombs.contains(buttons[r][c])) {
            r = (int)(Math.random()*20);
            c = (int)(Math.random()*20);
        }
        else {
            bombs.add(buttons[r][c]);
            //System.out.println(r + ", " + c);
        }
    }
}

public void draw ()
{
    background( 0 );
    if(isWon())
        displayWinningMessage();
}
public boolean isWon()
{
    for (int r = 0; r < NUM_ROWS; r++) {
        for (int c = 0; c < NUM_COLS; c++) {
            if (buttons[r][c].isClicked() == false && buttons[r][c].isMarked() == false) {
                return false;
            }
        }
    }
    return true;
}
public void displayLosingMessage()
{
    //your code here
}
public void displayWinningMessage()
{
    buttons[0][0].setLabel("Y");
}

public class MSButton
{
    private int r, c;
    private float x,y, width, height;
    private boolean clicked, marked;
    private String label;
    
    public MSButton ( int rr, int cc )
    {
        width = 500/NUM_COLS;
        height = 500/NUM_ROWS;
        r = rr;
        c = cc; 
        x = c*width;
        y = r*height;
        label = "";
        marked = clicked = false;
        Interactive.add( this ); // register it with the manager
    }
    public boolean isMarked()
    {
        return marked;
    }
    public boolean isClicked()
    {
        return clicked;
    }
    public void mousePressed () 
    {
        clicked = true;
        if (mouseButton == RIGHT) {
            marked = !marked;
            if (marked == false) {
                clicked = false;
            }
        }
        else if (bombs.contains( this )) { 
            displayLosingMessage();
        }
        else if (countBombs(r, c) > 0) {
            label = ""+countBombs(r,c);
        }
        else {
            for (int row = r-1; row < r+2; row++) {
                for (int col = c-1; col < c+2; col++) {
                    if (isValid(row, col) == true && buttons[row][col].isClicked() == false) {
                        buttons[row][col].mousePressed();
                    }
                }
            }
        }
    }

    public void draw () 
    {    
        if (marked)
            fill(0);
        else if( clicked && bombs.contains(this) ) 
            fill(255,0,0);
        else if(clicked)
            fill( 200 );
        else 
            fill( 100 );

        rect(x, y, width, height);
        fill(0);
        textSize(12);
        text(label,x+width/2,y+height/2);
    }
    public void setLabel(String newLabel)
    {
        label = newLabel;
    }
    public boolean isValid(int r, int c)
    {
        if (r < NUM_ROWS && r >= 0 && c < NUM_COLS && c >= 0) {
            return true;
        }
        return false;
    }
    public int countBombs(int row, int col)
    {
        int numBombs = 0;
        for (int r = row-1; r < row+2; r++) {
            for (int c = col-1; c < col+2; c++) {
                if (isValid(r, c) == true && bombs.contains(buttons[r][c]) == true) {
                    numBombs++;
                }
            }
        }
        return numBombs;
    }
}