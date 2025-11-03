# Master_Mind
Fabio Riccato
Progetto Flutter che riproduce il gioco MasterMind, in cui il giocatore deve indovinare una combinazione segreta di colori entro un numero limitato di tentativi.

Come funziona il gioco:
-All’inizio della partita viene generata in modo casuale una sequenza di 4 colori segreti (tra 8 disponibili).
-Colori disponibili: rosso, arancione, giallo, verde, blu, marrone, nero e bianco. Il variare dei colori quando cliccati segue questa sequenza.
-Il giocatore deve selezionare i colori in ogni riga per provare a indovinare la combinazione.
-Ogni riga rappresenta un tentativo.
-Dopo aver inserito i 4 colori, il giocatore preme "Check" per ottenere un feedback:
    -Pallino nero --> Colore corretto e posizione corretta
    -Pallino bianco --> Colore presente nella combinazione, ma posizione sbagliata
    -Pallino grigio --> Colore non presente nella combinazione
    -Pallino rosso/verde --> Solo opo aver permuto check sull'ultima riga (partita terminata) verranno mostrati tot pallini verdi in base ai colori azzeccati sulla posizione giusta e  tot palini rossi in base ai colori non azzeccati nella posizione giusta.

Partita terminata:
-La partita termina quando viene inserita una combinazione di colori corretta. In questo caso viene mostrato a schermo un popup (che è possibile chiudere) con scritto "hai vinto!"  con anche un pulsante sotto con cui è possibile iniziare una nuova partiita.
-La partita termina anche quando vengono utilizzati tutti i tentativi senza aver indovinato la combinazione. Anche in questo caso viene mostrato a schermo un popup (che è possibile chiudere) con scritto "hai perso!", sotto è presente anche la combinazioni di colori corretta e alla fine,anche in questo caso, è presente un pulsante con cui è possibile iniziare una nuova partiita.

In basso a destra dell'applicazione è anche presente un pulsante per giocare una nuova partita (se premuto cancella tutti i colori e genera una nuova combinazione corretta).

Scelte di sviluppo:
-Utilizzo di una lista per caricare i bottoni: questa scelta fa si che i pulsanti possano riistanziati e resi cliccabili/non cliccabili senza che questi tornino al colore base ma nel momento in cui si vuole permettere di fare una nuova partita al giocatore l'operazione diventa più difficile perchè anche in questo caso il colore non viene resettato dunque sarà necessario "ricaricare" l'app. Un altro asptto positivo è che si diminuiscono le linee di codice in quanto i bottoni non vengono instanziati tutti sul build.
-Creazione di una classe supplementare per utilizzare i bottoni: in flutter non è possibile cambiare lo stato di un pulsante dal main se non sostituendo il pulsante con un pulsante nuovo, per ciò nella classe supplementare farò in modo che il pulsante possa cambiare stato dentro la sua classe a prescindere dal main. In questo modo potro cambiare il colore del bottone senza fare un bottone nuovo. Il main saprà comunque il colore che assume il pulsante tramite una funzione che passo al pulsante che verrà richiamata dal pulsante stesso ma che verrà eseguita dal main; questa funzione cambierà una matrice instanziata nella classe MasterMind in cui vengono memorizzati tutti i colori che i pulsanti assumono.
-Utilizzo classe UtileMasterMind: tramite questa classe cerco ,come possibile, di separare la logica del gioco MasterMind dalla parte grafica