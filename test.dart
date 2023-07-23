void main() {
  List number = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
  List newList = [];
  for (int i = number.length - 1; i >= 0; i--) {
    if (newList.length > 4) {
      break;
    }
    newList.add(number[i]);
  }
  List reversedNumbers = newList.reversed.toList();
  print(reversedNumbers);
}
