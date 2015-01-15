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
    onePlayerSetup();
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
}

