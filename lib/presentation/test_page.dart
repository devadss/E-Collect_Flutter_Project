abstract class Data{
var name = "";
  void printData() => print("Data one");
  int calc(int a , int b) => a+b;

}



class Info extends Data{

  @override
  void printData() {
    super.printData();
    print("Info data");
  }

  @override
  int calc(int a, int b) {
    return super.calc(a, b);
  }
}

void main() {
  var info = Info();
  info.printData();
  var x = info.calc(2, 4);
  print(x);

}