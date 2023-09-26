import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_player/playerController.dart';
import 'package:on_audio_query/on_audio_query.dart';

class SongPage extends StatefulWidget{

  final List<SongModel>? datalist;
  final songindex;
  SongPage({required this.datalist,this.songindex}){}

  @override
  State<SongPage> createState() => _SongPageState();
}

class _SongPageState extends State<SongPage> {
  final controller = Get.put(PlayerController());
  @override
  Widget build(BuildContext context) {
    final data=widget.datalist![controller.playingindex.value];
    return Scaffold(
      appBar: AppBar(
        title: Text(data.displayNameWOExt),
      ),
      body: Column(
        children : [
          SizedBox(height: 20,),
          Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Container(
                width: double.infinity,
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                  color: Colors.black,
                  shape: BoxShape.circle
                ),
                child: QueryArtworkWidget(id: data.id, type: ArtworkType.AUDIO,nullArtworkWidget: Icon(Icons.music_note),),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20))
              ),
              child: Padding(
                padding: const EdgeInsets.all(13.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(data.displayNameWOExt,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25,overflow: TextOverflow.ellipsis),),
                    Text(data.artist.toString()),
                    Obx(
                      ()=> Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(controller.postion.value),
                          Expanded(
                            child: Slider(
                              value: controller.value.value,
                              min: Duration(seconds: 0).inSeconds.toDouble(),
                              max: controller.max.value,
                              onChanged: (value) {
                                controller.sliderChangeValue(value.toInt());
                                value=value;
                                if(value==controller.max.value){
                                  controller.playSong(data.uri, controller.playingindex.value);
                                }
                              },
                            ),
                          ),
                          Text(controller.duration.value),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(icon: Icon(Icons.skip_previous,size: 35,),onPressed: (){
                          setState(() {});
                          controller.playSong(widget.datalist![controller.playingindex.value-1].uri, controller.playingindex.value-1);
                        },),
                        Obx(
                          ()=> IconButton(icon: controller.isplaying.value ? Icon(Icons.pause,size: 35,):Icon(Icons.play_arrow,size: 35,),onPressed: (){
                            if(controller.isplaying.value){
                              controller.audioplayer.pause();
                              controller.isplaying.value=false;
                            }
                            else{
                              controller.audioplayer.play();
                              controller.isplaying.value=true;
                            }
                          },),
                        ),
                        IconButton(icon: Icon(Icons.skip_next,size: 35,),onPressed: (){
                          setState(() {});
                          controller.playSong(widget.datalist![controller.playingindex.value+1].uri, controller.playingindex.value+1);
                        },),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ]
      ),
    );
  }
}