import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_player/playerController.dart';
import 'package:music_player/songpage.dart';
import 'package:on_audio_query/on_audio_query.dart';

class Home extends StatefulWidget{

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final controller = Get.put(PlayerController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Songs"),
        leading: Icon(Icons.sort),
        actions: [
          Obx(
          ()=>IconButton(icon :Icon(controller.lighttheme.value ? Icons.light_mode : Icons.dark_mode),onPressed: (){
            controller.changetheme();
              controller.lighttheme.value ? Get.changeTheme(ThemeData.light(useMaterial3: true)):Get.changeTheme(ThemeData.dark(useMaterial3: true));
            },),
          ),
        ],
      ),
      body: FutureBuilder<List<SongModel>>(
        future: controller.audioQuery.querySongs(
          sortType: null,
          orderType: OrderType.ASC_OR_SMALLER,
          ignoreCase: true,
          uriType: UriType.EXTERNAL,
        ),
        builder: (context,snapshot){
          if(snapshot.data==null){
            return Center(child: CircularProgressIndicator());
          }
          else if(snapshot.data!.isEmpty){
            return Center(child: Text("No Song Found"));
          }
          else {
            return ListView.builder(itemCount: snapshot.data!.length,
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  return Obx(
                    ()=> ListTile(
                      tileColor: controller.playingindex.value==index?Colors.grey:null,
                      onTap: (){
                        Get.to(SongPage(datalist: snapshot.data,songindex: index),transition: Transition.downToUp);
                        if(controller.playingindex.value!=index){controller.playSong(snapshot.data![index].uri,index);}
                      },
                      title: Text(snapshot.data![index].displayNameWOExt,style: TextStyle(fontWeight: FontWeight.bold),maxLines: 1,overflow: TextOverflow.ellipsis,),
                      leading: QueryArtworkWidget(id: snapshot.data![index].id, type: ArtworkType.AUDIO,nullArtworkWidget: Icon(Icons.music_note),),
                      subtitle: Text(snapshot.data![index].artist.toString(),maxLines: 1,overflow: TextOverflow.ellipsis,),
                    ),
                  );
                });
          }
        },
      ),
    );
  }
}


