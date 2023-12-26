import 'package:flutter/material.dart';
import 'package:form_project_one/form.dart';

class Done extends StatelessWidget {
  const Done({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: <Widget>[
          Expanded(
            child: Container(
              child: Card(
                color: Color(0xffFFCFA3),
                elevation: 10,
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: buildFormBody(context),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget buildFormBody(BuildContext context) {
  var size = MediaQuery.of(context).size;
  return Center(
    child: Container(
      height: size.height,
      color: const Color(0xffE9D6B6),

      child: ListView(
        children: <Widget>[
          if (size.width > 10)
            Container(
              padding: EdgeInsets.all(16),
              width: size.width > 700 ? size.width * 0.3 : size.width,

              child: Column(
                children: [
                  SizedBox(height: 80),
                  Image.network(
                    'https://i.ibb.co/JjkzGx4/complete-29-1.png',
                    height: 100,
                    width: 100,
                  ),
                  const Text(
                    "Terima Kasih Sebab Mendaftar Sebagai Ahli",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16.0,
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
        ],
      ),
    ),
  );
}