import 'dart:io';

Future<bool> checkInternetConnection()async{
  try{
    final result = await InternetAddress.lookup('google.com');
    if(result.isEmpty && result[0].rawAddress.isNotEmpty){
      return true;
    }else{
      return false;
    }
  }on SocketException catch(_){
    return false;
  }
}
void printLog(msg){

    print(msg);

}
Future<void> launchUrl(String url)async{
  final Uri uri = Uri.parse(url);
  await launchUrl(uri.toString());
}