import 'package:flutter/material.dart';
import 'button.dart';
import 'utile_master_mind.dart';



void main() {
  runApp(const MasterMindApp());
}


class MasterMindApp extends StatelessWidget {
  const MasterMindApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Master Mind',
      theme: ThemeData(
        colorSchemeSeed: const Color.fromARGB(255, 183, 208, 230),
        useMaterial3: true,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        colorSchemeSeed: const Color.fromARGB(255, 160, 187, 211),
        useMaterial3: true,
        brightness: Brightness.dark,
      ),
      home: const MasterMind(title: 'Master Mind'),
      debugShowCheckedModeBanner: false,
    );
  }
}


class MasterMind extends StatefulWidget {
  const MasterMind({super.key, required this.title});

  final String title;

  @override
  State<MasterMind> createState() => _MasterMind();
}

class _MasterMind extends State<MasterMind> {
  List <bool> _verified = []; //rige verificate e non (già confrontate con la soluzione)
  List<List<Color>> _coloriButtons = [];//stato dei colori dei bottoni
  List<List<bool>> _enabledButtons = [];//bottoni attivati
  List<List<Color>> _feedbackPins = [];//colori dei pins che danno il feedback al giocatore
  final List<Color> _colori = [Colors.red,Colors.orange,Colors.yellow,Colors.green, Colors.blue,   Colors.brown, Colors.black, Colors.white];
  late List<List<Button>> _buttons; //lista contenente i bottoni che viene inizializzata ad initState
  List<Color> _corrects = []; //lista con la combinazione di colori corretti
  final int _nRighe = 10;
  final int _nColonne = 4;
  String _stato = "Partita in cosro...";//stato della partita


  @override
  void initState() {
    super.initState();
    _corrects = UtileMasterMind.combinazioneColori(_colori);
    _verified = List.generate(_nRighe, (_)=> false);
    _coloriButtons = List.generate(_nRighe, (_) => List.generate(_nColonne, (_) => Colors.grey));//colore iniziale dei pulsanti
    _enabledButtons = List.generate(_nRighe, (r) => List.generate(_nColonne, (_) => r == 0));//bottoni attivati solo se siamo nella prima riga
    _feedbackPins = List.generate(_nRighe, (_) => List.generate(4, (_) => Colors.grey)); 
    _buttons = _creaButtons();
  }
  
  List<List<Button>> _creaButtons() {
    return List.generate(_nRighe, (r) =>
      List.generate(_nColonne, (c) =>
        Button(
          riga: r,
          colonna: c,
          coloriDisponibili: _colori,
          isEnabled: _enabledButtons[r][c], 
          onColorChanged: (riga, col, colore) {
            setState(() {
              _coloriButtons[riga][col] = colore; //imposto la matrice con tutti i colori al colore del pulsante
            });
          },//funzione che verrà chiamata dal bottone stesso quando cambierà colore
        )
      )
    );
  }

  void _verifica(int riga) {
    //verifico che: la riga del pulsante che è stao premuto sia attivata, che tutti i pulsanti siano stati premuti almeno 1 volta e
    //che la riga noon sia già stata confrontata con la soluzione
    if (_enabledButtons[riga][0] && !_coloriButtons[riga].contains(Colors.grey) && !_verified[riga]) {
      _verified[riga] = true;
      int posCorrette = UtileMasterMind.posUguali(_corrects, _coloriButtons[riga]);
      int posDiv = UtileMasterMind.posDiv(_corrects, _coloriButtons[riga]);
      setState(() {
        if(posCorrette == 4){
          _stato = "Hai vinto!!";
          for (int i = 0; i < posCorrette; i++) {
            _feedbackPins[riga][i] = Colors.green;
          }
          _mostraPopupFinePartita("Hai vinto!");
          //se tutti i colori sono corretti mostro tutti i pin verdi ed il popup
        }else if (riga == _nRighe - 1) {
          _stato = "Hai perso!";
          for (int i = 0; i < posCorrette; i++) {
            _feedbackPins[riga][i] = Colors.green;
          }
          for(int i = posCorrette; i < 4; i++){
            _feedbackPins[riga][i] = Colors.red;
          }
          _mostraPopupFinePartita("Hai perso!", mostraSoluzione: true);
          //se sono sull'ultima riga mostro i pin corretti e non e mostro il pupup
        }else{
          for (int i = 0; i < posCorrette; i++) {
            _feedbackPins[riga][i] = Colors.black;
          }
          for (int i = posCorrette; i < posCorrette + posDiv; i++) {
            _feedbackPins[riga][i] = Colors.white;
          }
          for (int i = posCorrette + posDiv; i < 4; i++) {
            _feedbackPins[riga][i] = Colors.grey;
          }
          //coloro i pin in base ai colori azzeccati
          if (riga + 1 < _nRighe) {
            for (int i = 0; i < _nColonne; i++) {
              //attivo i bottoni della riga successiva
              _enabledButtons[riga + 1][i] = true;
            }
          }
          for (int i = 0; i < _nColonne; i++) {
            //disattivo i bottoni della riga corrente
            _enabledButtons[riga][i] = false;
          }
          _buttons = _creaButtons();
        }
      });
    }
  }

