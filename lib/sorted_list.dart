library sorted_list;

import 'dart:math';

import 'package:collection/collection.dart';
import 'package:sorted_list/exceptions.dart';

class SortedList<E> extends DelegatingList<E> {
  final int Function(E a, E b) _compareFunction;

  SortedList(int Function(E a, E b) compareFunction)
      : _compareFunction = compareFunction,
        super(<E>[]);

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
    final list = iterable.toList();
    list.sort(_compareFunction);
    var index = 0;
    if (length > 0) {
      // merge the two sorted lists with merge sort logic
      for (var i = 0; i < length; i++) {
        final comp = _compareFunction(this[i], list[index]);
        if (comp >= 0) {
          super.insert(i, list[index]);
          index++;
        }
      }
    } else {
      super.addAll(iterable);
    }
  }

  @override
  bool contains(Object element) {
    if (element is E) {
      return binarySearch(this, element, compare: _compareFunction) > 0;
    } else {
      return super.contains(element);
    }
  }

  // TODO: use a custom binary search to increase speed in edge cases
  @override
  int indexOf(E element, [int start = 0]) {
    final rangeStart = start >= length ? length - 1 : start;
    final sortedList =
        start == 0 ? this : getRange(rangeStart, length).toList();
    var index = binarySearch(sortedList, element, compare: _compareFunction);
    if (index < 0) return -1;
    // If the element occurs more than once, this loop will find
    // its first index
    E current = this[index], previous;
    for (; index > start; index--) {
      previous = current;
      current = this[index];
      if (_compareFunction(current, previous) != 0) break;
    }
    return index;
  }

  // TODO: use a custom binary search to increase speed in edge cases
  @override
  int lastIndexOf(E element, [int start]) {
    // Add one to [start] to make the value at its index included in the search
    final rangeEnd = start == null || start + 1 >= length ? length : start + 1;
    final sortedList = start == null ? this : getRange(0, rangeEnd).toList();
    var index = binarySearch(sortedList, element, compare: _compareFunction);
    if (index == length - 1 || index == -1) return index;
    E current, next = this[index];
    // If the element occurs more than once, this loop will find
    // its last index
    for (; index < rangeEnd - 1; index++) {
      current = next;
      next = this[index];
      if (_compareFunction(current, next) != 0) break;
    }
    return index;
  }

  @override
  List<E> operator +(List<E> other) {
    final returnList = super + other;
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
    super.sort(_compareFunction);
  }

  @Deprecated(
      'This method is not supported since it does not allow the list to stay ordered, consider using the removeRange method with the AddAll method.')
  @override
  void replaceRange(int start, int end, Iterable<E> iterable) {
    throw NotSupportedException(
        'Cannot modify multiple elements at a specific position in a sorted list.');
  }

  @Deprecated(
      'This method is not supported since it does not allow the list to stay ordered.')
  @override
  void shuffle([Random random]) {
    throw NotSupportedException('Cannot shuffle elements in a sorted list.');
  }
}
