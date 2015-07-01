part of tetris;

/// Die Klasse [tetrismodel] beinhaltet die gesamte Logik des TetrisSpielkonzeptes.
class tetrismodel {
  gamedata _data;
  controller _con;
  int _rotaLock = 0;

  /// Konstruktor der Klasse tetrismodel.
  /// Erwartet eine Instanz des Controllers [_con].
  tetrismodel(this._con);

  ///Versucht den Tetrimino nach Links zu drehen, sollte das nicht klappen,
  ///wird er wieder zurückgedreht. Gilt für alle rotate und move Methoden.
  void rotateLeft() {
    // Sperre die Rotation, falls zehn Züge keine Reihe mehr gelöscht wurde
    if (_rotaLock == 10) return;
    tetrimino current = _data.currentTetrimino;
    if (!checkTetriminoPosition(current.rotateLeft())) {
      current.rotateRight();
    } else {
      integrateTetrimino(current.tetriminoField);
      deleteTetrimino(current.tetriminoField);
    }
  }

  void rotateRight() {
    // Sperre die Rotation, falls zehn Züge keine Reihe mehr gelöscht wurde
    if (_rotaLock == 10) return;
    tetrimino current = _data.currentTetrimino;
    if (!checkTetriminoPosition(current.rotateRight())) {
      current.rotateLeft();
    } else {
      integrateTetrimino(current.tetriminoField);
      deleteTetrimino(current.tetriminoField);
    }
  }

  void moveRight() {
    tetrimino current = _data.currentTetrimino;
    if (!checkTetriminoPosition(current.moveRight())) {
      current.moveLeft();
    } else {
      integrateTetrimino(current.tetriminoField);
      deleteTetrimino(current.tetriminoField);
    }
  }

  void moveLeft() {
    tetrimino current = _data.currentTetrimino;
    if (!checkTetriminoPosition(current.moveLeft())) {
      current.moveRight();
    } else {
      integrateTetrimino(current.tetriminoField);
      deleteTetrimino(current.tetriminoField);
    }
  }

  void moveDown() {
    tetrimino current = _data.currentTetrimino;
    if (!checkTetriminoPosition(current.moveDown())) {
      current.moveUp();
      if (integrateTetrimino(current.tetriminoField)) _stopGame;

      //aktueller wird auf nächsten Tetrimino gesetzt und der nächste holt sich einen Zufälligen.
      _data.currentTetrimino = _data.nextTetrimino;
      _data.nextTetrimino =
          _data.tetriminoList.getNextRandomTetrimino(_data.randomColor);

      // Checkt ob Reihen gelöscht wurden und falls ja, werden die Punkte berechnet
      int deletedRows = checkRows();
      if (deletedRows > 0) {
        calculateRowElimination(deletedRows);
        // Resetet den Rotrationsblock Counter
        _rotaLock = 0;
      } else {
        // Erhöht den Counter, es sei denn er ist schon bei 10, dann wird er wieder resetet
        if (_rotaLock < 10) _rotaLock++;
        else _rotaLock = 0;
      }
    } else {
      integrateTetrimino(current.tetriminoField);
      deleteTetrimino(current.tetriminoField);
    }

    _con.refreshNextTetrimino(_data.nextTetrimino.tetriminoField);
  }

  /// Berechnet die Punkte die es für das löschen von Reihen gibt
  void calculateRowElimination(int solvedRows) {
    level l = _data._currentLevel;
    _data.points = l.getPointsForSolvedRows(solvedRows);
    if (_data.points >= l.pointsForNextLevel) {
      //_data.increaseLevel();
    }
  }

  /// Startet das Spiel
  List<List<field>> startGame() {

    // Holt sich den aktuellen und den nächsten Spielstein
    _data.currentTetrimino =
        _data.tetriminoList.getNextRandomTetrimino(_data.randomColor);
    _data.nextTetrimino =
        _data.tetriminoList.getNextRandomTetrimino(_data.randomColor);
    // Gibt das Spielfeld zur Ausgabe auf der View zurück
    return _data.tetrisField;
  }

  /// Beendet das Spiel
  void _stopGame() {
    _data.gameEnd = true;
    // TODO - Nachricht auf der Oberfläche ausgeben
    String msg = message["go"];
  }

  /// Prüft auf gelöschte Reihen
  int checkRows() {
    int rowsDeleted = 0;
    List<List<field>> tetField = _data.tetrisField;
    int piecesInTheRightPlace = 0;
    for (int i = tetField.length - 1; i >= 0; i--) {
      for (int j = 0; j < tetField[i].length; j++) {
        if (tetField[i][j].status) piecesInTheRightPlace++;
      }
      // Ist kein einziger Stein mehr in der Reihe wird hier abgebrochen
      if (piecesInTheRightPlace == 0) return rowsDeleted;
      // Ist die Reihe voll so wird sie gelöscht. Ist sies nicht rückt sie nach.
      if (piecesInTheRightPlace == gamedata.tetrisFieldWidth) {
        deleteRow(tetField[i]);
        rowMoveUp(tetField, i);
        rowsDeleted++;
      }
      piecesInTheRightPlace = 0;
    }
    return rowsDeleted;
  }

