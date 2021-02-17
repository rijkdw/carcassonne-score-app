class Player {

  // ------------------------------------------------------------
  // attributes
  // ------------------------------------------------------------

  String name;
  String colour;
  int score;


  // ------------------------------------------------------------
  // constructors & factories
  // ------------------------------------------------------------

  Player({this.name="Player", this.colour="brown", this.score=0}) {
    colour = colour.toLowerCase();
  }

}