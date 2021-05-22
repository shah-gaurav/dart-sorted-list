library sorted_list;

import 'package:collection/collection.dart';

class SortedList<E> extends DelegatingList<E> {
  int Function(E a, E b)? _compareFunction;

  List<E> get _listBase => super.toList();

  SortedList([int Function(E a, E b)? compareFunction]) : super(<E>[]) {
    this._compareFunction = compareFunction;
  }

  @override
  void add(E value) {
    super.add(value);
    sort(_compareFunction);
  }

  @override
  void addAll(Iterable<E> iterable) {
    super.addAll(iterable);
    sort(_compareFunction);
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
