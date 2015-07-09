part of tetris;

/// Die Klasse [tetrismodel] beinhaltet die gesamte Logik des TetrisSpielkonzeptes.
class tetrismodel {
  gamedata _data;
  controller _con;
  int _rotaLock = 0;

  /// Konstruktor der Klasse tetrismodel.
  /// Erwartet eine Instanz des Controllers [_con].
  tetrismodel(this._con);

  /// Versucht den Tetrimino nach Links zu drehen, sollte das nicht klappen,
  /// wird er wieder zurückgedreht. Gilt für alle rotate und move Methoden.
  /// Außerdem wird der Tetrimino in das Tetrisfeld integriert um auf der View angezeigt zu werden,
  /// und anschließend wieder gelöscht, damit er beim drehen oder verschieben nicht mit der eigenen vorherigen
  /// Position kollidiert.
  void rotateLeft() {
    // Sperre die Rotation, falls zehn Züge keine Reihe mehr gelöscht wurde. Analog für rotateRight
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
      _data.gameEnd = false;
      if (integrateTetrimino(current.tetriminoField)) {
        _stopGame();
        return;
      }
      
      // Wenn der derzeitige Stein ein Joker ist, werden die Reihen entsprechend dem Joker gelöscht und die Punkteberechnung durchgeführt.
      if (current.isJoker) {
        _jokerExplosion();
        setRotaLock(true);
        calculateRowElimination(1);
        nextTetrimino();
        return;
      }

      nextTetrimino();

      // Checkt ob Reihen gelöscht wurden und falls ja, werden die Punkte berechnet
      int deletedRows = checkRows();
      if (deletedRows > 0) {
        calculateRowElimination(deletedRows);
        setRotaLock(true);
      } else {
        setRotaLock(false);
      }
    } else {
      integrateTetrimino(current.tetriminoField);
      deleteTetrimino(current.tetriminoField);
    }

    _con.refreshNextTetrimino(_data.nextTetrimino.tetriminoField);
  }

  /// Wenn [rowsDeleted] true ist, wird der Zähler bis zur Rotationssperre resetet,
  /// andernfalls wird er um 1 erhöht.
  /// Sollte er dabei die 10 überschreiten (also 1 Zug nach der Rotationssperre sein)
  /// wird wieder von vorne angefangen zu zählen.
  void setRotaLock(bool rowsDeleted) {
    if (rowsDeleted) {
      _rotaLock = 0;
      _con.refreshMessage("");
    } else {
      if (_rotaLock < 10) {
        _rotaLock++;
        if (_rotaLock == 10) {
          _con.refreshMessage(message["rl"]);
        }
      } else {
        _rotaLock = 0;
        _con.refreshMessage("");
      }
    }
  }

  /// Der derzeitige Tetrimino wird auf den nächsten gesetzt und der nächste wird zu einem zufälligen Tetrimino.
  /// Desweiteren wird eine Joker Message ausgegeben sollte der derzeitige Tetrimino ein Joker geworden sein.
  void nextTetrimino() {
    _data.currentTetrimino = _data.nextTetrimino;
    _data.nextTetrimino =
        _data.tetriminoList.getNextRandomTetrimino(_data.randomColor);
    if (_data.currentTetrimino.isJoker) _con.refreshMessage(message['jt']);
  }

  /// Berechnet die Punkte die es für das löschen von Reihen gibt und erhöht das Level, falls nötig.
  void calculateRowElimination(int solvedRows) {
    level l = _data._currentLevel;
    _data.points = l.getPointsForSolvedRows(solvedRows);
    _con.refreshPoints(_data.points);
    if (l.increaseLevel(_data.points)) {
      increaseSpeed();
      _data.tetriminoList.addToRdyList(l.number);
      _con.refreshLevel(l);
    }
  }

  /// Startet das Spiel (fügt alle Tetriminos die ab Level 1 fallen der rdyList hinzu und setzt derzeitigen und nächsten Tetrimino.
  List<List<field>> startGame() {
    _data.tetriminoList.addToRdyList(_data.currentLevel.number);
    // Holt sich den aktuellen und den nächsten Spielstein
    _data.currentTetrimino =
        _data.tetriminoList.getNextRandomTetrimino(_data.randomColor);
    _data.nextTetrimino =
        _data.tetriminoList.getNextRandomTetrimino(_data.randomColor);
    if (_data.currentTetrimino.isJoker) _con.refreshMessage(message['jt']);
    // Gibt das Spielfeld zur Ausgabe auf der View zurück
    _con.refreshPoints(_data.points);
    _con.refreshLevel(_data.currentLevel);
    return _data.tetrisField;
  }

  /// Beendet das Spiel
  void _stopGame() {
    _data.gameEnd = true;
    _con.refreshMessage(message["go"]);
    _con.cancelTimer();
    _con.stopListening();
  }

  
  /// Löscht Reihen entsprechend der Höhe des Jokers.
  void _jokerExplosion() {
    List<List<field>> tetField = _data.currentTetrimino.tetriminoField;
    for (int i = 0; i < tetField.length; i++) {
      for (int j = 0; j < tetField[i].length; j++) {
        if (tetField[i][j].status) {
          deleteRow(_data.tetrisField[tetField[i][j].posY]);
          rowMoveUp(_data.tetrisField, tetField[i][j].posY);
          break;
        }
      }
    }

    _con.refreshMessage(message['em']);
  }
  
  /// Prüft auf vollstände Reihen und löscht diese.
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
      // Ist die Reihe voll so wird sie gelöscht. Ist sie es nicht rückt sie nach.
      if (piecesInTheRightPlace == gamedata.tetrisFieldWidth) {
        deleteRow(tetField[i]);
        rowMoveUp(tetField, i);
        i++;
        rowsDeleted++;
      }
      piecesInTheRightPlace = 0;
    }
    return rowsDeleted;
  }

