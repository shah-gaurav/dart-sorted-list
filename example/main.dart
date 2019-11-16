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