  /// Prüft das ganze Tetrisfeld und lässt, in der Luft schwebende Blöcke nachrücken
  void rowMoveUp(List<List<field>> tetField, int i) {
    if (i == 0) return;
    for (i -= 1; i >= 0; i--) {
      for (int j = 0; j < tetField[i].length; j++) {
        // Ist das aktuelle Feld belegt und das darunter nicht, dann versetze
        // das aktuelle Feld nach unten
        tetField[i + 1][j] = tetField[i][j];
        tetField[i][j] = new field(i, j, false);
      }
    }
  }

  /// Löscht eine übergebene Reihe [row]
  void deleteRow(List<field> row) {
    for (int i = 0; i < row.length; i++) {
      row[i] = new field(row[i].posX, row[i].posY, false);
    }
  }

  /// Entfernt einen Spielstein [tetrimino] aus der Spielfeldliste
  void deleteTetrimino(List<List<field>> tetrimino) {

    // Holt sich das Spielfeld
    List<List<field>> checkField = _data.tetrisField;
    // Durchläuft jedes Zeile und jedes Feld des Steines
    for (List<field> row in tetrimino) {
      for (field f in row) {
        if (f.status) if (f._posY >= 0) checkField[f.posY][f.posX] =
            new field(f.posX, f.posY, false);
      }
    }
  }

  /// Fügt einen Spielstein [tetrimino] der Spielfeldliste hinzu
  /// und ermittelt ob das Spiel beendet ist
  bool integrateTetrimino(List<List<field>> tetrimino) {

    // Holt sich das Spielfeld
    List<List<field>> checkField = _data.tetrisField;

    // Durchläuft jede Zeile und jedes Feld des Steines
    for (List<field> row in tetrimino) {
      for (field f in row) {
        if (!(f.posY < 0) && f.status) checkField[f.posY][f.posX] = f;
        else _data.gameEnd = true;
      }
    }
    _con.refreshTetrisField(checkField);
    return _data.gameEnd;
  }

  /// Prüft ob sich der Spielstein [tetrimino] in einem gültigen Feld befindet
  /// oder sich auf einen anderen Spielstein setzt
  bool checkTetriminoPosition(List<List<field>> tetrimino) {

    // Holt sich das Spielfeld
    List<List<field>> checkField = _data.tetrisField;

    // Durchläuft jedes Zeile und jedes Feld vom Stein
    for (List<field> row in tetrimino) {
      for (field f in row) {
        //check ob der Stein rechts, links oder unten mit einer Wand kollidiert
        if (f.status) {
          if (f.posX >= gamedata.tetrisFieldWidth ||
              f.posX < 0 ||
              f.posY >= gamedata.tetrisFieldHeight) return false;

          if (f.posY >= 0) {
            //check ob der Stein mit einem anderen Tetrimino kollidiert
            if (checkField[f.posY][f.posX].status) return false;
          }
        }
      }
    }
    return true;
  }

  Future loadData(String uri) {
    HttpRequest.getString(uri).then(readJsonFileAndCreateData);
  }

  /// Liest das JSON-File der [uri] aus und erstellt der Reihe nach Tetriminos, level,
  /// gamedata und befüllt das Feld.
  void readJsonFileAndCreateData(String responseText) {
    // Lädt die JSON-Datei
    Map json = JSON.decode(responseText);

    // Ausgabe der Datei in der Console
    print(responseText);

    // Liest die Tetriminosteine
    tetriminos t = new tetriminos();
    Map tetrimins = json["Tetriminos"];
    for (String type in tetrimins.keys) {
      t.createTetriminoAndAddToList(type, json["Tetriminos"][type]);
    }

    // Liest die Basisleveldaten
    Map lev = json["LevelStart"];
    level l = new level(1, lev["Levelaufstieg"], lev["Reihe1"], lev["Reihe2"],
        lev["Reihe3"], lev["Reihe4"]);

    // Erstellt die gamedata
    _createGameData(t, l);
    _con.startGame();
  }

  /// Füllt die GameData-Klasse mit Daten
  /// Benötigt dazu die geladenen Tetriminos [tetriminoList], die Levelbasis [lev], sowie die
  /// Höhe [tHeight] und Breite [tWidth] des Spielfeldes
  void _createGameData(tetriminos tetriminoList, level lev) {

    // Erzeugt eine neue Instanz der gamedata und füllt diese mit den nötigen Daten
    _data = new gamedata();
    _data.tetriminoList = tetriminoList;
    _data.currentLevel = lev;
    _data.tetrisField =
        _createFieldList(gamedata.tetrisFieldHeight, gamedata.tetrisFieldWidth);
  }

  /// Erstellt das Spielfeld und bildet es in einer Liste ab
  /// Benötigt dazu die Höhe [height] und Breite [width] des Spielfeldes
  List<List<field>> _createFieldList(int height, int width) {
    var fieldList = new List<List<field>>();

    for (int i = 0; i < height; i++) {
      List<field> row = new List<field>();
      for (int j = 0; j < width; j++) {
        row.add(new field(j, i, false));
      }
      fieldList.add(row);
    }
    return fieldList;
  }

  // Erhöht das Level sowie die Anzahl der Punkte zum Levelaufstieg
  void increaseLevel() {

    //increaseSpeed();
  }

  //Erhöht die Geschwindigkeit der Spielsteine wenn sie nicht schon am Maximum ist
  void increaseSpeed() {
    // if (_tetriminoSpeed > maxSpeed) _tetriminoSpeed -= 10;
  }
}
