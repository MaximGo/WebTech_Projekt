part of tetris;

/// Die Klasse [tetrisview] dient als Schnittstelle der View und bietet Methoden für den
/// Benutzer zum Interagieren auf der Oberfläche
class tetrisview {

  // Schnittstelle zu dem Controller
  tetriscontroller _con;

  // Holt sich die nötigen DivElemente zum Ein- und Ausblenden
  final _conStart = querySelector(".con_start");
  final _conMessage = querySelector(".con_msg");
  final _conGame = querySelector(".con_game");

  // Holt sich die nötigen Elemente zur Darstellung des Spiels
  final _nextTetrimino = querySelector("#nextstone");
  final startButton = querySelector("#startButton");
  final _startText = querySelector("#startText");
  final _tetrisfield = querySelector("#field");
  final _points = querySelector("#points");
  final _message = querySelector("#msg");
  final _level = querySelector("#level");

  /// Der Konstruktor der [tetrisview].
  /// Erwartet zur Kommunikation die Instanz der controller-Klasse [_con].
  tetrisview(_con);

  /// Wechselt von der Startview zu der Gameview
  void showGameview() {
    _conStart.classes.toggle('close');
    _conGame.classes.toggle('show');
    _conMessage.classes.toggle('show');
    refreshMessage(message['ig']);
  }

  /// Setzt den Starttext [msg] auf der Startseite
  void refreshStartText(String msg) {
    _startText.innerHtml = msg;
  }

  /// Aktualisiert das Spielfeld [t]
  void refreshTetrisField(List<List<field>> t) {
    _tetrisfield.innerHtml = _tetrisfieldToHTMLTable(t);
  }

  /// Aktualisiert den nächst kommenden Stein
  void refreshNextTetrimino(List<List<field>> t) {
    _nextTetrimino.innerHtml = _tetrisfieldToHTMLTable(t);
  }

  /// Aktualisiert die Levelanzeige und erwartet das aktuelle Level [lev]
  void refreshLevel(level lev) {
    var number = lev.number;
    _level.innerHtml = "Level: $number";
  }

  /// Aktualisiert die übergebene Nachricht [msg]
  void refreshMessage(String msg) {
    _message.innerHtml = msg;
  }

  /// Aktualisiert die Punkteanzahl [points]
  void refreshPoints(int points) {
    _points.innerHtml = "Punkte: $points";
  }

  /// Wandelt ein Feld [t] in eine HTML-Tabelle um
  String _tetrisfieldToHTMLTable(List<List<field>> t) {

    // String zum generieren des HTML-Spielfeldes
    String htmlTable = "<table><tbody>";

    // Durchläuft jede Zeile des Spielfeldes in der Liste
    for (List<field> row in t) {
      // Erzeugt eine neue Zeile in der HTML-Tabelle
      htmlTable += "<tr>";

      // Durchläuft jedes Feld einer Zeile
      for (field f in row) {
        if (f.status) {
          var c = f.color;
          htmlTable += "<td id=\"$c\"></td>";
        } else htmlTable += "<td></td>";
      }

      // Schliesst die Zeile in der HTML-Tabelle
      htmlTable += "</tr>";
    }
    // Schliesst den TableBody und gibt den HTML-String aus
    return htmlTable += "</tbody></table>";
  }
}
