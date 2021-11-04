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

  @override
  Widget build(BuildContext context) {
    final lifeProvider = Provider.of<LifeProvider>(context);
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
                          width: 10.0,
                          height: 10.0,
                          child: AnimatedContainer(
                            decoration: BoxDecoration(
                              color: lifeProvider.table['$i/$j']?.alive ?? false
                                  ? Colors.green
                                  : Colors.white30,
                              shape: BoxShape.rectangle,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(4.0)),
                            ),
                            duration: const Duration(milliseconds: 300),
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
