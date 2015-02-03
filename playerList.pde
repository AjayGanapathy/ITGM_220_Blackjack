//===============================================
//
// Learning About Blackjack - Baseline Code
// Professor Marty Altman
// SCAD-Atlanta
// ITGM 220
// 
// This file contains the definition for the PlayerList class, which represents
// the collection of players.  This class contains and manages a list that contains
// all the players, including the dealer.  The dealer is deliberately added last,
// because there are times when the game needs to know when the dealer is done.
//
//===============================================

class PlayerList {
  ArrayList<Player>  players;      // all players, including the dealer
  Dealer             dealer;       // remember the dealer
  int                current;      // the index of the active player

  PlayerList( Dealer d ) {
    players = new ArrayList<Player>();
    nPlayerSetup(5);
    dealer = d;
    players.add(dealer);           // add the dealer last
  }
  
  Player firstPlayer( boolean act ) {
    return( getPlayer( 0, act ) );
  }
  
  Player nextPlayer( boolean act ) {
    return( getPlayer( (current+1) % players.size(), act ) );
  }
  
  Player getPlayer( int index, boolean act ) {
    if ( game.player != null ) {
      game.player.active = false;
    }
    current  = index;
    Player p = players.get(current);
    p.active = act;
    return(p);
  }
  
  boolean everybodyOut() {
    for ( Player p : players ) {
      if ( (p != dealer) && !p.hand.busted ) {  // if any regular player is still in
        return(false);                            // then return false
      }
    }
    return(true);      // only return true if all the players are out
  }
  
  void display() {
    for ( Player p : players ) {
      p.display();
    }
  }
  
  void displayResults() {
    for ( Player p : players ) {
      p.displayResults();
    }
  }
  
  void reset() {
    for ( Player p : players ) {
      p.reset();
    }
  }
  
  void determineResults() {
    for ( Player p : players ) {
      if ( p != dealer ) {
        if ( p.hand.value > 21 ) {
          p.result = Result.PLAYER_LOSES;
        } else if ( dealer.hand.value > 21 ) {
          p.result = Result.PLAYER_WINS;
        } else if ( p.hand.blackjack && !dealer.hand.blackjack ) {
          p.result = Result.PLAYER_WINS;
        } else if ( dealer.hand.blackjack && !p.hand.blackjack ) {
          p.result = Result.PLAYER_LOSES;
        } else if ( p.hand.value > dealer.hand.value ) {
          p.result = Result.PLAYER_WINS;
        } else if ( dealer.hand.value > p.hand.value ) {
          p.result = Result.PLAYER_LOSES;
        } else {
          p.result = Result.PUSH;
        }
      }
    }
  }
  
  void onePlayerSetup() {
    players.add( new Player(0,-185,0) );
  }
  
  void nPlayerSetup(int numberOfPlayers){
    if(numberOfPlayers == 1){
      onePlayerSetup();
    }
    else{
      //layout the table for n players
      float arcAngle = 73; //maybe later add a function that starts arc angle at 0 for a one player setup, and eases up to a clamp for an n player setup?
      float arcYOffset = -100; //offset the arc from the dealer
      float radius = getRadius(numberOfPlayers, arcAngle);
      float arcStart = -1*arcAngle/2;
      float radiusYOffset = getRadiusYOffset(arcStart, radius);
      for(int i=0; i<numberOfPlayers; i++){
        float rotation = getRotation(arcStart, arcAngle, i, numberOfPlayers);
        players.add(new Player(getXPosition(rotation, radius), getYPosition(rotation, radius, radiusYOffset, arcYOffset), radians(rotation)));
      }
    }  
  }
  
  float getRadius(int numberOfPlayers, float arcAngle){
        //get radius, use numberOfPlayers arg bc it's in scope and only needs to be run once
        //measure card dims, and figure out how far apart they need to be spaced 
        float cardWidth = loadImage("card_back.png").width;
        float cardHeight = loadImage("card_back.png").height;
        float arcLength = numberOfPlayers*cardWidth;
        float radius = arcLength/radians(arcAngle);
        radius = radius+cardHeight/2;
        return radius;
  }
  
  float getRotation(float arcStart, float arcAngle, int playerIndex, int numberOfPlayers){
        return arcStart+arcAngle*(numberOfPlayers-playerIndex-1)/(numberOfPlayers-1);
  }
  
  float getRadiusYOffset(float arcStart, float radius){
        return cos(radians(arcStart))*radius;
  }
  
  float getYPosition(float rotation, float radius, float radiusYOffset, float arcYOffset){
        //use yoffset to compensate for radius
        return -1*cos(radians(rotation))*radius+radiusYOffset+arcYOffset;
  }
  
  float getXPosition(float rotation, float radius){
        return sin(radians(rotation))*radius;
  }
}

