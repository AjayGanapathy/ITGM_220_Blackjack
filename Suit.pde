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

