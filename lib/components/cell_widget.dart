import 'package:flutter/material.dart';
import 'package:game_of_life/controllers/life_provider.dart';
import 'package:provider/provider.dart';

class CellWidget extends StatefulWidget {
  const CellWidget({
    Key? key,
    required this.calculatedSize,
    required this.i,
    required this.j,
  }) : super(key: key);

  final double calculatedSize;

  final int i, j;

  @override
  State<CellWidget> createState() => _CellWidgetState();
}

class _CellWidgetState extends State<CellWidget> {
  @override
  Widget build(BuildContext context) {
    final lifeProvider = Provider.of<LifeProvider>(context);
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: InkWell(
        onTap: () {
          Provider.of<LifeProvider>(context, listen: false)
              .toggleCell(widget.i, widget.j);
        },
        child: SizedBox(
          width: widget.calculatedSize,
          height: widget.calculatedSize,
          child: AnimatedContainer(
            decoration: BoxDecoration(
              color:
                  lifeProvider.table['${widget.i}/${widget.j}']?.alive ?? false
                      ? Colors.green
                      : Colors.transparent,
              shape: BoxShape.rectangle,
              borderRadius: const BorderRadius.all(Radius.circular(4.0)),
            ),
            duration: const Duration(milliseconds: 300),
            // curve: Curves.bounceInOut,
          ),
        ),
      ),
    );
  }
}
