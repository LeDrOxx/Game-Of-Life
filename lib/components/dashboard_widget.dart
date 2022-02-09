import 'package:flutter/material.dart';
import 'package:game_of_life/controllers/life_provider.dart';
import 'package:provider/provider.dart';

class DashboardWidget extends StatefulWidget {
  const DashboardWidget({Key? key}) : super(key: key);

  @override
  _DashboardWidgetState createState() => _DashboardWidgetState();
}

class _DashboardWidgetState extends State<DashboardWidget> {
  @override
  Widget build(BuildContext context) {
    final lifeProvider = Provider.of<LifeProvider>(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton(
                  onPressed: () =>
                      Provider.of<LifeProvider>(context, listen: false)
                          .toggle(),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          lifeProvider.isTicking
                              ? Icons.pause
                              : Icons.play_arrow_outlined,
                          color: Colors.green,
                        ),
                      ),
                      Text(
                        lifeProvider.isTicking ? 'Pause' : 'Play',
                        style: const TextStyle(
                            color: Colors.green, fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () =>
                      Provider.of<LifeProvider>(context, listen: false).reset(),
                  child: Row(
                    children: const [
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.restart_alt_outlined,
                          color: Colors.green,
                        ),
                      ),
                      Text(
                        'Reset',
                        style: TextStyle(
                            color: Colors.green, fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  'Alive Cells : ${lifeProvider.countLives()}',
                  style: const TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.w700,
                      fontSize: 14),
                ),
                Text(
                  'Play Time : ${formattedTime()}',
                  style: const TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.w700,
                      fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String formattedTime() {
    final lifeProvider = Provider.of<LifeProvider>(context);
    return Duration(seconds: lifeProvider.playTimeInSeconds)
        .toString()
        .replaceAll('.000000', '');
  }
}
