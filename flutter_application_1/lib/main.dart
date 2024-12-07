// ignore_for_file: prefer_const_constructors

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CarregarCrud(),
      debugShowCheckedModeBanner: false,
    );
  }
}

  List<dynamic> listaDeObjetos = [];


class RenderizarListview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: 
        ListView.builder(
                    itemCount: listaDeObjetos.length,
                    itemBuilder: (context, index) {
                      final objeto = listaDeObjetos[index];
                      return ListTile(
                        title: Text(objeto['name']), 
                        subtitle: Text("address: ${objeto['address']}"),
                        
                        onTap: (){ Navigator.push(context, MaterialPageRoute(builder: (context) => CarregarCrud()));},
                      );}));
  }
}
class CarregarCrud extends StatefulWidget {

  @override
  State<CarregarCrud> createState() => TelaCrud();

}


class TelaCrud extends State<CarregarCrud> {
  

  final TextEditingController name = TextEditingController();
  final TextEditingController categoria = TextEditingController();


Future<void> getAll() async{
  try{
      final response = await http.get(Uri.parse('http://localhost/api/testeApi.php/clinte'));

      if(response.statusCode == 200) {
        final List<dynamic> jsonLista = jsonDecode(response.body);
        
        setState(() {
          listaDeObjetos = jsonLista;
        });
        print('deu certo');
        print(listaDeObjetos[2]);
      }else {
        print("erro: ${response.statusCode}");
      }
  }catch(e) {
    print("erro : $e");  
}}

Future<void> create() async {
 try{
    final response = await http.post(Uri.parse('http://localhost/api/testeApi.php/clinte'),
 
        body: jsonEncode({
          "nome" : name.text,
          "categoria": categoria.text
        }));
        if (response.statusCode == 201) {
        print("Deu certo!");
      } else {
        print('Deu erro: ${response.statusCode}');
        print({response.body});
      }
 }
 catch(e) {
  print('Erro: $e');
 }
}


Future<void> update(int id) async {
 try{
    final response = await http.put(Uri.parse('http://localhost/api/testeApi.php/clinte/$id'),
    body: jsonEncode({
           "nome" : name.text,
          "categoria": categoria.text
        }));
    if(response.statusCode == 200){
      print("atualizado!");
      
    }else{
      print("erro: ${response.statusCode}");
   
    }
 }catch(e){
  print("erro: $e");
 }}

 Future<void> delete(int id) async{
 try{
  final response = await http.delete(Uri.parse("http://localhost/api/testeApi.php/clinte/$id"));
  if(response.statusCode == 200){
    print("sucesso");
  }else{
    print("erro ");
  }
 }
 catch(e){
  print("erro $e");
  }}

  
@override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CRUD'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: name,
              decoration: InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: categoria,
              decoration: InputDecoration(
                labelText: 'Categoria',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {create();},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                  ),
                  child: Text('Create'),
                ),
                ElevatedButton(
                  onPressed: () {getAll();
                  Navigator.push(context, MaterialPageRoute(builder: (context) => RenderizarListview()));},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                  ),
                  child: Text('Read'),
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {update(1);},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                  ),
                  child: Text('Update'),
                ),
                ElevatedButton(
                  onPressed: () {delete(1);},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                  ),
                  child: Text('Delete'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}