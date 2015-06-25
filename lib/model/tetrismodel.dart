part of tetris;

class tetrismodel {
  controller _con;
  gamedata _data;
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

  List<List<field>> _startGame(){
    gamedata d = readJsonFile("??");
    d.currentTetrimino = d.tetriminoList.getNextRandomTetrimino(_data.randomColor);
    d.nextTetrimino = d.tetriminoList.getNextRandomTetrimino(_data.randomColor);
    return d.tetrisField;
  }
  
  void _stopGame() {
    _data.gameEnd = true;
    //Hier würde vermutlich auf der View irgend ne Message ausgeschmissen werden
  }

  bool checkTetriminoPosition(List<List<field>> tetrimin) {
    List<List<field>> checkField = _data.tetrisField;
    for (List<field> rowField in checkField) {
      for (field tetF in rowField) {
        for (List<field> row in tetrimin) {
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

  ///Liest den json File aus und erstellt der Reihe nach Tetriminos, level,
  ///gamedata und befüllt das Feld.
  gamedata readJsonFile(String uri) {
    File file = new File("uri");
    Map json = JSON.decode(file.readAsStringSync());

    tetriminos t = new tetriminos();
    Map tetrimins = json["Tetriminos"];
    for (String type in tetrimins.keys) {
      t.createTetriminoAndAddToList(type, json["Tetriminos"][type]);
    }

    Map lev = json["LevelStart"];
    level l = new level(1, lev["LevelAufstieg"], lev["Reihe1"], lev["Reihe2"],
        lev["Reihe3"], lev["Reihe4"]);

    gamedata d = new gamedata(t, l);
    Map spielfeld = json["Spielfeld"];
    int hoehe = spielfeld["Hoehe"];
    int breite = spielfeld["Breite"];
    gamedata.tetrisFieldHeight = hoehe;
    gamedata.tetrisFieldWidth = breite;
    List<List<field>> li = new List<List<field>>();
    for (int i = 0; i < hoehe; i++) {
      List<field> row = new List<field>();
      for (int j = 0; j < breite; j++) {
        row.add(new field(j, i, false));
      }
      li.add(row);
    }
    this._data = d;
    return d;
  }
}
