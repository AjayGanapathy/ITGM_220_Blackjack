//===============================================
//
// Learning About Blackjack - Baseline Code
// Professor Marty Altman
// SCAD-Atlanta
// ITGM 220
// 
// This file is an auxiliary written in java, since these things are only
// supported indirectly by processing.  Here are found definitions for 
// useful enumerated types, leveraged elsewhere in the processing code.
//
//===============================================

enum GameState { READY, DEALING, PLAYER_TURN, DEALER_TURN, SHOW_RESULTS };
enum Result    { NONE, PLAYER_WINS, PLAYER_LOSES, PUSH };
enum Suit      { SPADES, HEARTS, DIAMONDS, CLUBS };

enum Rank {
  ACE   (11),     // aces default to a value of 11
  TWO   ( 2), 
  THREE ( 3), 
  FOUR  ( 4), 
  FIVE  ( 5), 
  SIX   ( 6), 
  SEVEN ( 7), 
  EIGHT ( 8), 
  NINE  ( 9), 
  TEN   (10), 
  JACK  (10), 
  QUEEN (10), 
  KING  (10);

  public final int value;
  
  Rank( int v ) { 
    value = v; 
  }
}

