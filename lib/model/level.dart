part of tetris;

/// Die Klasse [level] stellt ein Levelsystem dar, welches die Punktzahl zum nächsten Level sowie
/// die erreichten Punkte pro aufgelöster Reihe berechnet
class level {

  int _number;                    // Aktuelle Levelnummer
  int _pointsForNextLevel;        // Punkte für das nächste Level
  int _factorForOneRow;           // Punkte für eine aufgelöste Reihe
  int _factorForTwoRows;          // ...
  int _factorForThreeRows;        // ...
  int _factorForFourOrMoreRows;   // ...


  /// Konstruktor der Klasse Level
  level(this._number, this._pointsForNextLevel, this._factorForOneRow, this._factorForTwoRows,
      this._factorForThreeRows, this._factorForFourOrMoreRows);

  /// Getter für die Levelnummer
  int get number => _number;
  void set number(int n) { _number = n; }
  /// Getter für die nötigen Punkte zum Levelaufstieg
  int get pointsForNextLevel => _pointsForNextLevel;
  void set pointsForNextLevel(int l) { _pointsForNextLevel = l; }
  int get factorForFourOrMoreRows => _factorForFourOrMoreRows;


  /// Gib die erhaltenen Punkte für eine aufgelöste Reihe zurück
  /// Erwartet die Anzahl der aufgelösten Reihen [solvedRows]
  int getPointsForSolvedRows(int solvedRows){

    switch (solvedRows){
      case 1: return _factorForOneRow*_number;
      case 2: return _factorForTwoRows*_number;
      case 3: return _factorForThreeRows*_number;
      default: return _factorForFourOrMoreRows*_number;
    }
  }

}