//===============================================
//
// Learning About Blackjack - Baseline Code
// Professor Marty Altman
// SCAD-Atlanta
// ITGM 220
// 
// This file contains the definition for the UI class, which represents
// the user interface.  This class displays relevant data so the user
// can see what's going on in the game.
//
//===============================================

// main color palette
//
final color NORMAL_BG    = color(  50,  70,  35 );      // bg color
final color SEMITRANS_BG = color(  50,  70,  35, 192 ); // semi-transparent bg
final color DROP_SHADOW  = color(  20,  30,  20 );      // drop shadow color
final color SPLASH_TEXT  = color( 252, 212,  15 );      // splash text color
final color MAIN_TEXT    = SPLASH_TEXT;                 // main text color
final color SCORE_TEXT   = color( 204, 204, 204 );      // score text color
final color DEBUG_TEXT   = color( 125, 140, 252 );      // debug text color

// indicators (simple rectangles here)
//
final color POSITION_C  = SCORE_TEXT;  // position indicator color
final float POSITION_SW =   1;         // position indicator stroke weight
final float POSITION_W  = 140;         // position indicator rect width
final float POSITION_H  = 200;         // position incidator rect height
final color ACTIVE_C    = SPLASH_TEXT; // active indicator color
final float ACTIVE_SW   =   2;         // active indicator stroke weight
final float ACTIVE_W    = 300;         // active indicator rect width
final float ACTIVE_H    = 300;         // active indicator rect height

// score and results placement, relative to player's hand
//
final float SCORE_X  =    0; // position of score text, relative to the hand
final float SCORE_Y  = -130;
final float SCORE_Z  =   -3;
final float RESULT_X =    0; // position of result text, relative to the hand
final float RESULT_Y =  158;
final float RESULT_Z =   -3;


class UI {
  PFont    font;
  boolean  debug;

  UI() {
    font = loadFont( "Team401-12.vlw" );
    textFont(font);
    debug = false;
  }
  
  void display() {
    switch ( game.state ) {
      case READY:
        displaySplashText( "Simple Blackjack", "press any key to continue" );
        break;
        
      case DEALING:
        displayMainText( "-- Dealing --", "stand by..." );
        displayDebugText();
        break;
        
      case PLAYER_TURN:
        displayMainText( "-- Player's turn --", "'h' to hit, 's' to stand" );
        displayDebugText();
        break;
        
      case DEALER_TURN:
        displayMainText( "-- Dealer's turn --", "stand by..." );
        displayDebugText();
        break;
        
      case SHOW_RESULTS:
        displayMainText( "press any key", "to continue" );
        displayDebugText();
        break;
    }
  }
  
  void displaySplashText( String s1, String s2 ) {
    drawTextBlock( 0,0, SPLASH_TEXT, s1,s2, 400,70 );
  }

  void displayMainText( String s1, String s2 ) {
    drawTextBlock( -375,280, MAIN_TEXT, s1,s2, 300,70 );
  }

  void displayPositionIndicator() {
    drawIndicator( POSITION_C, POSITION_SW, POSITION_W,POSITION_H );
  }
  
  void displayActiveIndicator() {
    drawIndicator( ACTIVE_C, ACTIVE_SW, ACTIVE_W,ACTIVE_H );
  }
  
  void displayScore( String s ) {
    drawTextDS( true, SCORE_X,SCORE_Y,SCORE_Z, SCORE_TEXT, s );
  }
  
  void displayResult( String s ) {
    drawTextDS( true, RESULT_X,RESULT_Y,RESULT_Z, MAIN_TEXT, s );
  }
  
  void displayDebugText() {
    if ( debug ) {
      pushMatrix();
        translate(-350,200,0);
        drawTextDS( false, 0,  0,0, DEBUG_TEXT, "-- DEBUG --" );
        drawTextDS( false, 0,-25,0, DEBUG_TEXT, "state: "  + game.state.toString()     );
        drawTextDS(false, 0, -50,0, DEBUG_TEXT, str(game.dealer.deck.numCards)+" cards left in deck");
        drawTextDS(false, 0, -75,0, DEBUG_TEXT, "Value of dealer's hand is "+str(game.dealer.hand.value)); 
      popMatrix();
    }
  }

  void drawTextBlock( float x, float y, color c, String s1, String s2, float w, float h ) {
    pushMatrix();
      translate(x,y,0);
      drawTextDS( false, 0, 12,0, c, s1 );
      drawTextDS( false, 0,-12,0, c, s2 );
      noFill();
      rectMode(CENTER);
      strokeWeight(1);
      stroke(DROP_SHADOW);
      rect( 1,-1, w,h );
      stroke(c);
      rect( 0, 0, w,h );
    popMatrix();
  }

  void drawTextDS( boolean drawR, float x, float y, float z, color col, String s ) {
    pushMatrix();
      translate(x,y,z);
      scale(1,-1,1);
      
      if ( drawR ) {
        rectMode(CENTER);
        noStroke();
        fill(SEMITRANS_BG);
        rect( 0,0, 12+textWidth(s),4+textAscent()+textDescent(), 5 );
      }
      
      textAlign(CENTER,CENTER);
      fill(DROP_SHADOW);
      text( s, 1,1 );
      fill(col);
      text( s, 0,0 );
    popMatrix();
  }
  
  void drawIndicator( color sc, float sw, float w, float h ) {
    pushMatrix();
      translate(0,0,3);
      stroke(sc);
      strokeWeight(sw);
      noFill();
      rectMode(CENTER);
      rect(0,0,w,h);
    popMatrix();
  }

  void toggleDebug() {
    debug = !debug;
  }
}

