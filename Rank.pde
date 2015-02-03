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
