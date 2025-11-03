import 'dart:math';

class UtileMasterMind{

  static bool vittoria<T>(List<T> listaSoluzione, List<T> listaB) {
    if (listaSoluzione.length != listaB.length) {
      return false; 
    }

    for (int i = 0; i < listaSoluzione.length; i++) {
      if (listaSoluzione[i] != listaB[i]) {
        return false;
      }
    }
    
    return true;
  }

  static int posDiv<T>(List<T> listaSoluzione, List<T> listaTentativo) {
  // 1. Identificare gli indici di Pin Neri (posizione e valore corretti).
  List<int> indiciNeri = [];

  for (int i = 0; i < listaSoluzione.length; i++) {
    if (listaSoluzione[i] == listaTentativo[i]) {
      indiciNeri.add(i);
    }
  }

  // 2. Creare liste SENZA gli elementi che hanno dato Pin Nero.
  List<T> soluzioneRimanente = [];
  List<T> tentativoRimanente = [];

  for (int i = 0; i < listaSoluzione.length; i++) {
    if (!indiciNeri.contains(i)) {
      soluzioneRimanente.add(listaSoluzione[i]);
      tentativoRimanente.add(listaTentativo[i]);
    }
  }

  // 3. Contare la Frequenza dei colori rimanenti nella Soluzione.
  // Usa il metodo update per inizializzare il conteggio a 1 se la chiave non esiste.
  Map<T, int> frequenzeSoluzione = {};
  for (T elemento in soluzioneRimanente) {
    frequenzeSoluzione.update(
      elemento,
      (value) => value + 1,
      ifAbsent: () => 1,
    );
  }

  // 4. Contare le Corrispondenze (Pin Bianchi) nel Tentativo Rimanente.
  int conteggioPosizioneDiversa = 0;

  for (T elementoTentativo in tentativoRimanente) {
    // Verifica esplicita con containsKey() per evitare l'accesso a null
    if (frequenzeSoluzione.containsKey(elementoTentativo)) {
      int conteggioDisponibile = frequenzeSoluzione[elementoTentativo] as int;

      if (conteggioDisponibile > 0) {
        conteggioPosizioneDiversa++;
        // Riduciamo il conteggio
        frequenzeSoluzione[elementoTentativo] = conteggioDisponibile - 1;
      }
    }
  }

  return conteggioPosizioneDiversa;
}

  static int posUguali<T>(List<T> listaSoluzione, List<T> listaB){
    int count = 0;
    if (listaSoluzione.length != listaB.length) {
      return 0; 
    }
    for( int i = 0; i < listaSoluzione.length; i++){
      if(listaSoluzione[i] == listaB[i]){
        count++;
      }
    }
    return count;
  }


  static List<T> combinazioneColori<T>(List<T> colori) {
    List<T> comb = [];
    var random = Random();
    if (colori.isEmpty) {
      return comb;
    }
    int numColoriDisponibili = colori.length;
    for (int i = 0; i < 4; i++) {
      comb.add(colori[random.nextInt(numColoriDisponibili)]);
    }
    return comb;
  }

}