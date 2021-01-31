# Dart Sorted List

A dart sorted list that keeps its elements ordered according to its `compare` function.

## Getting Started

SortedList extends DelegatingList so you can use it directly as a replacement for List anywhere in your code where you need to keep items in the list sorted by a particular order.

SortedList uses binary search to insert the items on the correct positions in the list so the inserts may be a bit slower, but the difference should'nt be noticeable.

SortedList doesn't support inserting items at a particular index. The items should always be inserted where they fall in the sorting order rather than at a particular index.

```dart
import 'package:sorted_list/sorted_list.dart';

void main(List<String> args) {
  var sortedList = SortedList<int>();
  sortedList.add(1);
  sortedList.add(5);
  sortedList.add(3);
  sortedList.addAll([6, 9, 2]);

  for (var i in sortedList) {
    print(i);
  }
}
```
