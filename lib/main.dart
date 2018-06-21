import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
// import 'package:convert/convert.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart' as crypto;

var url = 'https://api.pwnedpasswords.com/range/';

void main() => runApp(new MyApp());

generateMd5(String data) {
  var content = new Utf8Encoder().convert(data);
  return crypto.sha1.convert(content);
}

// Define a Custom Form Widget
class MyForm extends StatefulWidget {
  @override
  MyFormState createState() {
    return MyFormState();
  }
}

// Define a corresponding State class. This class will hold the data related to
// the form.
class MyFormState extends State<MyForm> {
  // Create a global key that will uniquely identify the Form widget and allow
  // us to validate the form
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final myController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey we created above
    return Form(
        key: _formKey,
        child: new Column(
          children: <Widget>[
            /*
            new TextFormField(
                validator: (value) {
                  if(value.isEmpty) {
                    return 'Username non valido';
                  }
                },
                controller: myController,
                decoration: InputDecoration(
                    labelText: 'Enter your username'
                )
            ),
            */
            new TextFormField(
                obscureText: true,
                validator: (value) {
                  if(value.isEmpty) {
                    return 'Invalid password';
                  }
                  if(value.length < 5) {
                    return 'Must contain at least 5 chars';
                  }
                },
                decoration: InputDecoration(
                  labelText: 'Enter your password',
                )
            ),
            new RaisedButton(
                child: Text('Submit'),
                onPressed: (){
                  print('key pressed');
                  if (_formKey.currentState.validate()) {
                   var incipit = generateMd5(myController.text).toString().substring(0, 5);
                   http.get(url + incipit).then((http.Response response) {
                      print(response.body);
                      var jsonData = 
                      Scaffold
                          .of(context)
                          .showSnackBar(SnackBar(content: Text(response.body)));
                   });
                   Scaffold
                       .of(context)
                       .showSnackBar(SnackBar(content: Text('Processing Data')));
                  }
                })
          ],
        )
    );
  }
}




class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Check your password',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Check your password'),
        ),
        body: MyForm(),
      ),
    );
  }
}