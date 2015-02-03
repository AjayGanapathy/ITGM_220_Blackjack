//===============================================
//
// Learning About Blackjack - Baseline Code
// Professor Marty Altman
// SCAD-Atlanta
// ITGM 220
// 
// This is one of several working examples designed for use in ITGM programming
// classes and elsewhere to help students learn the fundamentals by means of a
// concrete illustration of the concepts.  The examples also serve a vital role
// as architectural models for students' subsequent development efforts.
//
// This program represents the core elements of a simple game of Blackjack. 
// The Game class utilizes a state machine technique for clarity, and also 
// included are rudimentary abstractions for card, deck, hand, dealer, player
// and a UI class to manage the user interface.
//
// This file is the top-level (or "main") program.  It contains the setup(),
// draw(), and keyPressed() methods that will be called by processing.  It also
// declares the global variable 'game', which is used throughout.
//
//===============================================
//
// Many details and variations are specifically excluded at the outset to stay 
// focused on the bigger or more general concepts, and to help prevent getting 
// lost in the weeds. 
//
// The argument is simple: If we can set the concepts first then meaningful 
// conversations can be had about variations and special cases, but if the 
// concepts never have a chance to sink in then all the variations and special 
// cases are, in effect, just noise.
//
//===============================================
/*
  @pjs  preload="card_ACE_CLUBS.png, card_ACE_DIAMONDS.png, card_ACE_HEARTS.png, card_ACE_SPADES.png, 
        card_back.png, 
        card_TWO_CLUBS.png, card_TWO_DIAMONDS.png, card_TWO_HEARTS.png, card_TWO_SPADES.png, 
        card_THREE_CLUBS.png, card_THREE_DIAMONDS.png, card_THREE_HEARTS.png, card_THREE_SPADES.png,           
        card_FOUR_CLUBS.png, card_FOUR_DIAMONDS.png, card_FOUR_HEARTS.png, card_FOUR_SPADES.png,         
        card_FIVE_CLUBS.png, card_FIVE_DIAMONDS.png, card_FIVE_HEARTS.png, card_FIVE_SPADES.png, 
        card_SIX_CLUBS.png, card_SIX_DIAMONDS.png, card_SIX_HEARTS.png, card_SIX_SPADES.png, 
        card_SEVEN_CLUBS.png, card_SEVEN_DIAMONDS.png, card_SEVEN_HEARTS.png, card_SEVEN_SPADES.png,
        card_EIGHT_CLUBS.png, card_EIGHT_DIAMONDS.png, card_EIGHT_HEARTS.png, card_EIGHT_SPADES.png, 
        card_NINE_CLUBS.png, card_NINE_DIAMONDS.png, card_NINE_HEARTS.png, card_NINE_SPADES.png,
        card_TEN_CLUBS.png, card_TEN_DIAMONDS.png, card_TEN_HEARTS.png, card_TEN_SPADES.png,  
        card_JACK_CLUBS.png, card_JACK_DIAMONDS.png, card_JACK_HEARTS.png, card_JACK_SPADES.png, 
        card_QUEEN_CLUBS.png, card_QUEEN_DIAMONDS.png, card_QUEEN_HEARTS.png, card_QUEEN_SPADES.png,
        card_KING_CLUBS.png, card_KING_DIAMONDS.png, card_KING_HEARTS.png, card_KING_SPADES.png, 
        lose.png, 
        playScreen.jpg, 
        push.png, 
        splashScreen.jpg, 
        win.png";
        font="Team_401.ttf";
*/


final String version = "Ajay Ganapathy";

//--------------------

MA_SimpleOrtho  cam;              // declare the camera
Game            game;             // declare the game

//--------------------
// setup() is called by processing once at the beginning to initialize
//
void setup() {
  size(1280,720,OPENGL);          // open a window
  frameRate(60);
//  size(1280,720);
//  frame.setTitle(version);        // set the frame title
  println(version);               // print out the version info
  
  cam  = new MA_SimpleOrtho();    // instantiate the camera
  game = new Game();              // instantiate the game
}

//--------------------
// draw() is called by processing once each frame so you can decide what to draw
//
void draw() {
  game.playOneFrame();            // play one frame's worth of the game
}

