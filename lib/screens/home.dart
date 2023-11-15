import 'package:flutter/material.dart';
import '../components/formProduct.dart';
class HomeScreen extends StatelessWidget {
  late String title;
  HomeScreen({super.key, this.title = ''});

  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        titleTextStyle: Theme.of(context).textTheme.headlineMedium, 
        backgroundColor: Colors.red,
      ),
      body: FormManager(),
    );
  }
}