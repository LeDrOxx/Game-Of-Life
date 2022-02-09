import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:game_of_life/models/cell.dart';

class LifeProvider extends ChangeNotifier {
  // int tableWidth = 80;
  // int tableHeight = 40;

  int tableWidth = 40;
  int tableHeight = 20;
  Map<String, Cell> table = {};

  void populateTable() {
    Random r = Random();
    double trueProbability = .3;
    List.generate(tableWidth, (i) {
      List.generate(tableHeight, (j) {
        table.putIfAbsent('$i/$j',
            () => Cell(x: i, y: j, alive: r.nextDouble() < trueProbability));
      });
    });
  }

  Timer? _timer;

  void initTicker() {
    _timer = Timer.periodic(const Duration(milliseconds: 800), (_) {
      iterate();
    });
  }

  /// Rules :
  /// Any live cell with fewer than two live neighbors dies, as if caused by under population.
  /// Any live cell with two or three live neighbors lives on to the next generation.
  /// Any live cell with more than three live neighbors dies, as if by overpopulation.
  /// Any dead cell with exactly three live neighbors becomes a live cell, as if by reproduction.

  void iterate() {
    Map<String, Cell> nextGen = {};
    nextGen.addAll(table);

    for (int i = 0; i < tableWidth; i++) {
      for (int j = 0; j < tableHeight; j++) {
        bool alive = table['$i/$j']?.alive ?? false;
        int neighboursCount = countNeighbours(i, j, alive);
        // print('cell [$i][$j] (alive : $alive , neighbours : $neighboursCount)');
        if (alive && neighboursCount < 2) {
          // print('am cell [$i][$j] and i should die because my neighbours < 2');
          nextGen.update('$i/$j', (value) => value.copyWith(alive: false));
        } else if (alive && neighboursCount > 3) {
          // print('am cell [$i][$j] and i should die because my neighbours > 3');
          nextGen.update('$i/$j', (value) => value.copyWith(alive: false));
        } else if (!alive && neighboursCount == 3) {
          // print('let there be light for cell [$i][$j]');
          nextGen.update('$i/$j', (value) => value.copyWith(alive: true));
        }
      }
    }
    table.clear();
    table.addAll(nextGen);
    notifyListeners();
  }

  int countNeighbours(int x, int y, bool alive) {
    int count = 0;
    for (int rowMod = -1; rowMod <= 1; rowMod++) {
      for (int colMod = -1; colMod <= 1; colMod++) {
        int nx = x + rowMod;
        int ny = y + colMod;
        if (nx >= 0 &&
            nx < tableWidth &&
            ny + colMod >= 0 &&
            ny + colMod < tableHeight) {
          if (table['${x + rowMod}/${y + colMod}']?.alive ?? false) {
            count++;
          }
        }
      }
    }
    if (alive) count--;
    return count;
  }

  void toggle() {
    if (_timer?.isActive ?? false) {
      _timer!.cancel();
    } else {
      initTicker();
    }
    notifyListeners();
  }

  void toggleCell(int x, int y) {
    table.update('$x/$y',
        (value) => value.copyWith(alive: !(table['$x/$y']?.alive ?? false)));
    notifyListeners();
  }

  bool get isTicking => _timer?.isActive ?? false;
}
