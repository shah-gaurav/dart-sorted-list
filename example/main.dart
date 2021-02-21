import 'package:sorted_list/sorted_list.dart';

void main(List<String> args) {
  var sortedList = SortedList<int>();
  sortedList.add(1);
  sortedList.add(5);
  sortedList.add(3);
  sortedList.addAll([6, 9, 2]);
  // or
  // var sortedList = SortedList.from(elements: [1, 5, 3, 6, 9, 2]);
  for (var i in sortedList) {
    print(i);
  }
}
