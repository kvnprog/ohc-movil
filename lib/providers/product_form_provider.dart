import 'package:flutter/material.dart';
import 'package:recorridos_app/models/product.dart';

class ProductFormProvider extends ChangeNotifier{

  GlobalKey<FormState> formkey = GlobalKey();

  Product product;

  ProductFormProvider(this.product);

  updateAvailability(bool value){
    product.available = value;
    notifyListeners();
  }


  bool isValidForm(){
    
    print(product.name);
    print(product.id);
    print(product.price);


    return formkey.currentState?.validate() ?? false;
  }

}