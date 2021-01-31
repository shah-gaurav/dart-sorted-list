library sorted_list;

import 'dart:math';

import 'package:collection/collection.dart';

/// A list capable of keeping itself sorted according to its compare function
///
///
class SortedList<E> extends DelegatingList<E> {
  final Comparator<E> _compare;

  /// Creates a list that keeps itself sorted.
  ///
  /// [compare] is used to determine the sort order of the elements.
  /// The [Comparable.compare] function is used by default.
  SortedList([Comparator<E> compare])
      : _compare = compare ?? Comparable.compare,
        super(<E>[]);

  /// Creates a [SortedList] that contains all the elements of [elements]
  ///
  /// [compare] is used to determine the sort order of the elements, if [null], [Comparable.compare] is used
  factory SortedList.from({
    Iterable<E> elements,
    Comparator<E> compare,
  }) =>
      SortedList(compare)..addAll(elements);

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
      final comp = _compare(element, value);
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

  /// Adds [value] to the list, extending the length by one.
  ///
  ///     SortedList<int> values = SortedList<int>();
  ///     values.add(6);
  ///     values.add(2);
  ///     values.add(10);
  ///     print(values); // [2, 6, 10]
  ///
  /// If you want to insert a large amount of items, consider using [addAll]:
  ///
  ///     Sorted<int> values = SortedList<int>();
  ///     values.addAll(myVeryLongList);
  ///
  @override
  void add(E value) {
    final index = _findInsertionIndex(value);
    super.insert(index, value);
  }

  /// Adds all objects of [iterable] to this list.
  ///
  /// Extends the length of the list by the number of objects in [iterable].
  ///
  /// Its more efficient than calling [add] multiple times for large amounts of items.
  @override
  void addAll(Iterable<E> iterable) {
    final list = iterable.toList();
    list.sort(_compare);
    var index = 0;
    if (length > 0) {
      // merge the two sorted lists with merge sort logic
      for (var i = 0; i < length && index < list.length; i++) {
        final comp = _compare(this[i], list[index]);
        if (comp >= 0) {
          super.insert(i, list[index]);
          index++;
        }
      }
    } else {
      super.addAll(list);
    }
  }

  /// Returns true if this list contains an element equal to [element]
  ///
  /// This operation will make a binary search to check if [element] is in this list.
  ///
  /// The equality used to determine whether [element] is equal to an element of
  /// the iterable is defined by the [compare] function of this list
  @override
  bool contains(Object element) {
    if (element is E) {
      return binarySearch(this, element, compare: _compare) > 0;
    } else {
      return super.contains(element);
    }
  }

  /// Returns the first index of [element] in this list.
  ///
  /// Searches the list from index [start] to the end of the list.
  /// The first time an object [:o:] is encountered so that [compare(o, element) == 0],
  /// the index of [:o:] is returned.
  ///
  ///     SortedList<String> values = SortedList<String>((a, b) => a.compareTo(b));
  ///     values.addAll(['foo', 'bar', 'baz', 'foo', 'bar']);
  ///     print(values); // [bar, bar, baz, foo, foo]
  ///     print(values.indexOf('foo')); // 3
  ///     print(values.indexOf('foo', 4)); // 4
  ///
  /// Returns -1 if [element] is not found.
  ///
  ///     values.indexOf('something');    // -1
  ///
  @override
  int indexOf(E element, [int start = 0]) {
    final rangeStart = start >= length ? length - 1 : start;
    var min = rangeStart;
    var max = length;
    // optimization for best case scenario
    if (_compare(this[min], element) == 0) return min;
    var found = false;
    // Custom implementation of binary search to find the first index of an element
    while (min < max) {
      final mid = min + ((max - min) >> 1);
      final comp = _compare(this[mid], element);
      found = found || comp == 0;
      if (comp < 0) {
        min = mid + 1;
      } else {
        max = mid;
      }
    }
    return found ? min : -1;
  }

