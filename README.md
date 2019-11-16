# Dart Sorted List

A dart sorted list that keeps its elements ordered in the specified sequence.

## Getting Started

SortedList extends DelegatingList so you can use it directly as a replacement for List anywhere in your code where you need to keep items in the list sorted by a particular order.

SortedList sorts the items when they are inserted in the list so the inserts are slower, but the retrieval of items in a sorted order is faster.

SortedList doesn't support inserting items at a particular index. The items should always be inserted where they fall in the sorting order rather than at a particular index.

```dart
import 'package:sorted_list/sorted_list.dart';

main(List<String> args) {
  var sortedList = SortedList<int>((a, b) => a.compareTo(b));
  sortedList.add(1);
  sortedList.add(5);
  sortedList.add(3);
  sortedList.addAll([6, 9, 2]);

  for (var i in sortedList) {
    print(i);
  }
}
```
