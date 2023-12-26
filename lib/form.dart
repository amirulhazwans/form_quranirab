import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_project_one/done.dart';
import 'package:form_project_one/firebase_options.dart';
import 'package:form_project_one/main.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

final Uri _url = Uri.parse('https://aqwise.my/');

class FormScreen extends StatefulWidget {
  const FormScreen({super.key});

  @override
  createState() => _FormScreenState();
}



class _FormScreenState extends State<FormScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController institutionNameController = TextEditingController();
  String selectedOption = ""; // Define the variable here
  Uint8List? imageBytes;


  CollectionReference users = FirebaseFirestore.instance.collection('users');
  double _uploadProgress = 0.0;
  bool _isUploading = false;
  bool _isButtonDisabled = false;
  String? imageUrl;

  Future<void> pickImage() async {
    if(nameController.text.isEmpty && phoneNumberController.text.isEmpty && selectedOption.isEmpty)
    {
      print("fill out detail");
    }
    else
    {
      FilePickerResult? result =
      await FilePicker.platform.pickFiles(type: FileType.image);

      if (result != null)
      {
        final bytes = result.files.single.bytes;
        setState(() {
          imageBytes = bytes;
          _uploadProgress = 1.0;
        });
      }
    }
  }


  Future<void> submitImage() async {
    setState(() {
      _isUploading = true;
      _uploadProgress = 0.0;
      _isButtonDisabled = true;
    });
    if (imageBytes != null) {
      String name = nameController.text;
      String phoneNumber = phoneNumberController.text;
      String institutionName = institutionNameController.text;
      String urlField = "https://example.com";



      // Upload image to Firebase Storage
      String imagePath = 'images/${DateTime.now().millisecondsSinceEpoch}.jpg';
      Reference storageReference = FirebaseStorage.instance.ref().child(imagePath);
      UploadTask uploadTask = storageReference.putData(imageBytes!);

      uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        double progress = snapshot.bytesTransferred / snapshot.totalBytes;
        setState(() {
          _uploadProgress = progress;
        });
      });

      await uploadTask.whenComplete(() async {
        // Get the download URL of the uploaded image
        String imageUrl = await storageReference.getDownloadURL();
        setState(() {
          _isUploading = false;
          _uploadProgress = 1.0;
          _isButtonDisabled = false;
        });
        // Add user data to Firestore with the image URL
        await users.add({
          'Nama': name,
          'Nombor telefon': phoneNumber,
          'Nama institut': institutionName,
          'Daftar sebagai': selectedOption,
          'ImageURL': imageUrl,
          'URLField': urlField,
        }).then((value) {
          print("User Added");

          setState(() {
            imageUrl = imageUrl;
          });

          // Navigate to the Done screen or perform any other actions
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Done()),
          );
        }).catchError((error) {
          print("Failed to add user: $error");
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _isUploading
            ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LinearProgressIndicator(value: _uploadProgress),
            SizedBox(height: 16),
            Text('${(_uploadProgress * 100).toStringAsFixed(2)}%'),
          ],
        )
            : buildFormBody(),
      ),
    );
  }

  Widget buildDetails() {
    var size = MediaQuery.of(context).size;
    return Container(
      height: size.height,
      color: Colors.black.withOpacity(0.38),
      child: Container(
        color: const Color(0xffE9D6B6),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Row(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: NetworkImage(
                      'https://i.ibb.co/9GfFYnx/receipt.png',
                    ),
                  ),
                  SizedBox(width: 16), // Add space here
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Pelajar: RM30 sebulan",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10.0,
                        ),
                      ),
                      Text(
                        "Orang Dewasa: RM100 sebulan",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10.0,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(
                  height: 16), // Add vertical space between the two rows
              const Row(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: NetworkImage(
                      'https://i.ibb.co/tz9740t/brand.gif',
                    ),
                  ),
                  SizedBox(width: 16), // Add space here
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Bayaran boleh dibuat melalui:",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10.0,
                        ),
                      ),
                      Text(
                        "AQ Wise Sdn Bhd",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10.0,
                        ),
                      ),
                      Text(
                        "12159010010945",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10.0,
                        ),
                      ),
                      Text(
                        "(Bank Islam Malaysia Berhad)",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10.0,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(
                  height: 16), // Add vertical space between the text and button
              Row(
                children: [
                  const Icon(
                    Icons.home, // You can change this to any other IconData
                    size: 30, // Adjust the size as needed
                    color: Colors.white, // Icon color
                  ),
                  ElevatedButton(
                    onPressed: _launchUrl,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xffE9D6B6),  // Change the button color here
                    ),
                    child: const Text('Aqwise Official Website'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildFormBody() {
    var size = MediaQuery.of(context).size;
    bool isFormIncomplete =
        nameController.text.isEmpty || phoneNumberController.text.isEmpty || selectedOption.isEmpty;
    return Container(
      height: size.height,

      color: const Color(0xffE9D6B6),
      child: Center(
        child: ListView(
          children: <Widget>[
            size.width > 700


            ///web UI
                ? Row(
              children: [
                Expanded(
                  child: Container(
                    height: size.height,
                    color: const Color(0xffE9D6B6),
                    child: const Padding(
                      padding: EdgeInsets.all(40.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [],
                      ),
                    ),
                  ),
                ),
                if (imageUrl != null) ...[
                  const SizedBox(height: 16),
                  Text(
                    'Image URL: $imageUrl',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ],

                ///content page
                Column(
                  children: [
                    Image.network(
                      'https://i.ibb.co/WPVXND3/Quran-Irab-Google-Form.png',
                      height: 200,
                      width: size.width > 700
                          ? size.width * 0.33
                          : size.width,
                      fit: BoxFit.fill,
                    ),
                    Container(
                      padding: EdgeInsets.all(16),
                      width: size.width > 700
                          ? size.width * 0.33
                          : size.width,
                      child: Card(
                        color: Color(0xffFFCFA3),
                        elevation: 10,
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Column(
                            children: [
                              const Text(
                                'Borang Pendaftaran Kelas Online QuranIrab Tadabbur',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontFamily: 'Agbalumo-Regular'),
                              ),
                              SizedBox(height: 16),
                              TextFormField(
                                controller: nameController,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r'[a-zA-Z ]')),
                                ],
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Nama',
                                  labelStyle: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              SizedBox(height: 16),
                              TextFormField(
                                controller: phoneNumberController,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r'[0-9]')),
                                ],
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Nombor Telefon',
                                  labelStyle: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              const Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Pilih Pendaftaran Sebagai:',
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              SizedBox(height: 8),
                              Row(
                                children: <Widget>[
                                  Radio(
                                    value: 'Pelajar',
                                    groupValue: selectedOption,
                                    onChanged: (value) {
                                      setState(() {
                                        selectedOption = value!;
                                      });
                                    },
                                  ),
                                  const Text(
                                    'Pelajar',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 16,
                                  ),
                                  Radio(
                                    value: 'Orang Awam',
                                    groupValue: selectedOption,
                                    onChanged: (value) {
                                      setState(() {
                                        selectedOption = value!;
                                      });
                                    },
                                  ),
                                  const Text(
                                    'Orang Awam',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              if (selectedOption == 'Pelajar')
                                TextFormField(
                                  controller: institutionNameController,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r'[a-zA-Z ]')),
                                  ],
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Nama Institut',
                                    labelStyle: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              const SizedBox(height: 16),
                              Text(
                                imageBytes != null
                                    ? "Resit berjaya dimuat naik"
                                    : 'klik di bawah dan Hantar Gambar resit ',
                                style: const TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 16),
                              if (imageBytes != null) ...[
                                const SizedBox(height: 16),
                                LinearProgressIndicator(
                                  value: _uploadProgress,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  '${(_uploadProgress * 100).toStringAsFixed(2)}%',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 16),
                              ],
                              if (isFormIncomplete)
                                const Text(
                                  'Isi semua detail dahulu',
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.center,
                                children: [
                                  imageBytes != null
                                      ? TextButton(
                                      onPressed: () {
                                        // Display the uploaded image in a new screen or dialog
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return Dialog(
                                              child: Image.memory(imageBytes!),
                                            );
                                          },
                                        );
                                      },
                                      child:
                                      const Text("Resit Pendaftaran"))

                                      : ElevatedButton(
                                    onPressed: isFormIncomplete ? null : pickImage,
                                    style: ElevatedButton.styleFrom(
                                      fixedSize:
                                      const Size(200, 50),
                                      backgroundColor: Colors.white,
                                    ),
                                    child: const Text(
                                      'Muat Naik Resit',
                                      style:
                                      TextStyle(fontSize: 20),
                                    ),
                                  ),
                                ],
                              ),
                              if (imageBytes != null) ...[
                                const SizedBox(height: 16),
                                ElevatedButton(
                                  onPressed: _isButtonDisabled ? null : submitImage,
                                  style: ElevatedButton.styleFrom(
                                    fixedSize: const Size(200, 50),
                                    backgroundColor: Color(0xffE9D6B6),
                                  ),
                                  child: const Text('Daftar Permohonan'),
                                ),
                                const SizedBox(height: 40),
                              ]
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Expanded(child: buildDetails())
              ],
            )

            ///mobile UI
                : Wrap(
              children: [
                ///content page
                Column(
                  children: [
                    Image.network(
                      'https://i.ibb.co/WPVXND3/Quran-Irab-Google-Form.png',
                      height: 200,
                      width: size.width > 700
                          ? size.width * 0.33
                          : size.width,
                      fit: BoxFit.fill,
                    ),
                    Container(
                      padding: EdgeInsets.all(16),
                      width: size.width > 700
                          ? size.width * 0.33
                          : size.width,
                      child: Card(
                        color: Color(0xffFFCFA3),
                        elevation: 10,
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Column(
                            children: [
                              const Text(
                                'Borang Pendaftaran Kelas Online QuranIrab Tadabbur',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontFamily: 'Agbalumo-Regular'),
                              ),
                              SizedBox(height: 16),
                              TextFormField(
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r'[a-zA-Z ]')),
                                ],
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Nama',
                                  labelStyle: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              SizedBox(height: 16),
                              TextFormField(
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r'[0-9]')),
                                ],
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Nombor Telefon',
                                  labelStyle: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              const Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Pilih Pendaftaran Sebagai:',
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              Row(
                                children: <Widget>[
                                  Radio(
                                    value: 'Pelajar',
                                    groupValue: selectedOption,
                                    onChanged: (value) {
                                      setState(() {
                                        selectedOption = value!;
                                      });
                                    },
                                  ),
                                  const Text(
                                    'Pelajar',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 16,
                                  ),
                                  Radio(
                                    value: 'Orang Awam',
                                    groupValue: selectedOption,
                                    onChanged: (value) {
                                      setState(() {
                                        selectedOption = value!;
                                      });
                                    },
                                  ),
                                  const Text(
                                    'Orang Awam',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              if (selectedOption == 'Pelajar')
                                TextFormField(
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r'[a-zA-Z ]')),
                                  ],
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Nama Institut',
                                    labelStyle: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              const SizedBox(height: 16),
                              Text(
                                imageBytes != null
                                    ? "Resit berjaya dimuat naik"
                                    : 'klik di bawah dan Hantar Gambar resit ',
                                style: const TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 16),
                              if (imageBytes != null) ...[
                                const SizedBox(height: 16),
                                LinearProgressIndicator(
                                  value: _uploadProgress,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  '${(_uploadProgress * 100).toStringAsFixed(2)}%',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 16),
                              ],
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.center,
                                children: [
                                  imageBytes != null
                                      ? TextButton(
                                      onPressed: () {
                                        ///display gambar
                                        launchUrl(Uri.parse(
                                            "https://aqwise.my/wp-content/uploads/2020/11/cropped-aqwiselogo3.png"));
                                      },
                                      child: const Text("Receipt"))
                                      : ElevatedButton(
                                    onPressed: pickImage,
                                    style: ElevatedButton.styleFrom(
                                      fixedSize:
                                      const Size(200, 50),
                                      backgroundColor: Color(0xffE9D6B6),
                                    ),
                                    child: const Text(
                                      'Muat Naik Resit',
                                      style: TextStyle(fontSize: 20),

                                    ),
                                  ),
                                ],
                              ),
                              if (imageUrl != null) ...[
                                const SizedBox(height: 16),
                                Text(
                                  'Image URL: $imageUrl',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                              if (imageBytes != null) ...[
                                const SizedBox(height: 16),
                                ElevatedButton(
                                  onPressed: submitImage,
                                  style: ElevatedButton.styleFrom(
                                    fixedSize: const Size(250, 50),
                                    backgroundColor: Color(0xffE9D6B6),
                                  ),
                                  child: const Text('Daftar Permohonan'),
                                ),
                                const SizedBox(height: 40),
                              ]
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                buildDetails()
              ],
            )
          ],
        ),
      ),
    );
  }
}

Future<void> _launchUrl() async {
  if (!await launchUrl(_url)) {
    throw Exception('Could not launch $_url');
  }
}