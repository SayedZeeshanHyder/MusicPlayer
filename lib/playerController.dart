import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';

class PlayerController extends GetxController{
  RxBool lighttheme = true.obs;
  RxInt playingindex = (-1).obs;
  RxBool isplaying = false.obs;
  var duration = ''.obs;
  var postion = ''.obs;
  var max=0.0.obs;
  var value=0.0.obs;

  updatePostion(){
    audioplayer.durationStream.listen((d) {
      duration.value=d.toString().split('.')[0];
      max.value=d!.inSeconds.toDouble();
    });

    audioplayer.positionStream.listen((p) {
      postion.value=p.toString().split('.')[0];
      value.value=p!.inSeconds.toDouble();
    });
  }

  sliderChangeValue(seconds){
    var duration=Duration(seconds: seconds);
    audioplayer.seek(duration);
  }

  changetheme(){
    lighttheme.value=!lighttheme.value;
  }

  final audioQuery = OnAudioQuery();
  final audioplayer = AudioPlayer();

  @override
  void onInit() {
    super.onInit();
    checkpermission();
  }

  playSong(String? uri,int index) async {
    playingindex.value=index;
    try{
      audioplayer.setAudioSource(AudioSource.uri(Uri.parse(uri.toString())));
      audioplayer.play();
      isplaying(true);
      updatePostion();
    }
    catch(e){
      Get.snackbar("Something Went Wrong", "An error Occured While PLaying the Song");
    }
  }

  checkpermission()async{

    var permission = await Permission.storage.request();
    if(permission.isGranted){
      print('Permission Granted');
    }
    else{
      checkpermission();
    }
  }
}