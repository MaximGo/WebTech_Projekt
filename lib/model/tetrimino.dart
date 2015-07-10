part of tetris;

/// Die Klasse [tetrimino] representiert einen Spielstein.
class tetrimino {

  String            _type;                // Typ des Tetrimino z.B. 'z'
  String            _color;               // Farbe des Tetrimino z.B. 'Schwarz'
  int               _actAlignmentIndex;   // Index der Liste, welche die aktuelle Ausrichtung ist
  List<String>      _hexAlignments;       // Liste aller 4 Ausrichtungen
  List<List<field>> _tetriminoField;      // Liste des 4x4 Tetriminos
  int               _startsAtLevel;
  bool              _isJoker;

  /// Konstruktor der Klasse Tetrimino.
  /// Benötigt den [_type] und die [_hexAlignments].
  tetrimino(this._type, this._hexAlignments, this._startsAtLevel, this._isJoker);

  List<List<field>> get tetriminoField => _tetriminoField;
  List<String> get hexAlignments => _hexAlignments;
  String get type => _type;
  bool get isJoker => _isJoker;
  int get startsAtLevel => _startsAtLevel;


  /// Generiert eine FieldListe aus einem [hexAlignment]
  List<List<field>> _createFieldList(String hexAlignment) {

    // Erstellt ein Tetriminofeld
    List<List<field>> t_field = new List<List<field>>();
    // Schneidet das '0x' am Anfang ab
    String hexStr = hexAlignment.substring(2);

    // Damit der Spielstein auf der Y-Ebene noch über dem Spielfeld liegt
    int height = -4;

    // Durchläuft jede Ziffer
    for (var c in hexStr.split('')) {

      // Für die Zentrierung des Spielsteines am oberen Ende
      int width = (gamedata._tetrisFieldWidth / 2).toInt() - 1;

      // Wandelt die Ziffer in Binär um
      String binValue = num.parse("0x$c").toInt().toRadixString(2).padLeft(4, '0');
      // Bildet eine Zeile des Spielsteines ab
      var row = new List<field>();

      // Befüllt die Zeile
      for (var b in binValue.split('')) {
        bool status = b.startsWith('1');
        field f = new field(width, height, status);
        row.add(f);
        width += 1;
      }
      // Fügt die Zeile dem Tetriminofeld hinzu
      t_field.add(row);
      height += 1;
    }
    return t_field;
  }


  /// Bereitet den Spielstein für den Einsatz vor
  tetrimino getReadyForUse(String color) {
    // Wählt eine zufällige Ausrichtung und erstellt das Feld
    final random = new Random();
    _actAlignmentIndex = random.nextInt(_hexAlignments.length);
    var hexAlignment = _hexAlignments[_actAlignmentIndex];
    _tetriminoField = _createFieldList(hexAlignment);
    // Setzt die Farbe und gibt den tetrimino zurück
    _setTetriminoColor(color);
    return this;
  }


  /// Aktualisiert die neue Ausrichtung
  List<List<field>> _refreshAlignmentInFieldList(List<List<field>> newField) {

    int x = 0;
    for (List<field> row in newField) {

      int y = 0;
      for (field f in row) {
        f.posX = _tetriminoField[x][y].posX;
        f.posY = _tetriminoField[x][y].posY;
        if (f.status) f.color = _color;
        y += 1;
      }
      x += 1;
    }

    _tetriminoField = newField;
    return newField;
  }


  /// Setzt die Farbe des Spielsteines
  void _setTetriminoColor(String color) {

    _color = color;

    // Durchläuft jedes Feld einer Zeile
    for(List<field> row in _tetriminoField) {
      for(field f in row) {
        if(f.status) {
          f.color = color;
        }
      }
    }
  }


  /// Dreht den Spielstein nach links
  List<List<field>> rotateLeft() {

    _actAlignmentIndex == 0 ? _actAlignmentIndex = 3 : _actAlignmentIndex -= 1;

    var newField = _createFieldList(_hexAlignments[_actAlignmentIndex]);
    return _refreshAlignmentInFieldList(newField);
  }


  /// Dreht den Spielstein nach rechts
  List<List<field>> rotateRight() {

    _actAlignmentIndex == 3 ? _actAlignmentIndex = 0 : _actAlignmentIndex += 1;

    var newField = _createFieldList(_hexAlignments[_actAlignmentIndex]);
    return _refreshAlignmentInFieldList(newField);
  }


  /// Bewegt den Spielstein um ein Feld nach rechts
  List<List<field>> moveRight() {

    for (List<field> row in _tetriminoField) {
      for (field f in row) {
        f.posX += 1;
      }
    }
    return _tetriminoField;
  }


  /// Bewegt den Spielstein um ein Feld nach links
  List<List<field>> moveLeft() {

    for (List<field> row in _tetriminoField) {
      for (field f in row) {
        f.posX -= 1;
      }
    }
    return _tetriminoField;
  }


  /// Bewegt den Spielstein um ein Feld nach unten
  List<List<field>> moveDown() {

    for (List<field> row in _tetriminoField) {
      for (field f in row) {
        f.posY += 1;
      }
    }
    return _tetriminoField;
  }


  /// Bewegt den Spielstein um ein Feld nach oben
  List<List<field>> moveUp() {

    for (List<field> row in _tetriminoField) {
      for (field f in row) {
        f.posY -= 1;
      }
    }
    return _tetriminoField;
  }
}