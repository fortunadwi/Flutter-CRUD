import 'dart:convert';
// import 'dart:js';
// import 'dart:html';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// Code 1, Code 2, Code 3
// Future<http.Response> getData() async {
//   var result =
//       await http.get(Uri.parse("https://jsonplaceholder.typicode.com/users"));
//   print(result.body);
//   return result;
// }

Future<http.Response> getData() async {
  var result =
      await http.get(Uri.parse("http://127.0.0.1:8082/api/userflutter/getAll"));
  print(result.body);
  return result;
}

// Post Data Code 3
Future<http.Response> postData(Map<String, dynamic> data) async {
  // Map<String, dynamic> data = {};

  var result = await http.post(
      Uri.parse("http://127.0.0.1:8082/api/userflutter/getAll"),
      headers: <String, String>{
        "Content-Type": "application/json; charset=UTF-8"
      },
      body: jsonEncode(data));
  print(result.statusCode);
  print(result.body);
  return result;
}

// Edit Put Data
Future<http.Response> updateData(id) async {
  Map<String, dynamic> data = {
    "nama": updnama.text,
    "email": updemail.text,
    "gender": updgender.text,
  };

  var result = await http.put(
      Uri.parse("http://127.0.0.1:8082/api/userflutter/update/${id}"),
      headers: <String, String>{
        "Content-Type": "application/json; charset=UTF-8"
      },
      body: jsonEncode(data));
  print(result.statusCode);
  print(result.body);
  return result;
}

Future<http.Response> deleteData(int id) async {
  var result = await http.delete(
      Uri.parse("http://127.0.0.1:8082/api/userflutter/delete/${id}"),
      headers: <String, String>{
        "Content-Type": "application/json; charset=UTF-8"
      });

  print(result.statusCode);
  print(result.body);
  return result;
}

final varnama = TextEditingController();
final varemail = TextEditingController();
final vargender = TextEditingController();

final updnama = TextEditingController();
final updemail = TextEditingController();
final updgender = TextEditingController();

class NetworkingHttpApp extends StatefulWidget {
  NetworkingHttpApp({super.key});

  @override
  State<NetworkingHttpApp> createState() => _NetworkingHttpAppState();
}

class _NetworkingHttpAppState extends State<NetworkingHttpApp> {
  // Print Dari Http Code 1
  @override
  Widget build(BuildContext context) {
    Future<http.Response> insertData(Map<String, String> data) async {
      var result = await http.post(
          Uri.parse("http://127.0.0.1:8082/api/userflutter/insert"),
          headers: <String, String>{
            "Content-Type": "application/json; charset=UTF-8"
          },
          body: jsonEncode(data));
      print(result.statusCode);
      return result;
    }

    var data = getData();
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.deepPurple.shade400,
          centerTitle: true,
          title: Text("Network Http")),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // postData("data");
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                    scrollable: true,
                    title: Text('Tambah Data'),
                    content: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Form(
                          child: Column(
                        children: <Widget>[
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'nama',
                              icon: Icon(Icons.people),
                            ),
                            controller: varnama,
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'email',
                              icon: Icon(Icons.email),
                            ),
                            controller: varemail,
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'gender',
                              icon: Icon(Icons.female_outlined),
                            ),
                            controller: vargender,
                          ),
                        ],
                      )),
                    ),
                    actions: [
                      ElevatedButton(
                          child: Text("Tambah"),
                          onPressed: () async {
                            await insertData(
                              {
                                "nama": varnama.text,
                                "email": varemail.text,
                                "gender": vargender.text
                              },
                            );
                            setState(() {});
                            Navigator.pop(context);
                          }),
                    ]);
              });
        },
        child: Icon(Icons.add),
      ),
      body: FutureBuilder<http.Response>(
          future: data,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<dynamic> json = jsonDecode(snapshot.data!.body);
              return ListView.builder(
                itemCount: json.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(json[index]["nama"] ?? ""),
                    subtitle: Text(json[index]["email"] ?? ""),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () async {
                            updnama.text = json[index]["nama"];
                            updemail.text = json[index]["email"];
                            updgender.text = json[index]["gender"];

                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                      scrollable: true,
                                      title: Text('Edit Data'),
                                      content: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Form(
                                            child: Column(
                                          children: <Widget>[
                                            TextFormField(
                                              decoration: InputDecoration(
                                                labelText: 'nama',
                                                icon: Icon(Icons.people),
                                              ),
                                              controller: updnama,
                                            ),
                                            TextFormField(
                                              decoration: InputDecoration(
                                                labelText: 'email',
                                                icon: Icon(Icons.email),
                                              ),
                                              controller: updemail,
                                            ),
                                            TextFormField(
                                              decoration: InputDecoration(
                                                labelText: 'gender',
                                                icon:
                                                    Icon(Icons.female_outlined),
                                              ),
                                              controller: updgender,
                                            ),
                                          ],
                                        )),
                                      ),
                                      actions: [
                                        ElevatedButton(
                                            child: Text("Update"),
                                            onPressed: () async {
                                              await updateData(
                                                json[index]["id_user"],
                                              );

                                              setState(() {});
                                              Navigator.pop(context);
                                            }),
                                      ]);
                                });
                            // await updateData(json[index]["id_user"]);
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () async {
                            await deleteData(json[index]["id_user"]);
                            setState(() {});
                          },
                        ),
                      ],
                    ),
                  );
                },
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }
}

class NetworkSTL extends StatelessWidget {
  const NetworkSTL({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: NetworkingHttpApp(),
    );
  }
}
