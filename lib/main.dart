import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:game_of_life/controllers/life_provider.dart';
import 'package:game_of_life/ui/playground_screen.dart';
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
      home: PlaygroundScreen(),
    );
  }
}
