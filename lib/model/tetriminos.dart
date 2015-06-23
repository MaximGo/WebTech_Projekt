part of tetris;

/// Die Klasse [tetriminos] beinhaltet eine Liste über die verfügbaren Tetrimino-Steine und
/// stellt Funktionen zur Verwaltung der Liste zur Verfügung.
class tetriminos {

  // Liste der geladenen Tetriminosteine
  List<tetrimino> _tetriminoList = new List<tetrimino>();

  /// Fügt ein neunen Tetrimino der Liste hinzu.
  /// Gibt beim erfolgreichen Hinzufügen true sonst false zurück
  bool addTetriminoToList(tetrimino t) {

    // Prüft ob der Spielstein schon in der Liste vorhanden ist
    if (_tetriminoList.contains(t)) return false;
    else {
      _tetriminoList.add(t);
      return true;
    }
  }


  /// Erstellt einen Tetrimo und fügt diesen der Liste hinzu
  /// Benötigt den [type] und die Ausrichtungen [hexAlignments]
  /// Gibt beim erfolgreichen Hinzufügen true sonst false zurück
  bool createTetriminoAndAddToList(String type, List<String> hexAlignments) {

    // Erstellt einen Tetrimino und versucht ihn der Liste hinzuzufügen
    tetrimino t = new tetrimino(type, hexAlignments);
    return addTetriminoToList(t);
  }


  /// Gibt einen neuen Spielstein für das Spiel
  /// Erwartet einen Farbe [color] für den Spielstein
  tetrimino getNextRandomTetrimino(String color) {

    // Wählt einen zufälligen Spielstein aus der Liste heraus
    final random = new Random();
    tetrimino t = _tetriminoList[random.nextInt(_tetriminoList.length)];
    // Bereitet den Tetrimino auf den Einsatz vor und gibt diesen aus
    return t.getReadyForUse(color);
  }
}