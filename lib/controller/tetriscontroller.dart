part of tetris;

/// Die controller-Klasse kümmert sich um die Kommunikation zwischen View und Model.
/// Außerdem läuft hier der Timer für das Fallen des Spielsteines und auch die Benutzereingaben werden hier abgefangen
class tetriscontroller {

  // Instazen der Schnittstellen
  tetrismodel _model;
  tetrisview _view;

  // Timer für das Bewegen der Tetriminos
  Timer _moveTimer;
  // Keydown Listener
  var _keyDownListenerlistener;


  /// Konstruktor der controller Klasse
  tetriscontroller() {

    // Erzeugt eine Instanzen der nötigen Schnittstellen
    _model = new tetrismodel(this);
    _view = new tetrisview(this);

    // Zeigt die Willkommensnachricht an
    _view.refreshStartText(message['gs']);
    // Hört auf den Klick des Startbuttons und liest dann die JSON-Datei ein
    _view.startButton.onClick.listen((_) { _model.loadData("resc/Tetris.json"); });
  }

  /// Hört auf die Keyevents zu überwachen
  void stopKeyListening() { _keyDownListenerlistener.cancel(); }

  /// Hört auf den Tetrisstein automatisch nach unten zu verschieben
  void cancelMoveTimer() { _moveTimer.cancel(); }

  /// Startet das Spiel
  void startGame() {

    // Wechselt zu der Gameview
    _view.showGameview();
    // Startet das Spiel
    var tetrisfield = _model.startGame();
    // Zeigt das Spielfeld in der View an
    refreshTetrisField(tetrisfield);
    // Startet den Timer
    _moveTimer = new Timer.periodic(gamedata.tetriminoSpeed, (_) => _moveTetrimino());

    // Überwacht die nötigen Keyevents
    _keyDownListenerlistener = window.onKeyDown.listen((KeyboardEvent ev) {
      switch (ev.keyCode) {
        case KeyCode.LEFT:  _model.moveLeft(); break;
        case KeyCode.RIGHT:  _model.moveRight(); break;
        case KeyCode.DOWN: _model.moveDown(); break;
        case KeyCode.UP: _model.rotateRight(); break;
      }
    });
  }


  /// Zeigt das Spielfeld [t] auf der View an
  void refreshTetrisField(List<List<field>> t) { _view.refreshTetrisField(t); }

  /// Zeigt den nächsten Stein [t] auf der View an
  void refreshNextTetrimino(List<List<field>> t) { _view.refreshNextTetrimino(t); }

  /// Zeigt eine Nachricht [msg] auf der Oberfläche an
  void refreshMessage(String msg) { _view.refreshMessage(msg); }

  /// Zeigt das Level [lev] auf der Oberfläche an
  void refreshLevel(level lev) { _view.refreshLevel(lev); }

  /// Zeigt die Punkte [points] auf der Oberfläche an
  void refreshPoints(int points) { _view.refreshPoints(points); }

  /// Aktualisiert den Geschwindigkeitstimer der Tetriminos
  void increaseTetriminoSpeed(Duration newSpeed) {
    _moveTimer.cancel();
    _moveTimer = new Timer.periodic(newSpeed, (_) => _moveTetrimino());
  }

  /// Wird von dem Timer angesteuert, wenn der Spielstein bewegt werden soll
  void _moveTetrimino() { _model.moveDown(); }
}