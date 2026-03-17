abstract class Data{
  void printData(){
    print("Data one");
  }
}

class Info extends Data{
  @override
  void printData() {
    super.printData();
    print("Info data");
  }
}

void main(){
  var info = Info();
  info.printData();
}