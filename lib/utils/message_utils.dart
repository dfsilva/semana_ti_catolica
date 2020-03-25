

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';

showError(String text){
  BotToast.showText(text: text, contentColor: Colors.red, duration: Duration(seconds: 5), clickClose: true,
      textStyle: TextStyle(color: Colors.white));
}