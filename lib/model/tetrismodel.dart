part of tetris;

/// Die Klasse [tetrismodel] beinhaltet die gesamte Logik des TetrisSpielkonzeptes.
class tetrismodel {

  gamedata _data;
  controller _con;

  /// Konstruktor der Klasse tetrismodel.
  /// Erwartet eine Instanz des Controllers [_con].
  tetrismodel(this._con);


  ///Versucht den Tetrimino nach Links zu drehen, sollte das nicht klappen,
  ///wird er wieder zurückgedreht. Gilt für alle rotate und move Methoden.
  List<List<field>> rotateLeft() {
    tetrimino current = _data.currentTetrimino;
    if (!checkTetriminoPosition(current.rotateLeft())) current.rotateRight();
    return current.tetriminoField;
  }


  List<List<field>> rotateRight() {
    tetrimino current = _data.currentTetrimino;
    if (!checkTetriminoPosition(current.rotateRight())) current.rotateLeft();
    return current.tetriminoField;
  }


  List<List<field>> moveRight() {
    tetrimino current = _data.currentTetrimino;
    if (!checkTetriminoPosition(current.moveRight())) current.moveLeft();
    return current.tetriminoField;
  }


  List<List<field>> moveLeft() {
    tetrimino current = _data.currentTetrimino;
    if (!checkTetriminoPosition(current.moveLeft())) current.moveRight();
    return current.tetriminoField;
  }


  List<List<field>> moveDown() {
    tetrimino current = _data.currentTetrimino;
    if (!checkTetriminoPosition(current.moveDown())) {
      current.moveUp();

      //Da der Tetrimino den Boden erreicht hat, wird er ins Tetrisfield eingebaut
      List<List<field>> checkField = _data.tetrisField;
      for (List<field> rowField in checkField) {
        for (field tetF in rowField) {
          for (List<field> row in current) {
            for (field f in row) {
              ///Sollte der Tetrimino den Boden erreicht haben während er noch nicht ganz
              ///aus der "Decke" rausgefallen ist, heißt das Game Over.
              if(f.posY<0) _stopGame;

              if (f.posX == tetF.posX && f.posY == tetF.posY) {
                tetF = f;
              }
            }
          }
        }
      }

      //aktueller wird auf nächsten Tetrimino gesetzt und der nächste holt sich einen Zufälligen.
      _data.currentTetrimino = _data.nextTetrimino;
      _data.nextTetrimino = _data.tetriminoList.getNextRandomTetrimino(_data.randomColor);
    }
    return current.tetriminoField;
  }


  /// Startet das Spiel
  List<List<field>> _startGame(){

    // Liest die JSON-Datei
    // TODO - Serverpfad angeben
    readJsonFileAndCreateData("/../../other/Tetris.json");
    // Holt sich den aktuellen und den nächsten Spielstein
    _data.currentTetrimino = _data.tetriminoList.getNextRandomTetrimino(_data.randomColor);
    _data.nextTetrimino = _data.tetriminoList.getNextRandomTetrimino(_data.randomColor);
    // Gibt das Spielfeld zur Ausgabe auf der View zurück
    return _data.tetrisField;
  }


  /// Beendet das Spiel
  void _stopGame() {

    _data.gameEnd = true;
    // TODO - Nachricht auf der Oberfläche ausgeben
    String msg = message["go"];
  }


  bool checkTetriminoPosition(List<List<field>> tetrimin) {

    // Holt sich das Spielfeld
    List<List<field>> checkField = _data.tetrisField;
    // Durchläuft jede Zeile des Spielfeldes
    for (List<field> rowField in checkField) {
      // Durchläuft jedes Feld der Zeile
      for (field tetF in rowField) {

        // Durchläuft jedes Zeile des Steines
        for (List<field> row in tetrimin) {
          // Durchläuft jedes Feld vom Stein
          for (field f in row) {
            //check ob der Stein rechts, links oder unten mit einer Wand kollidiert
            if (f.posX >= gamedata.tetrisFieldWidth ||
                f.posX < gamedata.tetrisFieldWidth ||
                f.posY >= gamedata.tetrisFieldHeight) return false;

            //check ob der Stein mit einem anderen Tetrimino kollidiert
            if (f.posX == tetF.posX && f.posY == tetF.posY) {
              if (f.status == true && tetF.status == true) return false;
            }
          }
        }
      }
    }

    return true;
  }


  /// Liest das json File aus und erstellt der Reihe nach Tetriminos, level,
  /// gamedata und befüllt das Feld.
  void readJsonFileAndCreateData(String uri) {

    // Lädt die JSON-Datei
    File file = new File(uri);
    Map json = JSON.decode(file.readAsStringSync());

    // Liest die Tetriminosteine
    tetriminos t = new tetriminos();
    Map tetrimins = json["Tetriminos"];
    for (String type in tetrimins.keys) {
      t.createTetriminoAndAddToList(type, json["Tetriminos"][type]);
    }

    // Liest die Basisleveldaten
    Map lev = json["LevelStart"];
    level l = new level(1, lev["LevelAufstieg"], lev["Reihe1"], lev["Reihe2"], lev["Reihe3"], lev["Reihe4"]);

    // Liest die Spielfelddaten
    Map spielfeld = json["Spielfeld"];

    // Erstellt die gamedata
    _createGameData(t, l, spielfeld["Hoehe"], spielfeld["Breite"]);
  }


  /// Füllt die GameData-Klasse mit Daten
  /// Benötigt dazu die geladenen Tetriminos [tetriminoList], die Levelbasis [lev], sowie die
  /// Höhe [tHeight] und Breite [tWidth] des Spielfeldes
  void _createGameData(tetriminos tetriminoList, level lev, int tHeight, int tWidth) {

    // Erzeugt eine neue Instanz der gamedata und füllt diese mit den nötigen Daten
    _data = new gamedata();
    gamedata.tetrisFieldHeight = tHeight;
    gamedata.tetrisFieldWidth = tWidth;
    _data.tetriminoList = tetriminoList;
    _data.currentLevel = lev;
    _data.tetrisField = _createFieldList(tHeight, tWidth);
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
}