part of tetris;

/// Die Klasse [field] representiert ein einzelnes Feld des gesamten Tetris-Spielfeldes und des Tetriminofeldes
class field {

  // Setzt die Default-Farbe
  String  _color = "rgba(255, 255, 255, 0.1)";
  bool    _status;
  int     _posX;
  int     _posY;

  /// Konstruktor der Klasse Field.
  /// Benötigt die Koordinaten [_posX] und [_posY] sowie den [_status] ob das Feld gesetzt ist oder nicht.
  field(this._posX, this._posY, this._status);

  // Getter und Setter für den Status des Feldes
  bool get status => _status;
  void set status(bool status) {
    this._status = status;
  }

  // Getter und Setter für die Farbe des Feldes
  String get color => _color;
  void set color(String color) {
    this._color = color;
  }

  // Getter für die X-Position des Feldes
  int get posX => _posX;
  void set posX(int posX) {
    this._posX = posX;
  }

  // Getter für die Y-Position des Feldes
  int get posY => _posY;
  void set posY(int posY) {
    this._posY = posY;
  }
}