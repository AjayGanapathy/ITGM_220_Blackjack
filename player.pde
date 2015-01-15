//===============================================
//
// Learning About Blackjack - Baseline Code
// Professor Marty Altman
// SCAD-Atlanta
// ITGM 220
// 
// This file contains the definition for the Player class, which represents
// the player.  This class is minimal, since the user embodies the "intelligence"
// here.  Basically this class contains a hand.
//
//===============================================

class Player {
  Hand      hand;           // this player's hand of cards
  float     posX,posY;      // base position of this player
  float     rotZ;           // base rotation of this player
  boolean   active;         // true iff this player is active, false otherwise
  boolean   show;           // true shows score, false doesn't
  Result    result;         // result of this player's hand (who won?)

  Player( float x, float y, float r ) {
    hand   = new Hand(0,0);
    posX   = x;
    posY   = y;
    rotZ   = r;
    active = false;
    show   = true;
    result = Result.NONE;
  }

  void reset() {
    hand.reset();
    active = false;
    show   = true;
    result = Result.NONE;
  }

  void takeCard( Card card ) {
    hand.takeCard(card);
  }
  
  void display() {
    pushMatrix();
      translate(posX,posY,0);                    // establish player position
      rotateZ(rotZ);                             //   and rotation
      game.ui.displayPositionIndicator();        // draw position indicator
      if ( active ) {                            // if active
        game.ui.displayActiveIndicator();          // draw active indicator
      }
      hand.display(show);                        // now display the hand
    popMatrix();
  }
  
  void displayResults() {
    pushMatrix();
      translate(posX,posY,0);                    // establish player position
      rotateZ(rotZ);                             //   and rotation
      hand.displayResult(result);                // now display the results
    popMatrix();
  }
}

