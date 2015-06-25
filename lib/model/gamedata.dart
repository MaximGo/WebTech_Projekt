part of tetris;

// Die möglichen Nachrichten, die dem Benutzer angezeigt werden
final Map<String, String> message = {
  'gs':'Bitte drücken Sie auf den Startknopf um das Spiel zu starten.',
  'go':'Oooh Nein! Sie haben Leider Verloren :('
};

/// Reine Datenklasse für die Datenhaltung des Tetrismodels
class gamedata {

  // Die Breite des Spielfeldes (statisch)
  static int _tetrisFieldWidth = 0;
  static int get tetrisFieldWidth => _tetrisFieldWidth;
  static void set tetrisFieldWidth(int w) { _tetrisFieldWidth = w; }


  // Die Höhe des Spielfeldes (statisch)
  static int _tetrisFieldHeight = 0;
  static int get tetrisFieldHeight => _tetrisFieldHeight;
  static void set tetrisFieldHeight(int h) { _tetrisFieldHeight = h; }


  // Bildet das gesamte Spielfeld ab
  List<List<field>> _tetrisField;
  List<List<field>> get tetrisField => _tetrisField;
  void set tetrisField(List<List<field>> f) { _tetrisField = f; }


  // Liste der verfügbaren Tetriminos
  tetriminos _tetriminoList;
  tetriminos get tetriminoList => _tetriminoList;
  void set tetriminoList(tetriminos t) { _tetriminoList = t; }


  // Merkt sich den aktuellen Tetrimino
  tetrimino _currentTetrimino;
  tetrimino get currentTetrimino => _currentTetrimino;
  void set currentTetrimino(tetrimino t) { _currentTetrimino = t; }


  // Merkt sich den nächsten Tetrimino
  tetrimino _nextTetrimino;
  tetrimino get nextTetrimino => _nextTetrimino;
  void set nextTetrimino(tetrimino t) { _nextTetrimino = t; }


  // Merkt sich das aktuelle Level
  level _currentLevel;
  level get currentLevel => _currentLevel;
  void set currentLevel(level l) { _currentLevel = l; }


  // Merkt sich die Nachricht, die für den Benutzer ausgegeben wird
  String _message;
  String get message => _message;
  void set message(String msg) { _message = msg; }


  // Die Geschwindigkeit der Spielsteine (ms = Millisekunden)
  int _tetriminoSpeed = 1000;
  int get tetriminoSpeed => _tetriminoSpeed;
  void set tetriminoSpeed(int s) { _tetriminoSpeed = s; }


  // Die Anzahl der erreichten Punkte
  int _points = 0;
  int get points => _points;
  void set points(int p) { _points = p; }


  // Merkt sich den Spielstatus
  bool _gameEnd = false;
  bool get gameEnd => _gameEnd;
  void set gameEnd(bool ge) { _gameEnd = ge; }

  // Die möglichen Farben der Spielsteine
  List<String> _colorList = ["red", "blue", "yellow", "green"];
  /// Gibt eine zufällige Farbe zurück
  String get randomColor {

    Random rand = new Random();
    int index = rand.nextInt(_colorList.length);
    return _colorList[index];
  }
}