/// Versetzt jede Reihe im [tetField] ab der Höhe [i] um 1 nach unten.
  void rowMoveUp(List<List<field>> tetField, int i) {
    if (i == 0) return;
    for (i -= 1; i >= 0; i--) {
      for (int j = 0; j < tetField[i].length; j++) {
        // Ist das aktuelle Feld belegt und das darunter nicht, dann versetze
        // das aktuelle Feld nach unten
        tetField[i + 1][j] = tetField[i][j];
        tetField[i][j] = new field(j, i, false);
      }
    }
  }

  /// Löscht eine übergebene Reihe [row]
  void deleteRow(List<field> row) {
    for (int i = 0; i < row.length; i++) {
      row[i] = new field(row[i].posX, row[i].posY, false);
    }
  }

  /// Entfernt einen Spielstein [tetrimino] aus dem Tetrisfeld
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

  /// Fügt einen Spielstein [tetrimino] dem Tetrisfeld hinzu
  /// und ermittelt ob das Spiel beendet ist
  bool integrateTetrimino(List<List<field>> tetrimino) {
    
    // Holt sich das Spielfeld
    List<List<field>> checkField = _data.tetrisField;

    // Durchläuft jede Zeile und jedes Feld des Steines
    for (List<field> row in tetrimino) {
      for (field f in row) {
        if (f.status) {
          if (!(f.posY < 0)) checkField[f.posY][f.posX] = f;
          else _data.gameEnd = true;
        }
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
    List tetrimins = json["Tetriminos"];
    for (int i = 0; i < tetrimins.length; i++) {
      if(tetrimins[i]["joker"]== null) t.createTetriminoAndAddToList(tetrimins[i]["type"],
          tetrimins[i]["alignments"], tetrimins[i]["level"],false);
      else t.createTetriminoAndAddToList(tetrimins[i]["type"],
          tetrimins[i]["alignments"], tetrimins[i]["level"],
          tetrimins[i]["joker"]);
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

  /// Erhöht die Geschwindigkeit der Spielsteine wenn sie nicht schon am Maximum ist
  void increaseSpeed() {
    final newSpeed =
        gamedata.tetriminoSpeed * pow(0.95, _data.currentLevel.number);
    _con.increaseSnakeSpeed(newSpeed);
  }
}
