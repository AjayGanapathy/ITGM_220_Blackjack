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
    drawBackground("splashScreen.jpg"); 
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
    translate( -width/2, -height/2, 0 );  //   wacky insistence on origin at top left
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
  
  void drawBgSplashScreen(){
  //call draw bg with image string splash screen
  };
  
  void drawBgGameScreen(){
  //call draw bg with image string game screen
  };
  
  void drawBackground(String backgroundImageString){
    try{
      background(loadImage(backgroundImageString));
    }
    catch(Exception e){
    //if unable to load bg image, default to bg color
      background(NORMAL_BG);
    }
  }
}

