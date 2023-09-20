# Dart Sorted List

A dart sorted list that keeps its elements ordered according to its `compare` function.

## Getting Started

SortedList extends DelegatingList so you can use it directly as a replacement for List anywhere in your code where you need to keep items in the list sorted by a particular order.

SortedList inserts the items in their sorted positions when they are inserted in the list so the inserts are slower, but the retrieval of items in a sorted order is faster.

SortedList doesn't support inserting items at a particular index. The items should always be inserted where they fall in the sorting order rather than at a particular index.

```dart
import 'package:sorted_list/sorted_list.dart';

void main(List<String> args) {
  var sortedList = SortedList<int>.from(elements: [1, 5, 3, 6, 9, 2]);

  for (var i in sortedList) {
    print(i);
  }
}
```
