import 'dart:async';

class EventBus {
  // 单例模式
  EventBus._privateConstructor();
  static final EventBus _instance = EventBus._privateConstructor();
  factory EventBus() => _instance;

  // 内部使用 StreamController，设置为广播模式
  final _controller = StreamController<dynamic>.broadcast();

  // 获取 Stream
  Stream<T> on<T>() {
    return _controller.stream.where((event) => event is T).cast<T>();
  }

  // 发送事件
  void fire(event) {
    _controller.add(event);
  }

  // 关闭控制器（通常不需要，应用生命周期内保持开启）
  void dispose() {
    _controller.close();
  }
}
