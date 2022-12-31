import 'package:conditioning_ui/data/collection.dart';
import 'package:conditioning_ui/ui/widget/compose/compose.dart';

///
///
/// TODO: use other data language dependency to deal with combination problem, other than dart
///
///
class Combination<T> {
  final Set<T> source;

  const Combination({required this.source});

  ///
  /// methods, getters:
  /// - [combinationCountOf]
  /// - [permutationCountOf]
  /// - [step]
  /// - [stepsOf]
  /// - [stepsIn1]
  ///

  ///
  /// - example1,
  ///   [source] = {'hello', 'hi', 'apple', 'banana', 'cat'}
  ///   [chunks] = [1, 2, 2]
  ///   - [combinationCountOf] ([chunks]) = C5_1 * C4_2 * C2_2 / 2! = 5 * 6 * 1 / 2 = 15 #
  ///   - [permutationCountOf] ([chunks]) = 15 * 3! = 90 #
  ///
  /// - example2,
  ///   [source] = [1, 2, 3, 4, 5, 6]
  ///   [chunks] = [2, 2, 2]
  ///   - [combinationCountOf] ([chunks]) = C6_2 * C4_2 * C2_2 / 3! = 15 * 6 * 1 / 6 = 15 #
  ///   - [permutationCountOf] ([chunks]) = 15 * 3! = 90 #
  ///
  ///
  int combinationCountOf(Iterable<int> chunks) {
    assert(
      chunks.reduce((a, b) => a + b) == source.length,
      'invalid chunks: $chunks not fit the ${source.length}-length-source',
    );
    int amount = 1;

    int base = source.length;
    for (var chunk in chunks) {
      final theOther = base - chunk;
      amount *= base.factorial ~/
          (chunk.factorial * (theOther == 0 ? 1 : theOther).factorial);
      base -= chunk;
    }

    final set = chunks.toSet();
    return set.length == chunks.length
        ? amount
        : amount ~/
            set
                .map((e) => chunks
                    .fold(0, (value, c) => e == c ? value + 1 : value)
                    .factorial)
                .reduce((value, element) => value * element);
  }

  int permutationCountOf(Iterable<int> chunks) {
    int combination = combinationCountOf(chunks);
    combination *= chunks.length.factorial;
    return combination;
  }

  int get length => source.length;

  Map<int, Iterable<T>> get stepsIn1 => {1: source};

  //
  // Iterable<Map<int, Iterable<T>>> stepsOf(Iterable<int> chunks) {
  //   final result = <Map<int, Iterable<T>>>[];
  //   final stepsAmount = chunks.length;
  //
  //   final item = <int, Iterable<T>>{};
  //
  //   ///
  //   /// 1. find all combination by filter source until it's empty
  //   /// 2. find all permutation on each combination
  //   ///
  //
  //   final pAmount = permutationCountOf(chunks);
  //   final cAmount = pAmount ~/ chunks.length.factorial;
  //
  //   final source = this.source;
  //
  //   int skip = 0;
  //
  //   final combinations = <Iterable<T>>[];
  //
  //   ///
  //   ///
  //   /// [source] = [1, 2, 3, 4, 5, 6]
  //   /// [chunks] = [2, 2, 2]
  //   /// combinations1 = [1, 2], [3, 4], [5, 6]
  //   /// combinations2 = [1, 3], [2, 4], [5, 6]
  //   /// combinations3 = [1, 4], [2, 3], [5, 6]
  //   /// combinations4 = [1, 5], [2, 3], [5, 6]
  //   /// combinations5 = [1, 6], [2, 3], [4, 5]
  //   ///
  //   /// c1 = [1, 2], [3, 4], [5, 6]
  //   /// c1' = [1, 2], [3, 5], [4, 6]
  //   /// c1'' = [1, 2], [3, 6], [4, 5]
  //   ///
  //   /// 5 * 3 = 10
  //   ///
  //   findCombination:
  //   for (var chunk in chunks) {
  //     final combination = <T>[];
  //
  //     final sourceLength = source.length;
  //     for (var i = 1; i <= sourceLength; i++) {
  //       if (combination.length != chunk) {
  //         combination.add(source.elementAt(i - 1));
  //       } else {
  //         combinations.add(combination);
  //         source.removeAll(combination);
  //         skip += 1;
  //         continue findCombination;
  //       }
  //     }
  //   }
  //
  //   // item.putIfAbsent(c + 1, () => step);
  //   result.add(item);
  //
  //   assert(result.length == pAmount);
  //   return result;
  // }

  Map<int, Iterable<T>> step(Combiner<T> combiner) =>
      source.fold(<int, Iterable<T>>{}, (steps, data) {
        final index = combiner(data);
        assert(
          index <= source.length && index > 0,
          'invalid combination index: $index not in range 0...${source.length}',
        );

        while (steps.length < index) {
          steps.putIfAbsent(steps.length + 1, () => []);
        }
        return steps..update(index, (value) => [...value, data]);
      });
}

typedef Combiner<T> = int Function(T value);
typedef Combine<T> = Map<int, Iterable<T>> Function(Combiner<T> combine);