//--------------------
// keyPressed() is called by processing when the user presses a key
//
int specialKey = -1;              // declare a variable that can remember if a special key ws pressed
void keyPressed() {
  if(key == CODED){               // first see if any special keys were pressed
    specialKey = keyCode;         // if a special key was pressed, make note of which key it was
  }
  else{
    if(specialKey != -1){         // if the user previously pressed a special key, then do a special action, determined by what key the user just pressed
      switch(specialKey){
        case SHIFT:
          println("the shift key was pressed");
          break;
        case CONTROL:
          println("the control key was pressed");
          switch(key){
              case 's':
                saveFrame("data/screenshot-###.png");
                println("just saved a screeenshot");
                break;
              case 'd':
                // toggle debug
                game.ui.toggleDebug();
                break;
              case 'g':
                //toggle grid
                cam.toggleGrid();
              default:
                println("ctrl + "+str(key)+" was pressed");
                break;
          }

          break;
        case ALT:
          println("the alt key was pressed");
          break;
        default:
          println("the up, down, left, or right arrows, or the page up, page down, home or end key was pressed.");
          break;
      }
      specialKey = -1;            // clear the value of the special key
    }
    else{  
      game.handleInput(key);      // else, pass the key directly to the game
    }
  }
}

abstract static class GameState{
  final static int READY = 0;
  final static int DEALING = 1;
  final static int PLAYER_TURN = 2;
  final static int DEALER_TURN = 3;
  final static int SHOW_RESULTS = 4;
  
  static String toString(int state){
    switch(state){
      case 0:
        return "READY";
      case 1:
        return "DEALING";
      case 2:
        return "PLAYER_TURN";
      case 3:
        return "DEALER_TURN";
      case 4:
        return "SHOW_RESULTS";
      default:
        return "unknown state";
    }
  }
}
abstract static class Rank{
  final static int ACE = 0;
  final static int TWO = 1;
  final static int THREE = 2;
  final static int FOUR = 3;
  final static int FIVE = 4;
  final static int SIX = 5;
  final static int SEVEN = 6;
  final static int EIGHT = 7;
  final static int NINE = 8;
  final static int TEN = 9;
  final static int JACK = 10;
  final static int QUEEN = 11;
  final static int KING = 12;
  
  static int pointValue(int rank){
    switch(rank){  
      case 0:
          return 1;
      case 1:
          return 2;          
      case 2:
          return 3;
      case 3:
          return 4;
      case 4:
          return 5;
      case 5:
          return 6;
      case 6:
          return 7;
      case 7:
          return 8;
      case 8:
          return 9;
      case 9:
      case 10:
      case 11:
      case 12:
          return 10;
      default:
          return 0;
    }
  }
  
  static String toString(int rank){
//    String returnString = "";
    switch(rank){
      case 0:
          return "ACE";
      case 1:
          return "TWO";          
      case 2:
          return "THREE";
      case 3:
          return "FOUR";
      case 4:
          return "FIVE";
      case 5:
          return "SIX";
      case 6:
          return "SEVEN";
      case 7:
          return "EIGHT";
      case 8:
          return "NINE";
      case 9:
          return "TEN";
      case 10:
          return "JACK";
      case 11:
          return "QUEEN";
      case 12:
          return "KING";
      default:
          return "UNKNOWN_RANK";
    }
  } 
}
abstract class Result{
  final static int NONE = 0;
  final static int PLAYER_WINS = 1;
  final static int PLAYER_LOSES = 2;
  final static int PUSH = 3;
}

abstract static class Suit{
  final static int SPADES = 0;
  final static int HEARTS = 1;
  final static int DIAMONDS = 2;
  final static int CLUBS = 3;
  
  static String toString(int suit){
    switch(suit){
      case 0:
        return "SPADES";
      case 1:
        return "HEARTS";
      case 2:
        return "DIAMONDS";
      case 3:
        return "CLUBS";
      default:
        return "unknown suit";
    }
  }
}

//===============================================
//
// Learning About Blackjack - Baseline Code
// Professor Marty Altman
// SCAD-Atlanta
// ITGM 220
// 
// This file contains the definition for the Card class, which represents
// a single playing card.  It makes use of the enum's Rank and Suit, holds
// images for both the front and back of the card, the card's position on
// the playing surface, and a flag to denote whether it is face up or down.
//
//===============================================

class Card {    
  int     rank;            // rank of this particular card
  int     suit;            // suit of this particular card
  PImage   frnt,back;       // images for front/back side of this card
  float    posX,posY;       // position of this particular card
  float    rotZ;            // rotation of this particular card
  boolean  down;            // true iff card facing down, false otherwise
  float    dsW,dsH;         // width and height of drop shadow rectangle

