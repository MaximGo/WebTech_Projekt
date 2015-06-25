part of tetris;

/// Die controller-Klasse kümmert sich um die Kommunikation zwischen View und Model.
/// Außerdem läuft hier der Timer für das Fallen des Spielsteines und auch die Benutzereingaben werden hier abgefangen
class controller {

  // Instaz der Modelschnittstelle
  tetrismodel _model;

  /// Konstruktor der controller Klasse
  controller() {

    // Erzeugt eine Instanz der Modelschnittstelle
    _model = new tetrismodel(this);
    // Liest die JSON-Datei ein
    _model.readJsonFileAndCreateData("/../../other/Tetris.json");
    // Startet das Spiel
    _model._startGame();
  }
}