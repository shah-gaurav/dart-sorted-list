library sorted_list;

import 'package:collection/collection.dart';
import 'package:sorted_list/exceptions.dart';

class SortedList<E> extends DelegatingList<E> {
  int Function(E a, E b) _compareFunction;

  List<E> get _listBase => super.toList();

  SortedList(int Function(E a, E b) compareFunction) : super(<E>[]) {
    this._compareFunction = compareFunction;
  }

  /// Finds the index where [value] should be inserted
  int _findInsertionIndex(E value) {
    if (length == 0) return 0;
    var start = 0;
    var end = length;
    var index = 0;
    while (start < end) {
      final mid = start + ((end - start) >> 1);

      // The element at the middle of the list
      final element = this[mid];

      // The result of the comparison of the objects
      final comp = _compareFunction(element, value);
      if (comp == 0) return mid;
      // [value] is greater than [element]
      if (comp < 0) {
        start = mid + 1;
        index = start;
      }
      // [value] is smaller than [element]
      else {
        end = mid;
        index = end;
      }
    }
    return index;
  }

  @override
  void add(E value) {
    final index = _findInsertionIndex(value);
    super.insert(index, value);
  }

  @override
  void addAll(Iterable<E> iterable) {
    for (final value in iterable) add(value);
  }

  @override
  bool contains(Object element) {
    if (element is E) {
      return binarySearch(this, element, compare: _compareFunction) > 0;
    } else {
      return super.contains(element);
    }
  }

  int indexOf(E element, [int start = 0]) {
    final sortedList = start == 0 ? this : getRange(start, length).toList();
    return binarySearch(sortedList, element, compare: _compareFunction);
  }

  int lastIndexOf(E element, [int start]) {
    // Add one to [start] to make the value at its index included in the search
    final rangeEnd = start == null || start + 1 >= length ? length : start + 1;
    final sortedList = start == null ? this : getRange(0, rangeEnd).toList();
    final firstIndex =
        binarySearch(sortedList, element, compare: _compareFunction);
    if (firstIndex == length - 1 || firstIndex == -1) return firstIndex;
    int index;
    E current, next;
    // If the element occurs more than once, this loop will find
    // its last index
    for (index = firstIndex; index < rangeEnd - 1; index++) {
      current = this[index];
      next = this[index + 1];
      if (_compareFunction(current, next) != 0) break;
    }
    return index;
  }

  @override
  List<E> operator +(List<E> other) {
    var returnList = (_listBase + (other));
    returnList.sort(_compareFunction);
    return returnList;
  }

  @deprecated
  @override
  void insert(int index, E element) {
    throw NotSupportedException(
        'Cannot insert element at a specific position in a sorted list');
  }

  @deprecated
  @override
  void insertAll(int index, Iterable<E> iterable) {
    throw NotSupportedException(
        'Cannot insert multiple elements at a specific position in a sorted list');
  }

  @deprecated
  @override
  void operator []=(int index, E value) {
    throw NotSupportedException(
        'Cannot modify element at a specific position in a sorted list');
  }

  @deprecated
  @override
  void setAll(int index, Iterable<E> iterable) {
    throw NotSupportedException(
        'Cannot modify multiple elements at a specific position in a sorted list');
  }

  @deprecated
  @override
  void setRange(int start, int end, Iterable<E> iterable, [int skipCount = 0]) {
    throw NotSupportedException(
        'Cannot modify multiple elements at a specific position in a sorted list');
  }

  @deprecated
  @override
  void fillRange(int start, int end, [E fillValue]) {
    throw NotSupportedException(
        'Cannot modify multiple elements at a specific position in a sorted list');
  }
}
