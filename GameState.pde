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