  Card( int r, int s ) {    
    rank = r;
    suit = s;
    frnt = loadImage( "card_" + Rank.toString(r) + "_" + Suit.toString(s) + ".png" );
    back = loadImage( "card_back.png"                      );
    down = true;            // default to face down
    pos(0,0);               // default to origin, this is set later by Hand
    rot(0);                 // default to zero, this is set later by Hand
    dsW  = frnt.width  + 2;
    dsH  = frnt.height + 2;
  }
  
  void pos( float x, float y ) {
    posX = x;
    posY = y;
  }
  void rot( float r ) {
    rotZ = r;
  }
  
  void display() {
    pushMatrix();
      translate(posX,posY,  (down ? 1 : 0));
      rotateZ(rotZ);
      scale(1,-1,1);
      
      fill(128,128);          // display a drop shadow first
      noStroke();
      rectMode(CENTER);
//      rect( 0,0, dsW,dsH, 5 );
      rect(0,0, dsW, dsH);
      
      imageMode(CENTER);      // then display the card
      if ( down ) {
        image( back, 0,0 );
      } else {
        image( frnt, 0,0 );
      }
    popMatrix();
  }
}

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
    hand = new DealerHand(0,0);
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
//    for ( Suit s : Suit.values() ) {    // loop over suits
      for(int s=0; s<4; s++){ 
//      for ( Rank r : Rank.values() ) {    // loop over ranks
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
  int              state;            // internal game state

  
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
      case GameState.READY:
        println("READY");
        ui.display();                // ui only in READY state
        break;
      case GameState.DEALING:
        println("DEALING");
        if ( dealer.dealCardTo(player) ) {
          nextPlayer(false);
        }
        if ( dealer.hand.numCards == 2 ) {
          beginPlayerTurn();
        }
        display();
        break;
      case GameState.PLAYER_TURN:
        println("PLAYER TURN");
        if ( player.hand.busted ) {
          nextPlayer(true);
        }
        display();
        break;
      case GameState.DEALER_TURN:
        println("DEALER TURN");
        if ( allDone() ) {
          determineResults();
        } else {
          dealer.update();
        }
        display();
        break;
      case GameState.SHOW_RESULTS:
        println("SHOW RESULTS");
        display();
        list.displayResults();
        break;
    }
    
    cam.endFrame();                 // end the frame (bookends)
  }
  
  void display() {
//    background(loadImage("playScreen.jpg"));
//    pushMatrix();
//    scale(1,-1);
//    image(loadImage("playScreen.jpg"),-width/2,-height/2);
//    popMatrix();
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
      case GameState.READY:
        beginDealing();
        break;
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
      case GameState.SHOW_RESULTS:
        beginDealing();                // skip READY and straight to DEALING
        break;
    }
  }
}

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
        value += Rank.pointValue(card[i].rank); ////PROBLEM - SLIPPING ACES!  the modified ace value isn't sticking!
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
        game.ui.displayResult(result);
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
  int       result;         // result of this player's hand (who won?)

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

//===============================================
//
// Learning About Blackjack - Baseline Code
// Professor Marty Altman
// SCAD-Atlanta
// ITGM 220
// 
// This file contains the definition for the UI class, which represents
// the user interface.  This class displays relevant data so the user
// can see what's going on in the game.
//
//===============================================

// main color palette
//
final color NORMAL_BG    = color(  50,  70,  35 );      // bg color
final color SEMITRANS_BG = color(  50,  70,  35, 192 ); // semi-transparent bg
final color DROP_SHADOW  = color(  20,  30,  20 );      // drop shadow color
final color SPLASH_TEXT  = color( 252, 212,  15 );      // splash text color
final color MAIN_TEXT    = SPLASH_TEXT;                 // main text color
final color SCORE_TEXT   = color( 204, 204, 204 );      // score text color
final color DEBUG_TEXT   = color( 125, 140, 252 );      // debug text color

// indicators (simple rectangles here)
//
final color POSITION_C  = SCORE_TEXT;  // position indicator color
final float POSITION_SW =   1;         // position indicator stroke weight
final float POSITION_W  = 140;         // position indicator rect width
final float POSITION_H  = 200;         // position incidator rect height
final color ACTIVE_C    = SPLASH_TEXT; // active indicator color
final float ACTIVE_SW   =   2;         // active indicator stroke weight
final float ACTIVE_W    = 300;         // active indicator rect width
final float ACTIVE_H    = 300;         // active indicator rect height

