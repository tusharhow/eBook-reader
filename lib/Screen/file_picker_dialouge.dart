import 'package:flutter/material.dart';

class FilePickerDialouge extends StatelessWidget {
  const FilePickerDialouge({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
                elevation: 0.0,
                backgroundColor: Colors.transparent,
                content: Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    height: 300,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 30,
                        ),
                        Center(
                          child: Text(
                            "Select Method",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        Column(
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.of(context).pop("files");
                              },
                              child: Container(
                                height: 100,
                                width: 200,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: Colors.black,
                                    width: 1,
                                  ),
                                  color: Colors.white,
                                ),
                                padding: EdgeInsets.all(10),
                                child: Column(
                                  children: [
                                    Text("Select from Files"),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Icon(
                                      Icons.file_upload,
                                      color: Colors.blue,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 20),
                            InkWell(
                              onTap: () {
                                Navigator.of(context).pop("qr");
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: Colors.black,
                                    width: 1,
                                  ),
                                  color: Colors.white,
                                ),
                                height: 100,
                                width: 200,
                                padding: EdgeInsets.all(10),
                                child: Column(
                                  children: [
                                    Text("Scan a QR"),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Icon(
                                      Icons.camera_alt,
                                      color: Colors.blue,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
  }
}
