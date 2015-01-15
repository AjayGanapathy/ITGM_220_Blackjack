//===============================================
//
// Learning About Blackjack - Baseline Code
// Professor Marty Altman
// SCAD-Atlanta
// ITGM 220
// 
// This file contains the definition for the Dealer class, which represents
// the dealer.  It makes use of the Deck, and also contains a Hand to hold
// the dealer's cards.  In addition it has a flag used to toggle the initial
// deal between the player and the dealer, and a timer to throttle the pace
// of the dealer's actions.
//
//===============================================

final int DEAL_PACE =  30;    // milliseconds between dealer actions when dealing
//final int DEAL_PACE =  300;    // milliseconds between dealer actions when dealing
final int DRAW_PACE = 1000;    // milliseconds between when drawing for himself


class Dealer extends Player {
  Deck     deck;               // the deck of cards
  int      tDP;                // used with timer to throttle dealer's pace
  boolean  flip;               // true signals need to flip the hole card

  Dealer( float x, float y, float r ) {
    super(x,y,r);
    hand = new Hand(0,0);
    deck = new Deck(550,250);         // instantiate the deck
    reset();
  }
  
  void reset() {
    super.reset();
    show = false;
    flip = false;
    deck.shuffle();
    tDP = millis();
  }
  
  // deals a card to the specified player
  //   returns false if still waiting on the pace timer,
  //   returns true when the card is actually dealt
  boolean dealCardTo( Player player ) {
    int elapsed = millis() - tDP;       // elapsed milliseconds
    if ( elapsed > DEAL_PACE ) {
      player.takeCard( deck.getTopCard() );
      tDP = millis();
      return(true);
    }
    return(false);
  }
  
  void flipCard() {
    active = true;
    flip   = true;
    tDP    = millis();                  // start the timer
  }
  
  void update() {
    int elapsed = millis() - tDP;       // elapsed milliseconds
    if ( elapsed > DRAW_PACE ) {
      if ( flip ) {
        hand.card[0].down = false;
        show = true;
        flip = false;
      } else if ( hand.value < 17 ) {
        hand.takeCard( deck.getTopCard() );
      }
      tDP = millis();
    }
  }

  void display() {
    super.display();
    deck.display();
  }
}