// score and results placement, relative to player's hand
//
final float SCORE_X  =    0; // position of score text, relative to the hand
final float SCORE_Y  = -130;
final float SCORE_Z  =   -3;
final float RESULT_X =    0; // position of result text, relative to the hand
final float RESULT_Y =    0;
final float RESULT_Z =   -3;


class UI {
  PFont    font;
  boolean  debug;

  UI() {
//    font = loadFont( "Team401-12.vlw" ); //uncomment for java mode
    font = createFont("Team_401",12); //comment for js mode
    textFont(font);
    debug = false;
  }
  
  void display() {
    switch ( game.state ) {
      case GameState.READY:
        displaySplashScreen();
        displaySplashText( "Simple Blackjack", "press any key to continue" );
        break;
        
      case GameState.DEALING:
        displayPlayScreen();
        displayMainText( "-- Dealing --", "stand by..." );
        displayDebugText();
        break;
        
      case GameState.PLAYER_TURN:
        displayPlayScreen();
        displayMainText( "-- Player's turn --", "'h' to hit, 's' to stand" );
        displayDebugText();
        break;
        
      case GameState.DEALER_TURN:
        displayPlayScreen();
        displayMainText( "-- Dealer's turn --", "stand by..." );
        displayDebugText();
        break;
        
      case GameState.SHOW_RESULTS:
        displayPlayScreen();
        displayMainText( "press any key", "to continue" );
        displayDebugText();
        break;
    }
  }
  void displaySplashScreen(){
    pushMatrix();
    scale(1,-1);
//    image(loadImage("splashScreen.jpg"),-width/2,-height/2);
    popMatrix();
  }
  
  void displayPlayScreen(){
    pushMatrix();
    scale(1,-1);
    image(loadImage("playScreen.jpg"),-width/2,-height/2);
    popMatrix();  
  }
  
  void displaySplashText( String s1, String s2 ) {
    drawTextBlock( 0,0, SPLASH_TEXT, s1,s2, 400,70 );
  }

  void displayMainText( String s1, String s2 ) {
    drawTextBlock( -375,280, MAIN_TEXT, s1,s2, 300,70 );
  }

  void displayPositionIndicator() {
    drawIndicator( POSITION_C, POSITION_SW, POSITION_W,POSITION_H );
  }
  
  void displayActiveIndicator() {
    drawIndicator( ACTIVE_C, ACTIVE_SW, ACTIVE_W,ACTIVE_H );
  }
  
  void displayScore( String s ) {
    drawTextDS( true, SCORE_X,SCORE_Y,SCORE_Z, SCORE_TEXT, s );
  }
  
  void displayResult( int result) {
    switch(result){
      case Result.PLAYER_WINS:
        println("win");
        image(loadImage("win.png"),RESULT_X,RESULT_Y);
        break;
      case Result.PLAYER_LOSES:
        println("lose");
        image(loadImage("lose.png"),RESULT_X,RESULT_Y);
        break;
      case Result.PUSH:
        println("push");
        image(loadImage("push.png"),RESULT_X,RESULT_Y);
        break;
      default:
        break;
    }
  }
  
  void displayDebugText() {
    if ( debug ) {
      pushMatrix();
        translate(-350,200,0);
        drawTextDS( false, 0,  0,0, DEBUG_TEXT, "-- DEBUG --" );
        drawTextDS( false, 0,-25,0, DEBUG_TEXT, "state: "  + GameState.toString(game.state)     );
        drawTextDS(false, 0, -50,0, DEBUG_TEXT, str(game.dealer.deck.numCards)+" cards left in deck");
        drawTextDS(false, 0, -75,0, DEBUG_TEXT, "Value of dealer's hand is "+str(game.dealer.hand.value)); 
      popMatrix();
    }
  }

  void drawTextBlock( float x, float y, color c, String s1, String s2, float w, float h ) {
    pushMatrix();
      translate(x,y,0);
      drawTextDS( false, 0, 12,0, c, s1 );
      drawTextDS( false, 0,-12,0, c, s2 );
      noFill();
      rectMode(CENTER);
      strokeWeight(1);
      stroke(DROP_SHADOW);
      rect( 1,-1, w,h );
      stroke(c);
      rect( 0, 0, w,h );
    popMatrix();
  }

  void drawTextDS( boolean drawR, float x, float y, float z, color col, String s ) {
    pushMatrix();
      translate(x,y,z);
      scale(1,-1,1);
      
      if ( drawR ) {
        rectMode(CENTER);
        noStroke();
        fill(SEMITRANS_BG);
        rect( 0,0, 12+textWidth(s),4+textAscent()+textDescent(), 5 );
      }
      
      textAlign(CENTER,CENTER);
      fill(DROP_SHADOW);
      text( s, 1,1 );
      fill(col);
      text( s, 0,0 );
    popMatrix();
  }
  
