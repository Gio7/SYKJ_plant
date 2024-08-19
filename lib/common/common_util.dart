import 'dart:async';

class Common {
  static Function() debounce(Function fn, [int t = 500]) {
    Timer? debounce;
    return () {
      if (debounce?.isActive ?? false) {
        debounce?.cancel();
      } else {
        fn();
      }
      debounce = Timer(Duration(milliseconds: t), () {
        debounce?.cancel();
        debounce = null;
      });
    };
  }
}
