import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:form_project_one/firebase_options.dart';
import 'package:form_project_one/form.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Register QuranIrab',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const LandingPage(),
    );
  }
}

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color(0xfffffaf6),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(size.width < 400 ? 40 : 80.0),
          child: Column(
            children: [
              Wrap(
                alignment: WrapAlignment.center,
                children: <Widget>[
                  Container(
                    width: 500,
                    child: Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          if (size.width > 400) SizedBox(height: 32 * 3),
                          RichText(
                              text: TextSpan(
                                  children: const [
                                    TextSpan(
                                        text: 'KELAS ',
                                        style: TextStyle(color: Colors.black)),
                                    TextSpan(
                                        text: 'QURANIRAB',
                                        style: TextStyle(color: Colors.amber)),
                                  ],
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineLarge!
                                      .apply(fontWeightDelta: 3))),
                          const SizedBox(height: 32),
                          const Text(
                            "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec ultrices varius sollicitudin. Nulla sodales lorem nec orci rhoncus ultricies. Aliquam gravida, turpis id consectetur consectetur, nibh libero eleifend purus, vel porttitor nisi augue bibendum urna. Nam tristique nec orci quis commodo. Sed posuere pulvinar ligula quis ullamcorper. Nulla rhoncus venenatis ligula ut consequat. Nulla orci velit, placerat ac eleifend id, vulputate eu lectus. Nulla mollis a erat eu feugiat. Donec consectetur faucibus tempus. Nam suscipit felis eget arcu accumsan, ut aliquam lectus laoreet. Nunc scelerisque felis id semper pharetra.Duis e dui, ",
                            textAlign: TextAlign.justify,
                            style: TextStyle(
                              fontSize:
                              18, // You can adjust the font size and style as needed
                            ),
                          ),
                          const SizedBox(height: 32),
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
                            child: Text(
                              'DAFTAR SEKARANG',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: size.width <= 400 ? 18 : 24),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 80),
                  Image.asset(
                    'assets/6628329.png',
                    width: 500,
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}