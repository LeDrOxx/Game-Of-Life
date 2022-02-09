import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:game_of_life/life_provider.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeRight,
    DeviceOrientation.landscapeLeft,
  ]).then((_) {
    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider.value(
            value: LifeProvider(),
          ),
        ],
        child: const MyApp(),
      ),
    );
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Game of Life',
      home: BoardScreen(),
    );
  }
}

class BoardScreen extends StatefulWidget {
  const BoardScreen({Key? key}) : super(key: key);

  @override
  State<BoardScreen> createState() => _BoardScreenState();
}

class _BoardScreenState extends State<BoardScreen> {
  @override
  void initState() {
    Provider.of<LifeProvider>(context, listen: false).populateTable();
    super.initState();
  }

  ///Keeps the boxes size responsive and to avoid overflowing
  ///in case of window change on (Web / Desktop)
  double getSize({required int tableWidth, required int tableHeight}) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    double size = 15;

    while ((tableWidth * (size + 8)) > screenWidth ||
        (tableHeight * (size + 8)) > screenHeight) {
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
      body: Column(
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
                        child: SizedBox(
                          width: calculatedSize,
                          height: calculatedSize,
                          child: AnimatedContainer(
                            decoration: BoxDecoration(
                              color: lifeProvider.table['$i/$j']?.alive ?? false
                                  ? Colors.green
                                  : Colors.transparent,
                              shape: BoxShape.rectangle,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(4.0)),
                            ),
                            duration: const Duration(milliseconds: 200),
                            // curve: Curves.bounceInOut,
                          ),
                        ),
                      ),
                    )),
          ),
        ),
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
