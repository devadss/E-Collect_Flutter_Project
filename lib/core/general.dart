import 'dart:io';

checkInternetConnection()async{
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
printLog(msg){

    print(msg);

}
launchUrl(String url)async{
  final Uri uri = Uri.parse(url);
  await launchUrl(uri.toString());
}