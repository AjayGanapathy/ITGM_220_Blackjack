//===============================================
//
// Learning About Blackjack - Baseline Code
// Professor Marty Altman
// SCAD-Atlanta
// ITGM 220
// 
// This file contains the definition for the Deck class, which represents
// the deck of playing cards.  It keeps two arrays of Cards, one in the 
// original configuration (which simplifies shuffling), and another that
// represents the shuffled deck and from which cards are "dealt".  A cursor
// is used in the shuffled deck to keep track of what will be the next card.
//
//===============================================

final int MAX_CARDS = 52;      // max cards in the deck
final float DECK_OFFS_X = -7;  // per card offset for display of deck


class Deck {
  float posX,posY;             // base position for the deck
  Card  orig[];                // "out of the box" configuration
  Card  card[];                // working set
  int   numCards;              // number of cards remaining "in" the deck

  Deck( float x, float y ) {
    posX = x;
    posY = y;
    orig = new Card[MAX_CARDS];         // allocate the arrays
    card = new Card[MAX_CARDS];
    
    numCards = 0;
      for(int s=0; s<4; s++){ 
        for(int r=0; r<13; r++){
        orig[numCards] = new Card(r,s);     // instantiate a new card
        numCards++;                         // increment the count
      }
    }
  }

  void shuffle() {
    boolean used[] = new boolean[MAX_CARDS];
    int     i, r;

    for ( i=0; i<MAX_CARDS; i++ ) {     // initialize the boolean array
      used[i] = false;                    // false means we haven't put
    }                                     //   a card in that slot yet

    for ( i=0; i<MAX_CARDS; i++ ) {    // for each of the cards in the deck
      do {                                // loop...
        r = int(random(0,MAX_CARDS));       // get a random slot
      } while ( used[r] );                // ...until we find an unused slot

      card[r] = orig[i];                  // note the card
      used[r] = true;                     // mark that we've used the slot
    }
    
    for ( i=0; i<MAX_CARDS; i++ ) {    // for each of the cards in the deck
      card[i].pos(i*DECK_OFFS_X,0);      // set staggered placement
      card[i].rot(0);                    // with no rotation
      card[i].down = true;               // and face down
    }
    numCards = MAX_CARDS;                 // update numCards
  }

  Card getTopCard() {
    if ( numCards > 0 ) {               // if there are cards remaining
      numCards--;                         // reduce the count
      card[numCards].down = false;
      return(card[numCards]);             // return that card
    }
    return(null);                       // if no cards return null
  }

  void display() {
    pushMatrix();
      translate(posX,posY,0);                    // establish player position
      for ( int i=0; i<numCards; i++ ) {           // loop over the cards remaining
        card[i].display();
      }
    popMatrix();
  }
}

