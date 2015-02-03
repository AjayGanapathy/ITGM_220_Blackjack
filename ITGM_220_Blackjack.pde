//===============================================
//
// Learning About Blackjack - Baseline Code
// Professor Marty Altman
// SCAD-Atlanta
// ITGM 220
// 
// This is one of several working examples designed for use in ITGM programming
// classes and elsewhere to help students learn the fundamentals by means of a
// concrete illustration of the concepts.  The examples also serve a vital role
// as architectural models for students' subsequent development efforts.
//
// This program represents the core elements of a simple game of Blackjack. 
// The Game class utilizes a state machine technique for clarity, and also 
// included are rudimentary abstractions for card, deck, hand, dealer, player
// and a UI class to manage the user interface.
//
// This file is the top-level (or "main") program.  It contains the setup(),
// draw(), and keyPressed() methods that will be called by processing.  It also
// declares the global variable 'game', which is used throughout.
//
//===============================================
//
// Many details and variations are specifically excluded at the outset to stay 
// focused on the bigger or more general concepts, and to help prevent getting 
// lost in the weeds. 
//
// The argument is simple: If we can set the concepts first then meaningful 
// conversations can be had about variations and special cases, but if the 
// concepts never have a chance to sink in then all the variations and special 
// cases are, in effect, just noise.
//
//===============================================
/*
  @pjs  preload="card_ACE_CLUBS.png, card_ACE_DIAMONDS.png, card_ACE_HEARTS.png, card_ACE_SPADES.png, 
        card_back.png, 
        card_TWO_CLUBS.png, card_TWO_DIAMONDS.png, card_TWO_HEARTS.png, card_TWO_SPADES.png, 
        card_THREE_CLUBS.png, card_THREE_DIAMONDS.png, card_THREE_HEARTS.png, card_THREE_SPADES.png,           
        card_FOUR_CLUBS.png, card_FOUR_DIAMONDS.png, card_FOUR_HEARTS.png, card_FOUR_SPADES.png,         
        card_FIVE_CLUBS.png, card_FIVE_DIAMONDS.png, card_FIVE_HEARTS.png, card_FIVE_SPADES.png, 
        card_SIX_CLUBS.png, card_SIX_DIAMONDS.png, card_SIX_HEARTS.png, card_SIX_SPADES.png, 
        card_SEVEN_CLUBS.png, card_SEVEN_DIAMONDS.png, card_SEVEN_HEARTS.png, card_SEVEN_SPADES.png,
        card_EIGHT_CLUBS.png, card_EIGHT_DIAMONDS.png, card_EIGHT_HEARTS.png, card_EIGHT_SPADES.png, 
        card_NINE_CLUBS.png, card_NINE_DIAMONDS.png, card_NINE_HEARTS.png, card_NINE_SPADES.png,
        card_TEN_CLUBS.png, card_TEN_DIAMONDS.png, card_TEN_HEARTS.png, card_TEN_SPADES.png,  
        card_JACK_CLUBS.png, card_JACK_DIAMONDS.png, card_JACK_HEARTS.png, card_JACK_SPADES.png, 
        card_QUEEN_CLUBS.png, card_QUEEN_DIAMONDS.png, card_QUEEN_HEARTS.png, card_QUEEN_SPADES.png,
        card_KING_CLUBS.png, card_KING_DIAMONDS.png, card_KING_HEARTS.png, card_KING_SPADES.png, 
        lose.png, 
        playScreen.jpg, 
        push.png, 
        splashScreen.jpg, 
        win.png";
        font="Team_401.ttf";
*/


final String version = "Ajay Ganapathy";

//--------------------

MA_SimpleOrtho  cam;              // declare the camera
Game            game;             // declare the game

//--------------------
// setup() is called by processing once at the beginning to initialize
//
void setup() {
  size(1280,720,OPENGL);          // open a window
  frameRate(60);
//  size(1280,720);
//  frame.setTitle(version);        // set the frame title
  println(version);               // print out the version info
  
  cam  = new MA_SimpleOrtho();    // instantiate the camera
  game = new Game();              // instantiate the game
}

//--------------------
// draw() is called by processing once each frame so you can decide what to draw
//
void draw() {
  game.playOneFrame();            // play one frame's worth of the game
}

//--------------------
// keyPressed() is called by processing when the user presses a key
//
int specialKey = -1;              // declare a variable that can remember if a special key ws pressed
void keyPressed() {
  if(key == CODED){               // first see if any special keys were pressed
    specialKey = keyCode;         // if a special key was pressed, make note of which key it was
  }
  else{
    if(specialKey != -1){         // if the user previously pressed a special key, then do a special action, determined by what key the user just pressed
      switch(specialKey){
        case SHIFT:
          println("the shift key was pressed");
          break;
        case CONTROL:
          println("the control key was pressed");
          switch(key){
              case 's':
                saveFrame("data/screenshot-###.png");
                println("just saved a screeenshot");
                break;
              case 'd':
                // toggle debug
                game.ui.toggleDebug();
                break;
              case 'g':
                //toggle grid
                cam.toggleGrid();
              default:
                println("ctrl + "+str(key)+" was pressed");
                break;
          }

          break;
        case ALT:
          println("the alt key was pressed");
          break;
        default:
          println("the up, down, left, or right arrows, or the page up, page down, home or end key was pressed.");
          break;
      }
      specialKey = -1;            // clear the value of the special key
    }
    else{  
      game.handleInput(key);      // else, pass the key directly to the game
    }
  }
}

