import 'package:custom_progress_dialog/custom_progress_dialog.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Progress Dialog Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  ProgressDialog _progressDialog = ProgressDialog(); 

  @override
  Widget build(BuildContext context) {
   
    return Scaffold(
      appBar: AppBar(
        title: Text("Progress Dialog Demo"),
      ),
      body: Center(
        
        child: Wrap(
          alignment: WrapAlignment.center,
          spacing: 10,
          children: <Widget>[
            RaisedButton(
              onPressed: (){
                  _progressDialog.showProgressDialog(context,textToBeDisplayed: 'loading...',dismissAfter: Duration(seconds: 4));
              },
              child: Text('Show Progress'),
            ),
          
          ],
        ),
      ), 
    );
  }
}
