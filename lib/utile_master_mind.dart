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
    
    // 1. Creare copie e marcare gli elementi in posizione corretta (Pin Neri).
    List<T?> tempSoluzione = List<T?>.from(listaSoluzione);
    List<T?> tempTentativo = List<T?>.from(listaTentativo);
    
    for (int i = 0; i < tempSoluzione.length; i++) {
      if (tempSoluzione[i] == tempTentativo[i]) {
        // Escludi dalla verifica successiva.
        tempSoluzione[i] = null; 
        tempTentativo[i] = null;
      }
    }
    
    // 2. Contare la Frequenza dei colori rimanenti nella Soluzione.
    Map<T, int> frequenzeSoluzione = {};
    for (T? elemento in tempSoluzione) {
      if (elemento != null) {
        frequenzeSoluzione[elemento] = (frequenzeSoluzione[elemento] ?? 0) + 1;
      }
    }
    
    // 3. Contare le Corrispondenze (Pin Bianchi) nel Tentativo Rimanente.
    int conteggioPosizioneDiversa = 0;
    
    for (T? elementoTentativo in tempTentativo) {
      if (elementoTentativo != null) {
        if (frequenzeSoluzione.containsKey(elementoTentativo) && frequenzeSoluzione[elementoTentativo]! > 0) {
          conteggioPosizioneDiversa++;
          // CONSUMA l'occorrenza per evitare doppi conteggi.
          frequenzeSoluzione[elementoTentativo] = frequenzeSoluzione[elementoTentativo]! - 1;
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