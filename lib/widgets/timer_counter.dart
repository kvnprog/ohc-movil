import 'dart:async';
import 'package:flutter/material.dart';
import 'package:recorridos_app/data/data.dart';
import 'package:recorridos_app/utils.dart';

class TimeCounterClass extends StatefulWidget {
  Places item;

  TimeCounterClass({Key? key, required this.item}) : super(key: key);

  @override
  _TimeCounterClassState createState() => _TimeCounterClassState();
}

class _TimeCounterClassState extends State<TimeCounterClass> {
  late Chronometer chrono = Chronometer();
  late String placeName;

  String hoursStr = '--';
  String minutesStr = '--';
  String secondsStr = '--';

  Stream<int>? timerStream; // = stopWatchStream();
  StreamSubscription? timerSubscription;

  bool itemIsReady = true;
  String? mTimer;

  get getFunctionDisabled {
    //widget.item.time = mTimer;
    return chrono.stop();
  }

  get getFunctionEnabled {
    return chrono.start();
  }

  @override
  void initState() {
    super.initState();

    /* timerStream = stopWatchStream();

      if(widget.item.isActive){ 
        /*  timerStream!.listen((int newTick) {
          setState(() {
            
            hoursStr = ((newTick / (60 * 60)) % 60)
            .floor()
            .toString()
            .padLeft(2, '0');
            minutesStr = ((newTick / 60) % 60)
            .floor()
            .toString()
            .padLeft(2, '0');
            secondsStr = (newTick % 60).floor().toString().padLeft(2, '0');

            print('activado');
          });
        }); */
        chrono.start();
      }

      itemIsReady = false; */
  }

  Stream<int> stopWatchStream() {
    StreamController<int>? streamController;
    Timer? timer;
    Duration timerInterval = Duration(seconds: 1);
    int counter = 0;

    void stopTimer() {
      if (timer != null) {
        timer!.cancel();
        timer = null;
        counter = 0;
        streamController!.close();
      }
    }

    void tick(_) {
      counter++;
      streamController!.add(counter);
    }

    void startTimer() {
      timer = Timer.periodic(timerInterval, tick);
    }

    streamController = StreamController<int>(
      onListen: startTimer,
      onCancel: stopTimer,
      onResume: startTimer,
      onPause: stopTimer,
    );

    return streamController.stream;
  }

  @override
  Widget build(BuildContext context) {
    /*  if(widget.item.isActive == false){
       getFunctionDisabled;
    }
    return Padding(
        padding: const EdgeInsets.only(bottom: 25.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
          Text(
            "$hoursStr:$minutesStr:$secondsStr",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15.0
              ),
            ),
          if(widget.item != null)
            Text(widget.item.name,
                style: const TextStyle(
                color: Colors.white,
                fontSize: 15.0
              ),
          ), 
      ],
    ),
  );   
   */
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          //    widget para mostrar el nombre del lugar
          /*        StreamBuilder(
                    stream: chrono.stateStream,
                    initialData: false,
                    builder: (_, snapshot){

                      if(snapshot.data == true){
                        if(widget.item.isActive == false){
                          getFunctionDisabled;
                        }
                      }else{
                        if (widget.item.isActive) {
                            getFunctionEnabled;
                        } 
                      }
                  
                      return Text(widget.item.name, style: const TextStyle(
                        color: Colors.white,
                        fontSize: 26.0
                      ),);
                    },
                    
                  ),
        */
          //
          //
          //    widget para mostrar el cronometro
          /*  StreamBuilder(
            stream: chrono.chronometerStream,
            initialData: '--:--:--',
            builder: (_, timer){
            mTimer = timer.data.toString();
              return Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: Row(
                  children: [

                  const Icon(
                    Icons.timer,
                    color: Colors.white,
                  ),

                  const SizedBox( width: 3 ),

                  Text(timer.data.toString(),
                    style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15.0,

                  ),)
                  ],
                ),
              );
            },
          ),
 */
        ],
      ),
    );
  }
}

class Chronometer {
  DateTime? date;
  final _mainStreamController = StreamController<String>();
  final _stateStreamController = StreamController<bool>();
  bool _running = false;
  void setCancelVar;

  Stream get chronometerStream {
    return _mainStreamController.stream;
  }

  Stream get stateStream {
    return _stateStreamController.stream;
  }

  bool get running {
    return _running;
  }

  start() {
    date = DateTime.now();
    _running = true;
    //indica que el iniciador ha comenzado
    _stateStreamController.sink.add(true);
    String formatted;

    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!_running) {
        //cancela el timer
        timer.cancel();
        setCancel = timer.cancel();
        return;
      }
      final difference = DateTime.now().difference(date!);
      formatted = formatDuration(difference);
      _mainStreamController.sink.add(formatted);
    });
  }

  stop() {
    _running = false;
    _stateStreamController.sink.add(false);
  }

  set setCancel(void setCancel) {
    setCancelVar = setCancel;
  }

  get getCancel {
    return setCancelVar;
  }
}
