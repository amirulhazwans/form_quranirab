import 'package:flutter/material.dart';
import 'package:form_project_one/form_register/form.dart';

class Done extends StatelessWidget {
  const Done({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: <Widget>[
          Expanded(
            child: Container(
              color: Colors.black,
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              color: Colors.black38,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.network(
                    'https://i.ibb.co/JjkzGx4/complete-29-1.png',
                    height: 100,
                    width: 100,
                  ),
                  const Text(
                    "Terima Kasih Sebab Mendaftar Sebagai Ahli",
                    style: TextStyle(
                      color: Colors.white, // Text color
                      fontSize: 10.0, // Text size
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const FormScreen(),
                      ));
                    },
                    child: const Text("Kembali ke Pendaftaran"),
                  ),
                ],
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
    );
  }
}
