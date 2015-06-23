part of tetris;

/// Die Klasse [tetrimino] representiert einen Spielstein.
class tetrimino {

  String            _type;
  String            _color;
  int               _actAlignmentIndex;
  List<String>      _hexAlignments;
  List<List<field>> _tetriminoField;

  /// Konstruktor der Klasse Tetrimino.
  /// Benötigt den [_type] und die [_hexAlignments].
  tetrimino(this._type, this._hexAlignments);


  /// Generiert eine FieldListe aus einem [hexAlignment]
  List<List<field>> _createFieldList(String hexAlignment) {
    // Erstellt ein Tetriminofeld
    List<List<field>> t_field = new List<List<field>>();
    // Schneidet das '0x' am Anfang ab
    String hexStr = hexAlignment.substring(2);

    // Durchläuft jede Ziffer
    for (var c in hexStr.split('')) {
      // Wandelt die Ziffer in Binär um
      String binValue = num.parse("0x$c").toInt().toRadixString(2).padLeft(4, '0');
      // Bildet eine Zeile des Spielsteines ab
      var row = new List<field>();

      // Befüllt die Zeile
      for (var b in binValue.split('')) {
        // Pos '0:0' weil der Spielstein sich noch nicht im Spielfeld befindet
        bool status = b.startsWith('1');
        field f = new field(0, 0, status);
        row.add(f);
      }
      // Fügt die Zeile dem Tetriminofeld hinzu
      t_field.add(row);
    }
    return t_field;
  }


  /// Bereitet den Spielstein für den Einsatz vor
  List<List<field>> getReadyForUse(String color) {
    // Wählt eine zufällige Ausrichtung und erstellt das Feld
    final random = new Random();
    _actAlignmentIndex = random.nextInt(_hexAlignments.length);
    var hexAlignment = _hexAlignments[_actAlignmentIndex];
    _tetriminoField = _createFieldList(hexAlignment);
    // Setzt die Farbe und gibt das Tetriminofled zurück
    return _setTetriminoColor(color);
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
  List<List<field>> _setTetriminoColor(String color) {

    _color = color;

    // Durchläuft jedes Feld einer Zeile
    for(List<field> row in _tetriminoField) {
      for(field f in row) {
        if(f.status) {
          f.color = color;
        }
      }
    }

    return _tetriminoField;
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


  /// Bewegt den Spielstein nach rechts
  List<List<field>> moveRight() {

    for (List<field> row in _tetriminoField) {
      for (field f in row) {
        f.posX += 1;
      }
    }
    return _tetriminoField;
  }


  /// Bewegt den Spielstein nach links
  List<List<field>> moveLeft() {

    for (List<field> row in _tetriminoField) {
      for (field f in row) {
        f.posX -= 1;
      }
    }
    return _tetriminoField;
  }
}