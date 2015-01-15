//===============================================
//
// Learning About Blackjack - Baseline Code
// Professor Marty Altman
// SCAD-Atlanta
// ITGM 220
// 
// This file contains the definition for the Card class, which represents
// a single playing card.  It makes use of the enum's Rank and Suit, holds
// images for both the front and back of the card, the card's position on
// the playing surface, and a flag to denote whether it is face up or down.
//
//===============================================

class Card {    
  Rank     rank;            // rank of this particular card
  Suit     suit;            // suit of this particular card
  PImage   frnt,back;       // images for front/back side of this card
  float    posX,posY;       // position of this particular card
  float    rotZ;            // rotation of this particular card
  boolean  down;            // true iff card facing down, false otherwise
  float    dsW,dsH;         // width and height of drop shadow rectangle

  Card( Rank r, Suit s ) {    
    rank = r;
    suit = s;
    frnt = loadImage( "card_" + rank + "_" + suit + ".png" );
    back = loadImage( "card_back.png"                      );
    down = true;            // default to face down
    pos(0,0);               // default to origin, this is set later by Hand
    rot(0);                 // default to zero, this is set later by Hand
    dsW  = frnt.width  + 2;
    dsH  = frnt.height + 2;
  }
  
  void pos( float x, float y ) {
    posX = x;
    posY = y;
  }
  void rot( float r ) {
    rotZ = r;
  }
  
  void display() {
    pushMatrix();
      translate(posX,posY,  (down ? 1 : 0));
      rotateZ(rotZ);
      scale(1,-1,1);
      
      fill(128,128);          // display a drop shadow first
      noStroke();
      rectMode(CENTER);
      rect( 0,0, dsW,dsH, 5 );
      
      imageMode(CENTER);      // then display the card
      if ( down ) {
        image( back, 0,0 );
      } else {
        image( frnt, 0,0 );
      }
    popMatrix();
  }
}

