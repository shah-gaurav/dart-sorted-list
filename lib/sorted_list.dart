library sorted_list;

import 'dart:math';

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
    final rangeStart = start >= length ? length - 1 : start;
    final sortedList =
        start == 0 ? this : getRange(rangeStart, length).toList();
    var index = binarySearch(sortedList, element, compare: _compareFunction);
    if (index < 0) return -1;
    // If the element occurs more than once, this loop will find
    // its first index
    E current, previous;
    for (; index > start + 1; index--) {
      current = this[index];
      previous = this[index - 1];
      if (_compareFunction(current, previous) != 0) break;
    }
    return index;
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

  @Deprecated(
      'This method is not supported since it does not allow the list to stay ordered, consider using the Add method.')
  @override
  void insert(int index, E element) {
    throw NotSupportedException(
        'Cannot insert element at a specific position in a sorted list.');
  }

  @Deprecated(
      'This method is not supported since it does not allow the list to stay ordered, consider using the AddAll method.')
  @override
  void insertAll(int index, Iterable<E> iterable) {
    throw NotSupportedException(
        'Cannot insert multiple elements at a specific position in a sorted list.');
  }

  @Deprecated(
      'This method is not supported since it does not allow the list to stay ordered, consider using the Add method.')
  @override
  void operator []=(int index, E value) {
    throw NotSupportedException(
        'Cannot modify element at a specific position in a sorted list.');
  }

  @Deprecated(
      'This method is not supported since it does not allow the list to stay ordered, consider using the AddAll method.')
  @override
  void setAll(int index, Iterable<E> iterable) {
    throw NotSupportedException(
        'Cannot modify multiple elements at a specific position in a sorted list.');
  }

  @Deprecated(
      'This method is not supported since it does not allow the list to stay ordered, consider using the AddAll method.')
  @override
  void setRange(int start, int end, Iterable<E> iterable, [int skipCount = 0]) {
    throw NotSupportedException(
        'Cannot modify multiple elements at a specific position in a sorted list.');
  }

  @Deprecated(
      'This method is not supported since it does not allow the list to stay ordered, consider using the AddAll method.')
  @override
  void fillRange(int start, int end, [E fillValue]) {
    throw NotSupportedException(
        'Cannot modify multiple elements at a specific position in a sorted list.');
  }

  @Deprecated(
      'This method is not necessary, the list already auto sorts itself. The `compare` parameter will not be used if this method is called, instead will be used the `compareFunction`, which was passed to the constructor as a parameter.')
  @override
  void sort([int compare(E a, E b)]) {
    _listBase.sort(_compareFunction);
  }

  @Deprecated(
      'This method is not supported since it does not allow the list to stay ordered, consider using the removeRange method with the AddAll method.')
  @override
  void replaceRange(int start, int end, Iterable<E> iterable) {
    _listBase.replaceRange(start, end, iterable);
  }
}
