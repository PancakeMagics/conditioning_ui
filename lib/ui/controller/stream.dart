part of controller;

///
///
/// this file contains:
/// - [CustomStreamController]
///
///



/// custom stream controller
class CustomStreamController<T> {
  CustomStreamController._() : controller = StreamController<T>();

  StreamController<T> controller;

  void add(T element) => controller.add(element);

  void close() => controller.close();

  Stream<T> get stream => controller.stream;
}
