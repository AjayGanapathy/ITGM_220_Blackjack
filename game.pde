//===============================================
//
// Learning About Blackjack - Baseline Code
// Professor Marty Altman
// SCAD-Atlanta
// ITGM 220
// 
// This file contains the definition for the Game class, which contains 
// the major component pieces and manages the game logic.  It manages the 
// player, the dealer, and the UI.  In addition the Game class is driven
// by a state machine, wherein the behavior at each point is determined
// by what state the game is in at the time.  This is a significant benefit.
//
//===============================================

class Game {
  Dealer           dealer;           // the dealer
  PlayerList       list;             // the list of players (including the dealer)
  Player           player;           // the current player
  UI               ui;               // the user interface
//  GameState        state;            // internal game state
//  String           state;
  int              state;

//all possible game states
//  final static int READY = 0;
//  final static int DEALING = 1;
//  final static int PLAYER_TURN = 2;
//  final static int DEALER_TURN = 3;
//  final static int SHOW_RESULTS = 4;
  
  Game() {
    dealer = new Dealer(0,175,0);
    list   = new PlayerList(dealer);
    ui     = new UI();
    state  = GameState.READY;
//    state = "READY";
  }
  
  void playOneFrame() {
    cam.beginFrame();                // begin the frame (bookends)
    cam.evaluate();                  // evaluate the camera
    
    switch ( state ) {
//      case READY:
//      case "READY":
      case GameState.READY:
        ui.display();                // ui only in READY state
        break;
        
//      case DEALING:
//      case "DEALING":
      case GameState.DEALING:
        if ( dealer.dealCardTo(player) ) {
          nextPlayer(false);
        }
        if ( dealer.hand.numCards == 2 ) {
          beginPlayerTurn();
        }
        display();
        break;
        
//      case PLAYER_TURN:
//      case "PLAYER_TURN":
      case GameState.PLAYER_TURN:
        if ( player.hand.busted ) {
          nextPlayer(true);
        }
        display();
        break;
        
//      case DEALER_TURN:
//      case "DEALER_TURN":
      case GameState.DEALER_TURN:
        if ( allDone() ) {
          determineResults();
        } else {
          dealer.update();
        }
        display();
        break;
        
//      case SHOW_RESULTS:
//      case "SHOW_RESULTS":
      case GameState.SHOW_RESULTS:
        display();
        list.displayResults();
        break;
    }
    
    cam.endFrame();                 // end the frame (bookends)
  }
  
  void display() {
    background(loadImage("playScreen.jpg"));
    list.display();
    ui.display();
  }
  
  void nextPlayer( boolean active ) {
    player = list.nextPlayer(active);
    if ( active  &&  (player == dealer) ) {
      dealer.flipCard();
      state = GameState.DEALER_TURN;
//      state = "DEALER_TURN";
//      state = DEALER_TURN;
    }
  }
  
  boolean allDone() {
    return( dealer.show  &&  (list.everybodyOut() || (dealer.hand.value > 16)) );
  }
  
  void determineResults() {
    dealer.active = false;
    list.determineResults();
    state = GameState.SHOW_RESULTS;
//    state = "SHOW_RESULTS";
//    state = SHOW_RESULTS;
  }
  
  void beginPlayerTurn() {
    player = list.firstPlayer(true);
    state  = GameState.PLAYER_TURN;
//    state = "PLAYER_TURN";
//    state = PLAYER_TURN;
  }
  
  void beginDealing() {
    list.reset();
    player = list.firstPlayer(false);
    state  = GameState.DEALING;
//    state = "DEALING";
//    state = DEALING;
  }
  
  void handleInput( char input ) {
    switch ( state ) {
//      case READY:                      // which key doesn't matter
//      case "READY":
      case GameState.READY:
        beginDealing();
        break;
        
//      case PLAYER_TURN:                // here which key does matter
//      case "PLAYER_TURN":
      case GameState.PLAYER_TURN:
        switch ( input ) {
          case 'h':                      // player wants a "hit"
            dealer.dealCardTo(player);
            break;
          case 's':                      // player "stands"
            nextPlayer(true);
            break;
        }
        break;
        
//      case SHOW_RESULTS:               // which key doesn't matter
//      case "SHOW_RESULTS":
      case GameState.SHOW_RESULTS:
        beginDealing();                // skip READY and straight to DEALING
        break;
    }
  }
}

