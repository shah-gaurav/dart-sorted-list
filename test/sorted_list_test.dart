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

  test('Sorted List from elements', () {
    var sortedList = SortedList.from(elements: [0, 1, 9, 4]);
    expect(sortedList, equals([0, 1, 4, 9]));
  });

  test('Nullable sorted list', () {
    var sortedList = SortedList<int?>.nullable();
    sortedList.addAll([null, 4, 9, 1, 0]);
    expect(sortedList, equals([0, 1, 4, 9, null]));
  });

  test('Sorted List contains element', () {
    var sortedList = SortedList.from(elements: [1, 0, 2, 5]);
    expect(sortedList.contains(0), equals(true));
    expect(sortedList.contains(1), equals(true));
    expect(sortedList.contains(2), equals(true));
    expect(sortedList.contains(5), equals(true));
    expect(sortedList.contains(6), equals(false));
  });

  test('Sorted List contains null', () {
    var sortedList = SortedList.nullable(elements: [null, 0, null, 10, 2]);
    expect(sortedList.contains(null), equals(true));
    expect(sortedList.contains(0), equals(true));
    expect(sortedList.contains(1), equals(false));
  });

  test('Sorted List contains object of different type', () {
    var sortedList = SortedList.nullable(elements: [null, 0, null, 10, 2]);
    expect(sortedList.contains("foo"), equals(false));
    expect(sortedList.contains(1.2), equals(false));
  });

  test("Index of repeated item", () {
    var sortedList = SortedList.from(elements: [4, 2, 2, 2, 0]);
    expect(sortedList.indexOf(2), equals(1));
  });

  test('Last index of repeated item', () {
    var sortedList = SortedList.from(elements: [4, 2, 2, 2, 0]);
    expect(sortedList.lastIndexOf(2), equals(3));
  });

  test('Sorted List concatenation', () {
    var sortedList = SortedList.from(elements: [2, 1, 0, 5]);
    var list = [9, 6, 11];
    expect(sortedList + list, equals([0, 1, 2, 5, 6, 9, 11]));
  });
}
