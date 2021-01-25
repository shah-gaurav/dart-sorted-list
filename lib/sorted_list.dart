library sorted_list;

import 'package:collection/collection.dart';

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

  @override
  List<E> operator +(List<E> other) {
    var returnList = (_listBase + (other));
    returnList.sort(_compareFunction);
    return returnList;
  }

  _throwNotSupportedException() {
    throw Exception(
        'Cannot insert element at a specific index in a sorted list.');
  }

  @deprecated
  @override
  void insert(int index, E element) {
    _throwNotSupportedException();
  }

  @deprecated
  @override
  void insertAll(int index, Iterable<E> iterable) {
    _throwNotSupportedException();
  }

  @deprecated
  @override
  void operator []=(int index, E value) {
    _throwNotSupportedException();
  }

  @deprecated
  @override
  void setAll(int index, Iterable<E> iterable) {
    _throwNotSupportedException();
  }

  @deprecated
  @override
  void setRange(int start, int end, Iterable<E> iterable, [int skipCount = 0]) {
    _throwNotSupportedException();
  }
}
