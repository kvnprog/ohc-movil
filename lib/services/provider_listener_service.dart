import 'package:flutter/material.dart';
import 'package:recorridos_app/data/data.dart';
import 'package:recorridos_app/widgets/timer_counter.dart';

class ProviderListener extends ChangeNotifier{
  //change de color of the place icon 
  Places? _mplaceItem;
  Chronometer chronometer = Chronometer();
  Places? itemIsReady;
  Places? itemCanceledIsReady;

  set placeSelected ( Places placeSelected ){
    _mplaceItem = placeSelected;
  }

  set setBoolValue( Places? mIsReady ){
    itemIsReady= mIsReady;
  }

  
  get placeAffected{
    if (_mplaceItem?.isActive == false) {
        _mplaceItem?.isActive = true;
        notifyListeners();
    }else{
       _mplaceItem?.isActive = false;
        notifyListeners();
    }  
  }
}