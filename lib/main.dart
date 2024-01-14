// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Flutter Secure Storage'),
        ),
        body: const SingleChildScrollView(child: MyForm()),
      ),
    );
  }
}

class MyForm extends StatefulWidget {
  const MyForm({super.key});

  @override
  _MyFormState createState() => _MyFormState();
}

class _MyFormState extends State<MyForm> {
  FlutterSecureStorage fs = const FlutterSecureStorage();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  Map<String, String> map = {};
  static int id = 0;

  void _submitForm() {
    String email = emailController.text;
    String password = passwordController.text;

    if (email.isNotEmpty && password.isNotEmpty) {
      fs.write(key: "email$id", value: email);
      fs.write(key: "password$id", value: password);
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Success!")));
      id++;
      emailController.clear();
      passwordController.clear();
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Enter both fields!")));
    }
  }

  void _getData() async {
    map = await fs.readAll();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            controller: emailController,
            decoration: const InputDecoration(labelText: 'Email'),
          ),
          const SizedBox(height: 16.0),
          TextField(
            controller: passwordController,
            decoration: const InputDecoration(labelText: 'Password'),
            obscureText: true,
          ),
          const SizedBox(height: 32.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Submit'),
              ),
              ElevatedButton(
                onPressed: _getData,
                child: const Text('Get Data'),
              ),
            ],
          ),
          SizedBox(
            height: 0.5 * MediaQuery.of(context).size.height,
            child: ListView.builder(
              itemCount: map.length ~/ 2, // email and password pairs
              itemBuilder: (BuildContext context, int index) {
                String emailKey = 'email${index + 1}';
                String passwordKey = 'password${index + 1}';
                String email = map[emailKey] ?? '';
                String password = map[passwordKey] ?? '';

                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text('Email: $email'),
                    subtitle: Text('Password: $password'),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
