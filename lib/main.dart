import 'package:flutter/material.dart';
import 'package:resqnet/sospage.dart';

void main() async {
  runApp(const ResQNet());
}

class ResQNet extends StatelessWidget{
  const ResQNet({super.key});
  @override
  Widget build(BuildContext context){
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(useMaterial3: true),
      home: const SOSPage(),
    );
  }
}


