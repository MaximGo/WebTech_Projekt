part of tetris;

/// Die Klasse [Tetrimino] representiert einen Spielstein.
class Tetrimino {

  String            _type;
  int               _actAlignmentIndex;
  List<String>      _hexAlignments;
  List<List<Field>> _tetriminoField;

  /// Konstruktor der Klasse Tetrimino.
  /// Benötigt den [_type] und die [_hexAlignments].
  Tetrimino(this._type, this._hexAlignments);

  // Getter für den type
  String get type => _type;

  /// Generiert eine FieldListe aus einem [hexAlignment]
  List<List<Field>> _createFieldList(String hexAlignment) {

    // Erstellt ein 4x4 Tetriminofeld
    List<List<Field>> field = new List<List<Field>>();

    // Schneidet das '0x' am Anfang ab
    String hexStr = hexAlignment.substring(2);

    // Durchläuft jede Ziffer
    for (var c in hexStr.split('')) {
      // Wandelt die Ziffer in Binär um
      String binValue = num.parse("0x$c").toInt().toRadixString(2).padLeft(4, '0');
      // Bildet eine Zeile des Spielsteines ab
      var row = new List<Field>();
      // Befüllt die Zeile
      for (var b in binValue) {
        // Pos '0:0' weil der Spielstein sich noch nicht im Spielfeld befindet
        Field field = new Field(0, 0, b);
        row.add(field);
      }
      // Fügt die Zeile dem Tetriminofeld hinzu
      field.add(row);
    }

    return field;
  }

  /// Bereitet den Spielstein für den Einsatz vor
  void getReadyForUse(String color) {

    final random = new Random();
    var hexAlignment = _hexAlignments[random.nextInt(_hexAlignments.length)];
    _tetriminoField = _createFieldList(hexAlignment);
    _setTetriminoColor(color);
  }

  /// Aktualisiert die neue Ausrichtung
  List<List<Field>> _refreshAlignmentInFieldList(List<List<Field>> newField) {

    int x = 0;
    for (List<Field> row in newField) {

      int y = 0;
      for (Field field in row) {
        field.posX = _tetriminoField[x][y].posX;
        field.posY = _tetriminoField[x][y].posY;
        field.color = _tetriminoField[x][y].color;
        y += 1;
      }
      x += 1;
    }

    _tetriminoField = newField;
    return newField;
  }

  /// Setzt die Farbe des Spielsteines
  List<List<Field>> _setTetriminoColor(String color) {

    // Durchläuft jedes Feld einer Zeile
    for(List<Field> row in _tetriminoField) {
      for(Field f in row) {
        if(f.status) {
          f.color = color;
        }
      }
    }

    return _tetriminoField;
  }

  /// Dreht den Spielstein nach links
  List<List<Field>> rotateLeft() {

    _actAlignmentIndex == 0 ? _actAlignmentIndex = 3 : _actAlignmentIndex -= 1;

    var newField = _createFieldList(_hexAlignments[_actAlignmentIndex]);
    return _refreshAlignmentInFieldList(newField);
  }

  /// Dreht den Spielstein nach rechts
  List<List<Field>> rotateRight() {

    _actAlignmentIndex == 3 ? _actAlignmentIndex = 0 : _actAlignmentIndex += 1;

    var newField = _createFieldList(_hexAlignments[_actAlignmentIndex]);
    return _refreshAlignmentInFieldList(newField);
  }

  /// Bewegt den Spielstein nach rechts
  List<List<Field>> moveRight() {

    for (List<Field> row in _tetriminoField) {
      for (Field field in row) {
        field.posX += 1;
      }
    }
    return _tetriminoField;
  }

  /// Bewegt den Spielstein nach links
  List<List<Field>> moveLeft() {

    for (List<Field> row in _tetriminoField) {
      for (Field field in row) {
        field.posX -= 1;
      }
    }
    return _tetriminoField;
  }
}