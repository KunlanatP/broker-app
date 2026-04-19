import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/core/utils/debounce.dart';

void main() {
  test('runs only last action', () {
    fakeAsync((async) {
      final d = Debounce(milliseconds: 50);
      var hits = 0;
      d.run(() => hits++);
      d.run(() => hits++);
      d.run(() => hits++);
      async.elapse(const Duration(milliseconds: 49));
      expect(hits, 0);
      async.elapse(const Duration(milliseconds: 1));
      expect(hits, 1);
      d.dispose();
    });
  });
}

