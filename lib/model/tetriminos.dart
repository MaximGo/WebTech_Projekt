part of tetris;

/// Die Klasse [tetriminos] beinhaltet eine Liste über die verfügbaren Tetrimino-Steine und
/// stellt Funktionen zur Verwaltung der Liste zur Verfügung.
class tetriminos {

  // Liste der geladenen Tetriminosteine
  List<tetrimino> _tetriminoList = new List<tetrimino>();
  List<tetrimino> _rdyList = new List<tetrimino>();


  /// Fügt alle Tetriminos deren Level kleiner oder gleich dem aktuellen Level sind, der rdyList hinzu
  void addToRdyList(int lvl){
    for(tetrimino t in _tetriminoList){
      if(t.startsAtLevel<=lvl && !(_rdyList.contains(t))) _rdyList.add(t);
    }
  }

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
  /// Benötigt den [type], die Ausrichtungen [hexAlignments], den Levelstart [startsAtLevel] und die Jokereigenschaft [joker]
  /// Gibt beim erfolgreichen Hinzufügen true sonst false zurück
  bool createTetriminoAndAddToList(String type, List<String> hexAlignments, int startsAtLevel, bool joker) {

    // Erstellt einen Tetrimino und versucht ihn der Liste hinzuzufügen
    tetrimino t = new tetrimino(type, hexAlignments, startsAtLevel, joker);
    return addTetriminoToList(t);
  }


  /// Gibt einen neuen Spielstein für das Spiel
  /// Erwartet einen Farbe [color] für den Spielstein
  tetrimino getNextRandomTetrimino(String color) {

    // Wählt einen zufälligen Spielstein aus der Liste heraus
    final random = new Random();
    tetrimino t = _rdyList[random.nextInt(_rdyList.length)];
    tetrimino clone = new tetrimino(t.type, t.hexAlignments, t.startsAtLevel, t.isJoker);
    // Bereitet den Tetrimino auf den Einsatz vor und gibt diesen aus
    return clone.getReadyForUse(color);
  }
}