part of tetris;

class level {
  int _number;
  int _pointsForNextLevel;
  int _factorForOneRow;
  int _factorForTwoRows;
  int _factorForThreeRows;
  int _factorForFourOrMoreRows;

  level(this._number, this._pointsForNextLevel, this._factorForOneRow,
      this._factorForTwoRows, this._factorForThreeRows,
      this._factorForFourOrMoreRows);
  
  int get number => _number;
  int get pointsForNextLevel => _pointsForNextLevel;
 
  int getPointsForSolvedRows(int solvedRows){
    switch (solvedRows){
      case 1:
        return _factorForOneRow*_number;
      case 2:
        return _factorForTwoRows*_number;
      case 3:
        return _factorForThreeRows*_number;
    }
    if(solvedRows >= 4){
      return _factorForFourOrMoreRows*_number;
    }else return 0;
  }
  
  void increaseLevel(){
    _number++;
    _pointsForNextLevel = 3*_factorForFourOrMoreRows*_number;
  }
}
