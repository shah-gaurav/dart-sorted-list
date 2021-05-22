import 'package:sorted_list/sorted_list.dart';
import 'package:test/test.dart';

void main() {
  test('Sorted List with compare function', () {
    var sortedList = SortedList<int>((a, b) => a.compareTo(b));
    sortedList.add(1);
    sortedList.add(5);
    sortedList.add(3);
    expect(sortedList, equals([1, 3, 5]));
  });

  test('Sorted List with null compare function', () {
    var sortedList = SortedList<int>(null);
    sortedList.add(1);
    sortedList.add(5);
    sortedList.add(3);
    expect(sortedList, equals([1, 3, 5]));
  });

  test('Sorted List with no compare function', () {
    var sortedList = SortedList<int>();
    sortedList.add(1);
    sortedList.add(5);
    sortedList.add(3);
    expect(sortedList, equals([1, 3, 5]));
  });
}
