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
  GameState        state;            // internal game state
  
  Game() {
    dealer = new Dealer(0,175,0);
    list   = new PlayerList(dealer);
    ui     = new UI();
    state  = GameState.READY;
  }
  
  void playOneFrame() {
    cam.beginFrame();                // begin the frame (bookends)
    cam.evaluate();                  // evaluate the camera
    
    switch ( state ) {
      case READY:
        ui.display();                // ui only in READY state
        break;
        
      case DEALING:
        if ( dealer.dealCardTo(player) ) {
          nextPlayer(false);
        }
        if ( dealer.hand.numCards == 2 ) {
          beginPlayerTurn();
        }
        display();
        break;
        
      case PLAYER_TURN:
        if ( player.hand.busted ) {
          nextPlayer(true);
        }
        display();
        break;
        
      case DEALER_TURN:
        if ( allDone() ) {
          determineResults();
        } else {
          dealer.update();
        }
        display();
        break;
        
      case SHOW_RESULTS:
        display();
        list.displayResults();
        break;
    }
    
    cam.endFrame();                 // end the frame (bookends)
  }
  
  void display() {
    list.display();
    ui.display();
  }
  
  void nextPlayer( boolean active ) {
    player = list.nextPlayer(active);
    if ( active  &&  (player == dealer) ) {
      dealer.flipCard();
      state = GameState.DEALER_TURN;
    }
  }
  
  boolean allDone() {
    return( dealer.show  &&  (list.everybodyOut() || (dealer.hand.value > 16)) );
  }
  
  void determineResults() {
    dealer.active = false;
    list.determineResults();
    state = GameState.SHOW_RESULTS;
  }
  
  void beginPlayerTurn() {
    player = list.firstPlayer(true);
    state  = GameState.PLAYER_TURN;
  }
  
  void beginDealing() {
    list.reset();
    player = list.firstPlayer(false);
    state  = GameState.DEALING;
  }
  
  void handleInput( char input ) {
    switch ( state ) {
      case READY:                      // which key doesn't matter
        beginDealing();
        break;
        
      case PLAYER_TURN:                // here which key does matter
        switch ( input ) {
          case 'h':                      // player wants a "hit"
            dealer.dealCardTo(player);
            break;
          case 's':                      // player "stands"
            nextPlayer(true);
            break;
        }
        break;
        
      case SHOW_RESULTS:               // which key doesn't matter
        beginDealing();                // skip READY and straight to DEALING
        break;
    }
  }
}

