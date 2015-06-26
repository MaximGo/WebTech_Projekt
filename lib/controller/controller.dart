part of tetris;

/// Die controller-Klasse kümmert sich um die Kommunikation zwischen View und Model.
/// Außerdem läuft hier der Timer für das Fallen des Spielsteines und auch die Benutzereingaben werden hier abgefangen
class controller {

  // Instaz der Modelschnittstelle
  tetrismodel _model;
  // Instanz der Viewschnittstelle
  tetrisview _view;

  // Timer für das Bewegen der Tetriminos
  Timer moveTimer;

  /// Konstruktor der controller Klasse
  controller() {

    // Erzeugt eine Instanz der Modelschnittstelle
    _model = new tetrismodel(this);
    // Erzeugt eine Instanz der Viewschnittstelle
    _view = new tetrisview(this);
    // Liest die JSON-Datei ein
    _model.loadData("resc/Tetris.json");
  }


  void startGame() {
     // Startet das Spiel
     var tetrisfield = _model._startGame();
     // Zeigt das Spielfeld in der View an
     showTetrisfield(tetrisfield);
     // Startet den Timer
     // TODO - Speed aus der gamedata auslesen
     moveTimer = new Timer.periodic(const Duration(milliseconds: 700), (_) => _moveTetrimino());

    // Steering of the snake
      window.onKeyDown.listen((KeyboardEvent ev) {

        switch (ev.keyCode) {
          case KeyCode.LEFT:  _model.moveLeft(); break;
          case KeyCode.RIGHT:  _model.moveRight(); break;
          case KeyCode.DOWN: _model.rotateLeft(); break;
          case KeyCode.UP: _model.rotateRight(); break;
        }
      });
  }


  /// Zeigt das Spielfeld auf der View an.
  /// Erwartet das Spielfeld [t].
  void showTetrisfield(List<List<field>> t) {
    _view.refreshTetrisField(t);
  }

  void showNextTetrimino(List<List<field>> t) {
    _view.refreshNextTetrimino(t);
  }


  /// Wird von dem Timer angesteuert, wenn der Spielstein bewegt werden soll
  void _moveTetrimino() { _model.moveDown(); }
}