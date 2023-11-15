import 'package:flutter/material.dart';

import 'form_register/form.dart'; // Import the form.dart file

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const ThreeExpandedRowExample(),
    );
  }
}

class ThreeExpandedRowExample extends StatelessWidget {
  const ThreeExpandedRowExample({super.key});

  @override
  Widget build(BuildContext context) {
    const urlImage = 'https://i.ibb.co/WVQYsTj/aqwiselogo-1-2.png';
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Row(
          children: <Widget>[
            Expanded(
              child: Container(
                color: Colors.black,
              ),
            ),
            Expanded(
              flex: 5,
              child: Container(
                color: Colors.black38,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image.network(
                        urlImage,
                        height: 100,
                        width: 100,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'AQWise Sdn Bhd', // Add your desired text here
                        style: TextStyle(
                          fontSize:
                              18, // You can adjust the font size and style as needed
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          // Navigate to the form.dart file when the button is pressed
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const FormScreen(),
                          ));
                        },
                        style: ElevatedButton.styleFrom(
                            fixedSize: Size(250, 50),
                            backgroundColor: Colors.black),
                        child: const Text(
                          'Klik untuk Daftar',
                          style: TextStyle(color: Colors.white, fontSize: 24),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