  /// Returns the last index of [element] in this list.
  ///
  /// Searches the list from index 0 to [end].
  ///
  /// The first time an object [:o:] is encountered so that [:compare(:o:, element):],
  /// the index of [:o:] is returned.
  ///     SortedList<String> values = SortedList<String>();
  ///     values.addAll(['foo', 'bar', 'baz', 'foo', 'bar']);
  ///     print(values.lastIndexOf('bar)); // 1
  ///
  /// If [end] is not provided, this method searches from the end of the
  /// list.
  ///
  ///     print(notes.lastIndexOf('baz'));  // 4
  ///
  /// Returns -1 if [element] is not found.
  ///
  ///     notes.lastIndexOf('something');  // -1

  @override
  int lastIndexOf(E element, [int end]) {
    final rangeEnd = end == null || end > length ? length : end;
    var min = 0;
    var max = rangeEnd;
    // optimization for best case scenario
    if (max < length && _compare(this[max], element) == 0) return max;
    var found = false;
    // Custom implementation of binary search to find the last index of an element
    while (min < max) {
      final mid = min + ((max - min) >> 1);
      final comp = _compare(this[mid], element);
      found = found || comp == 0;
      if (comp > 0) {
        max = mid;
      } else {
        min = mid + 1;
      }
    }
    return found ? max - 1 : -1;
  }

  /// Returns the concatenation of this list and [other].
  ///
  /// Returns a new list containing the elements of this list with
  /// the elements of [other], all sorted.
  @override
  List<E> operator +(List<E> other) {
    final returnList = super + other;
    returnList.sort(_compare);
    return returnList;
  }

  @Deprecated(
      'This method is not supported since it does not allow the list to stay ordered, consider using the Add method.')
  @override
  void insert(int index, E element) {
    throw UnsupportedError(
        'Cannot insert element at a specific position in a sorted list.');
  }

  @Deprecated(
      'This method is not supported since it does not allow the list to stay ordered, consider using the AddAll method.')
  @override
  void insertAll(int index, Iterable<E> iterable) {
    throw UnsupportedError(
        'Cannot insert multiple elements at a specific position in a sorted list.');
  }

  @Deprecated(
      'This method is not supported since it does not allow the list to stay ordered, consider using the Add method.')
  @override
  void operator []=(int index, E value) {
    throw UnsupportedError(
        'Cannot modify element at a specific position in a sorted list.');
  }

  @Deprecated(
      'This method is not supported since it does not allow the list to stay ordered, consider using the AddAll method.')
  @override
  void setAll(int index, Iterable<E> iterable) {
    throw UnsupportedError(
        'Cannot modify multiple elements at a specific position in a sorted list.');
  }

  @Deprecated(
      'This method is not supported since it does not allow the list to stay ordered, consider using the AddAll method.')
  @override
  void setRange(int start, int end, Iterable<E> iterable, [int skipCount = 0]) {
    throw UnsupportedError(
        'Cannot modify multiple elements at a specific position in a sorted list.');
  }

  @Deprecated(
      'This method is not supported since it does not allow the list to stay ordered, consider using the AddAll method.')
  @override
  void fillRange(int start, int end, [E fillValue]) {
    throw UnsupportedError(
        'Cannot modify multiple elements at a specific position in a sorted list.');
  }

  @Deprecated(
      'This method is not necessary, the list already auto sorts itself. The `compare` parameter will not be used if this method is called, instead will be used the `compareFunction`, which was passed to the constructor as a parameter.')
  @override
  void sort([int compare(E a, E b)]) {
    super.sort(_compare);
  }

  @Deprecated(
      'This method is not supported since it does not allow the list to stay ordered, consider using the removeRange method with the AddAll method.')
  @override
  void replaceRange(int start, int end, Iterable<E> iterable) {
    throw UnsupportedError(
        'Cannot modify multiple elements at a specific position in a sorted list.');
  }

  @Deprecated(
      'This method is not supported since it does not allow the list to stay ordered.')
  @override
  void shuffle([Random random]) {
    throw UnsupportedError('Cannot shuffle elements in a sorted list.');
  }
}
