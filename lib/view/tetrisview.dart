part of tetris;

class tetrisview {

  // Schnittstelle zu dem Controller
  controller _con;

  // Element mit der id '#tetrisfield' vom DOM tree zum Setzen des Spielfeldes
  final tetrisfield = querySelector("#tetrisfield");

  // Element mit der id '#tetrisfield' vom DOM tree zum Setzen des Spielfeldes
  final nextTetrimino = querySelector("#nextstone");


  /// Der Konstruktor der [tetrisview].
  /// Erwartet zur Kommunikation die Instanz der controller-Klasse [_con].
  tetrisview(_con);


  /// Aktualisiert das Spielfeld [t] im DOM tree
  void refreshTetrisField(List<List<field>> t) {
    tetrisfield.innerHtml = _tetrisfieldToHTMLTable(t);
  }


  void refreshNextTetrimino(List<List<field>> t) {
    nextTetrimino.innerHtml = _tetrisfieldToHTMLTable(t);
  }


  /// Wandelt das Tetrisspielfeld [t] in eine HTML-Tabelle um
  String _tetrisfieldToHTMLTable(List<List<field>> t) {

    // String zum generieren des HTML-Spielfeldes
    String htmlTable = "<tbody>";

    // Durchläuft jede Zeile des Spielfeldes in der Liste
    for(List<field> row in t) {
      // Erzeugt eine neue Zeile in der HTML-Tabelle
      htmlTable += "<tr>";

      // Durchläuft jedes Feld einer Zeile
      for(field f in row) {
        if (f.status) {
          var c = f.color;
          htmlTable += "<td id=\"$c\"></td>";
        }
        else htmlTable += "<td></td>";
      }

      // Schliesst die Zeile in der HTML-Tabelle
      htmlTable += "</tr>";
    }
    // Schliesst den TableBody und gibt den HTML-String aus
    return htmlTable += "</tbody>";
  }
}