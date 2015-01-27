class DealerHand extends Hand{
  boolean isFirstCard = true;
  DealerHand(float x, float y){
    super(x,y);
  }
  void takeCard ( Card c ) {          // add a card to the hand
    if(isFirstCard){
    c.down = true;
    isFirstCard = false;
    }
    card[numCards] = c;                // take and store the new card
    card[numCards].pos( (numCards-1)*CARD_OFFS_X, (numCards-1)*-1*CARD_OFFS_Y );
    numCards++;
    calcValue();                       // calculate the new point value
  }
}
