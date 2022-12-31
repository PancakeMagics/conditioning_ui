import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:conditioning_ui/data/combination.dart';

void main() {
  test('syntax', () {
    const combination = Combination(source: {
      'source',
      'hi',
      'l',
      'hj',
      'hll',
    });

    assert(false, '${combination.permutationCountOf([1, 1, 3])}');
  });
}
