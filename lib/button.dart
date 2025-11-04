import 'package:flutter/material.dart';

class Button extends StatefulWidget {
  final int riga;
  final int colonna;
  final List<Color> coloriDisponibili;
  final bool isEnabled;
  final Function(int r, int c, Color colore)? onColorChanged;//funzione che segnala il cambiamento di colore passata come parametro quando instanzio il bottone

  const Button({
    super.key,
    required this.riga,
    required this.colonna,
    required this.coloriDisponibili,
    this.onColorChanged,
    this.isEnabled = true,
  });

  @override
  State<Button> createState() => _ButtonState();
}

class _ButtonState extends State<Button> {
  Color _currentColor = Colors.grey;

  //funzione che cambia il colore internamente
  void _cambiaColore() {
    if (!widget.isEnabled) return;

    setState(() {
      int i = widget.coloriDisponibili.indexOf(_currentColor);
      if (i == -1) {
        _currentColor = widget.coloriDisponibili[0];
      } else if (i == widget.coloriDisponibili.length - 1) {
        _currentColor = widget.coloriDisponibili[0];
      } else {
        _currentColor = widget.coloriDisponibili[i + 1];
      }
    });

    if (widget.onColorChanged != null) {
      widget.onColorChanged!(widget.riga, widget.colonna, _currentColor);//quando il pulsante cambia il colore lo segnalo al main
    }
  }

  @override
Widget build(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 5),
    child: IgnorePointer( 
      ignoring: !widget.isEnabled,//se il pulsante è disattivato rimangono comunque i colori
      child: ElevatedButton(
        onPressed: _cambiaColore, 
        style: ElevatedButton.styleFrom(
          backgroundColor: _currentColor,
          shape: const CircleBorder(),
          minimumSize: const Size(40, 40),
        ),
        child: const Text(""),
      ),
    ),
  );
}
}