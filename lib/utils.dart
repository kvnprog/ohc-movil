String formatDuration(Duration value){
    var hours = 0;
    var minutes = 0;
    var seconds = 0;
    var milliseconds = 0;

    if(value.inHours > 0){
      hours = value.inHours;
    }

    minutes = value.inMinutes % 60;
    seconds = value.inSeconds % 60;
    milliseconds = value.inMilliseconds % 1000;

    return "${_zeroFormat(hours)}:${_zeroFormat(minutes)}:${_zeroFormat(seconds)}  ${_zeroFormat2(milliseconds)}";
  }

  String _zeroFormat(int number){
    if(number >= 10){
      return number.toString();
    } else {
      return '0$number';
    }
  }

  String _zeroFormat2(int number){
    if(number >= 99){
      return '$number';
    } else if (number > 9){
      return '0$number';
    }else{
      return '00$number';
    }
  }