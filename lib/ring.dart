import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';


class Ring extends StatefulWidget {
  Ring({Key key}) :super(key: key);

  @override
  _RingState createState() => _RingState();
}


class _RingState extends State<Ring>{


  @override
  initState(){
    super.initState();
    FlutterRingtonePlayer.play(asAlarm: true, android: AndroidSounds.alarm, ios: IosSounds.alarm,looping: true);
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ringtone player'),
      ),
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[Container(
          height: 300,
          width: 300,
          child: ElevatedButton(
            onPressed: () {FlutterRingtonePlayer.stop();},
            child: Icon(Icons.directions_walk, size: 100,),
            style: ButtonStyle(
              shape: MaterialStateProperty.all(CircleBorder()),
              padding: MaterialStateProperty.all(EdgeInsets.all(20)),
              backgroundColor: MaterialStateProperty.all(Colors.blue), // <-- Button color
               // <-- Splash color
            ),
          ),
        ),
          Container(child: Text('Please Walk!', style:TextStyle(fontSize: 60)),),
       ])
      ),
    );
  }
}