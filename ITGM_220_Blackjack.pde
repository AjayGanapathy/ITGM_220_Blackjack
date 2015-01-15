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

final String version = "Ajay Ganapathy";

//--------------------

MA_SimpleOrtho  cam;              // declare the camera
Game            game;             // declare the game

//--------------------
// setup() is called by processing once at the beginning to initialize
//
void setup() {
  size(1280,720,OPENGL);          // open a window
  frame.setTitle(version);        // set the frame title
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
void keyPressed() {
  game.handleInput(key);          // pass the key directly to the game 
}