  List<Widget> generate() {
    const SizedBox  space = SizedBox(
      width: 80.0,  // Stima della larghezza del bottone "Check"
      height: 48.0, // Stima dell'altezza del bottone "Check"
    );
    List<Widget> widgets = [];
    for (int i = 0; i < _nRighe; i++) {
      List<Widget> feedback = [];
      for (var colore in _feedbackPins[i]) {
        // Crea il Container per il singolo pin.
        final pinWidget = Container(
          width: 15,
          height: 15,
          margin: const EdgeInsets.symmetric(horizontal: 2),
          decoration: BoxDecoration(
            color: colore, // Utilizza il colore corrente
            shape: BoxShape.circle,
            border: Border.all(color: Colors.black),
          ),
        );
        feedback.add(pinWidget);
      }
      
      if(_enabledButtons[i][0]){
// se la riga contiene bottoni attivati allora deve esserci anche il pulsante check
        widgets.add(Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextButton(
            onPressed: () => _verifica(i),
            style: TextButton.styleFrom(
              foregroundColor: Colors.white, 
              backgroundColor: Colors.blue, 
              minimumSize: const Size(80.0, 48.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
            )),
            child: const Text("Check"),
          ),
          ..._buttons[i],//prende tutti i bottoni separatamente e lli inserisce in widgets
          const SizedBox(width: 20),
          ...feedback,
        ],
      ));
      }else{
        widgets.add(Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            space,//sizedBox di = grandezza rispetto al pulsante check in modo che le linee siano allineate
            ..._buttons[i],
            const SizedBox(width: 20),
            ...feedback,
          ],
        ));
      }
      widgets.add(const SizedBox(height: 10));
    }
    return widgets;
  }

  void _mostraPopupFinePartita(String messaggio, {bool mostraSoluzione = false}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        titlePadding: const EdgeInsets.only(left: 16, right: 8, top: 8),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              messaggio,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                Navigator.of(context).pop();
                //si chiude il popup
              },
            ),
          ],
        ),
        content: mostraSoluzione //se deve mostrare anche la soluzione (partita persa)
            ? Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text("La combinazione corretta era:"),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: _corrects.map((color) {
                      return Container(
                        width: 30,
                        height: 30,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.black),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              )
            : null,
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          ElevatedButton(
            child: const Text("Nuova partita"),
            onPressed: () {
              Navigator.of(context).pop(); 
              _nuovaPartita();
              //si chiude il popup e qiama nuovaPartita            
            },
          ),
        ],
      );
    },
  );
}

void _nuovaPartita () {
  //obblica a ricaricare l'app
  Navigator.pushReplacement(
    context,
    PageRouteBuilder(
      pageBuilder: (context, _, __) =>
          const MasterMind(title: 'Master Mind'),
      transitionDuration: Duration.zero,
    ),
  );
}

  @override
  Widget build (BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.amber,
      ),
      body: Center(
        child: SingleChildScrollView( 
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: _colori.map((colore) {
                  return Container(
                    width: 30,
                    height: 30,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      color: colore,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.black, width: 1),
                    ),
                  );
                }).toList(),
              ),//mette tutti i colori disponibili
            const SizedBox(height: 40),
            ...generate(),//mette i pulsanti
            const SizedBox(height: 20),
              Text(_stato, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),//mette il testo con lo stato
            ]
          ),
        ),
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(10),
        ),
        child: IconButton(
          icon: Icon(Icons.refresh),
          color: Colors.black,
          onPressed: _nuovaPartita,
        ),//pulsante che permettere di ricominciare la partita
      ),
    );
  }
}