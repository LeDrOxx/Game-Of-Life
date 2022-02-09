import 'package:flutter/material.dart';
import 'package:game_of_life/components/cell_widget.dart';
import 'package:game_of_life/controllers/life_provider.dart';
import 'package:provider/provider.dart';

class PlaygroundScreen extends StatefulWidget {
  const PlaygroundScreen({Key? key}) : super(key: key);

  @override
  State<PlaygroundScreen> createState() => _PlaygroundScreenState();
}

class _PlaygroundScreenState extends State<PlaygroundScreen> {
  @override
  void initState() {
    Provider.of<LifeProvider>(context, listen: false).populateTable();
    super.initState();
  }

  ///Keeps the cells size responsive and to avoid overflowing
  ///in case of window change on (Web / Desktop)
  double getSize({required int tableWidth, required int tableHeight}) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    double size = 15;

    while ((tableWidth * (size + 8)) + 4 * size > screenWidth ||
        (tableHeight * (size + 8)) + 4 * size > screenHeight) {
      size -= .03;
    }
    return size > 0 ? size : 0;
  }

  @override
  Widget build(BuildContext context) {
    final lifeProvider = Provider.of<LifeProvider>(context);
    double calculatedSize = getSize(
        tableWidth: lifeProvider.tableWidth,
        tableHeight: lifeProvider.tableHeight);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Center(
            child: Container(
              width: (calculatedSize + 8) * lifeProvider.tableWidth +
                  4 * calculatedSize,
              height: (calculatedSize + 8) * lifeProvider.tableHeight +
                  4 * calculatedSize,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.green)),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            verticalDirection: VerticalDirection.up,
            children: List.generate(
              lifeProvider.tableHeight,
              (j) => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                    lifeProvider.tableWidth,
                    (i) => Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: InkWell(
                            onTap: () {
                              Provider.of<LifeProvider>(context, listen: false)
                                  .toggleCell(i, j);
                            },
                            child: CellWidget(
                              calculatedSize: calculatedSize,
                              i: i,
                              j: j,
                            ),
                          ),
                        )),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Provider.of<LifeProvider>(context, listen: false).toggle();
        },
        child: Icon(lifeProvider.isTicking ? Icons.pause : Icons.play_arrow),
      ),
    );
  }
}