  void drawIndicator( color sc, float sw, float w, float h ) {
    pushMatrix();
      translate(0,0,3);
      stroke(sc);
      strokeWeight(sw);
      noFill();
      rectMode(CENTER);
      rect(0,0,w,h);
    popMatrix();
  }

  void toggleDebug() {
    debug = !debug;
  }
}

//===============================================
//
// Learning About Blackjack - Pseudo-Library
// Professor Marty Altman
// SCAD-Atlanta
// ITGM 220
// 
// This file contains the definition for a MA_SimpleOrtho class, which represents an
// ortho camera model more like virtually every other graphics system in the known 
// universe, meaning with the origin at the center and the y-axis pointing up.
//
// Use of this camera implies the use of the patterns in the corresponding MA_Graphics 
// class, which takes into account the mojo needed to compensate for processing's semantics.  
//
//===============================================

// colors used for the grid
//
final color cGray80  = color( 204, 204, 204 );
final color cRed     = color( 255,   0,   0 );
final color cGreen   = color(   0, 255,   0 );


class MA_SimpleOrtho {
  float   lEdge,rEdge, tEdge,bEdge;             // offsets around camera position for ortho call
  float   gridLo,gridHi,gridInc,gridCL;         // grid control parameters
  boolean drawGrid;                             // toggles drawing of the grid

  MA_SimpleOrtho() {
    rEdge    =  width/2;                        // this setup insures:
    lEdge    = -rEdge;                          //   - a square grid and 
    tEdge    =  height/2;                       //   - a scale of 1 unit equals 1 pixel
    bEdge    = -tEdge;                          //
    gridLo   = -1000;
    gridHi   =  1000;
    gridInc  =    25;
    gridCL   =     4;
    drawGrid = false;
  }
  
  //===============================================================================  
  // called at the beginning of a frame (bookends, see endFrame() below)
  //
  void beginFrame() {
    //nothing inside here, for now
  }
  
  // called to evaluate the camera (this is the critical method)
  // NOTES: 
  //  - must be called after any updates to the camera position and 
  //      before any other drawing to the frame buffer
  //  - this setup neutralizes processing's insistence on having the origin
  //      at the top left corner and the y-axis pointing down
  //  - use of this camera implies use of the corresponding MA_Graphics class
  //      or at least following of the patterns contained within that class 
  //
  void evaluate() {
    ortho( lEdge,rEdge, bEdge,tEdge, 100,-100 );
    
    resetMatrix();                        // this is loadIdentity()
    scale( 1, -1, 1 );                    // these two compensate for processing's
//    translate( width/2, height/2, 0 );  //   wacky insistence on origin at top left
  }                                       //   and y-axis pointed down....
  
  // called at the end of a frame (bookends, see beginFrame() above)
  //
  void endFrame() {
    if ( drawGrid ) {
      drawReferenceGridXY( gridLo, gridHi, gridInc, gridCL );
    }
  }

  //===============================================================================
  
  void toggleGrid() {
    drawGrid = !drawGrid;
  }
  
  // draws a reference grid on XY plane (to help locate things)
  // - vertical lines from lo to hi, by inc
  // - horizontal lines from lo to hi, by inc
  // - horizontal and vertical axes are drawn "heavy"
  // - every c'th inc line is in color to aid placement
  //   - horizontals are red, verticals are green
  //   - other lines are drawn light gray
  //
  void drawReferenceGridXY( float lo, float hi, float inc, float c ) {
    float zero = inc / 10.0;
    float hiz  = hi + zero;
    strokeWeight( 2 );
    beginShape( LINES );
    for ( float x=lo; x<hiz; x+=inc ) {
      stroke( cGray80, 128 );
      if ( abs(x) < zero ) {
        stroke( cGreen, 255 );
      } else if ( abs(x)%(c*inc) < zero ) {
        stroke( cGreen, 64 );
      }
      vertex( x, lo );
      vertex( x, hi );
      stroke( cGray80, 128 );
      if ( abs(x) < zero ) {
        stroke( cRed, 255 );
      } else if ( abs(x)%(c*inc) < zero ) {
        stroke( cRed, 64 );
      }
      vertex( lo, x );
      vertex( hi, x );
    }
    endShape();
  }
}


