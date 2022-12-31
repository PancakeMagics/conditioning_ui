/// iterable extension
extension IterableExtension<I> on Iterable<I> {
  bool notContains(I element) => !contains(element);

  T foldWith<T, O>(
    T initialValue,
    List<O> another,
    T Function(T current, I element, O elementAnother) foldIterable,
  ) {
    assert(length == another.length, 'invalid length');
    return foldWithIndex(
      initialValue,
      (previousValue, element, index) => foldIterable(
        previousValue,
        element,
        another[index],
      ),
    );
  }

  T foldWithIndex<T>(
    T initialValue,
    T Function(T current, I element, int index) foldIterable,
  ) {
    int index = -1;
    return fold(
      initialValue,
      (previousValue, element) => foldIterable(previousValue, element, ++index),
    );
  }

  Iterable<T> flat<T>({
    bool isNested = false,
  }) =>
      fold<List<T>>(
          [],
          (list, element) => (element is Iterable<T>)
              ? (list..addAll(element))
              : (element is T)
                  ? (list..add(element))
                  : (throw UnimplementedError()));

  Iterable<Iterable<I>> chunk(Iterable<int> lengthOfEachChunk) {
    assert(lengthOfEachChunk.reduce((a, b) => a + b) == length);
    final list = toList(growable: false);
    final splitList = <List<I>>[];

    int start = 0;
    int end;
    for (var i in lengthOfEachChunk) {
      end = i + start;
      splitList.add(list.getRange(start, end).toList(growable: false));
      start = end;
    }
    return splitList;
  }
}

extension ListSetExtension<I> on List<Set<I>> {
  void forEachAddAll(List<Set<I>>? another) {
    if (another != null) {
      for (var i = 0; i < length; i++) {
        this[i].addAll(another[i]);
      }
    }
  }
}

/// iterable iterable extension
extension IterableIterableExtension<E> on Iterable<Iterable<E>> {
  Iterable<int> get lengths => map((e) => e.length);
}

/// iterable entry extension
extension MapEntryExtension<K, V> on Iterable<MapEntry<K, V>> {
  Map<K, V> get toMap => Map.fromEntries(this);
}

/// map extension
extension MapExtension<K, V> on Map<K, V> {
  T fold<T>(
    T initialValue,
    T Function(T current, MapEntry<K, V> entry) foldMap,
  ) =>
      entries.fold<T>(
        initialValue,
        (previousValue, element) => foldMap(previousValue, element),
      );

  T foldWithIndex<T>(
    T initialValue,
    T Function(T current, MapEntry<K, V> entry, int entryIndex) foldMap,
  ) {
    int index = -1;
    return entries.fold<T>(
      initialValue,
      (previousValue, element) => foldMap(previousValue, element, ++index),
    );
  }

  void replaceAll(Iterable<K>? keys, V Function(V value) value) {
    if (keys != null) {
      for (var k in keys) {
        update(k, value);
      }
    }
  }

  bool notContainsKey(K key) => !containsKey(key);

  bool containsKeys(Iterable<K> keys) {
    for (var key in keys) {
      if (notContainsKey(key)) {
        return false;
      }
    }
    return true;
  }
}

/// double extension
extension DoubleExtension on double {
  bool get isNearlyInt => (ceil() - this) <= 0.01;
}

/// int extension
extension IntExtension on int {
  int get factorial {
    assert(!isNegative && this != 0, 'invalid factorial integer: $this');
    int accelerator = 1;
    for (var i = 1; i <= this; i++) {
      accelerator *= i;
    }
    return accelerator;
  }
}
