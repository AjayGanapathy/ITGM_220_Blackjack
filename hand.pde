//===============================================
//
// Learning About Blackjack - Baseline Code
// Professor Marty Altman
// SCAD-Atlanta
// ITGM 220
// 
// This file contains the definition for the Hand class, which represents
// a hand of playing cards.  It holds the cards and calculates the point
// value, as well as providing a string representation of the score for the
// UI.  Hand also holds a base location from which the cards are offset.
//
//===============================================

final int MAX_CARDS_IN_HAND = 12;   // max cards in hand

final float CARD_OFFS_X = 35;       // offsets to space cards relative to each other
final float CARD_OFFS_Y = 25;


class Hand {
  Card    card[];         // cards themselves
  int     numCards;       // number of cards currently in the hand
  int     value;          // current point value of hand
  boolean blackjack;      // true iff this hand is a blackjack, otherwise false
  boolean busted;         // true iff this hand is busted, otherwise false
  float   posX,posY;      // base position of this hand

  Hand( float x, float y ) {
    posX = x;
    posY = y;
    card = new Card[MAX_CARDS_IN_HAND];
    reset();
  }

  void reset() {                     // reset (empty) the hand
    numCards  = 0;
    value     = 0;
    blackjack = false;
    busted    = false;
  }

  void takeCard( Card c ) {          // add a card to the hand
    card[numCards] = c;                // take and store the new card
    card[numCards].pos( (numCards-1)*CARD_OFFS_X, (numCards-1)*CARD_OFFS_Y );
    numCards++;
    calcValue();                       // calculate the new point value
  }

  void calcValue() {
    int numAces = 0;                // assume no aces
    
    // loop over cards in the hand and accumulate points for each
    //   start by assuming aces are eleven, then check afterward
    value = 0;
    for ( int i=0; i<numCards; i++ ) {
      if ( card[i].rank == Rank.ACE ) {
        numAces++;
      }
//      value += card[i].rank.value;
        value += Rank.pointValue(card[i].rank);
    }
    
    // if busted using elevens, then keep trying with aces as one
    while ( (value > 21)  &&  (numAces > 0) ) {
      value -= 10;
      numAces--;
    }
    
    if ( value > 21 ) {
      busted = true;
    } else if ( (value == 21)  &&  (numCards == 2) ) {
      blackjack = true;
    }
  }
  
  void display( boolean showScore ) {
    pushMatrix();
      translate(posX,posY,0);
      for ( int i=0; i<numCards; i++ ) {
        card[i].display();
      }
      if ( showScore ) {
        game.ui.displayScore( score() );
      }
    popMatrix();
  }
  
  void displayResult( int result ) {
    pushMatrix();
      translate(posX,posY,0);
      if ( result != Result.NONE ) {
//        game.ui.displayResult(result);
      }
    popMatrix();
  }
  
  String score() {
    if ( busted ) {
      return( "BUSTED!" );
    } else if ( blackjack ) {
      return( "BLACKJACK!" );
    }
    return( "" + value );
  }
}

