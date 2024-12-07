import 'dart:convert'; // Para converter JSON
import 'package:http/http.dart' as http;

class Pessoa {
  final String nome;
  final int idade;

  Pessoa({required this.nome, required this.idade});

  // Converte Pessoa para um Map (JSON)
  Map<String, dynamic> toJson() {
    return {
      'nome': nome,
      'idade': idade,
    };
  }

  // Cria um objeto Pessoa a partir de um Map (JSON)
  factory Pessoa.fromJson(Map<String, dynamic> json) {
    return Pessoa(
      nome: json['nome'],
      idade: json['idade'],
    );
  }
}



Future<void> fetchData() async {
  final url = Uri.parse('https://jsonplaceholder.typicode.com/posts');
  
  try {
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body); // Converte a resposta JSON para um Map ou Lista
      print('Dados: $data');
    } else {
      print('Erro na requisição: ${response.statusCode}');
    }
  } catch (e) {
    print('Erro: $e');
  }
}


Future<void> create(Pessoa pessoa) async {
 try{

  final body = jsonEncode(pessoa.toJson());
    final response = await http.post(Uri.parse(''),
    headers: {
          'Content-Type': 'application/json', // Define o tipo do conteúdo
        },
        body: body);


        if (response.statusCode == 201) {
        print('Pessoa enviada com sucesso!');
      } else {
        print('Erro ao enviar pessoa: ${response.statusCode}');
        print('Mensagem: ${response.body}');
      }
 }
 catch(e) {
  print('Erro: $e');
 }
}

Future<Pessoa?> readOne(int id) async {
 
  try{

    final response = await http.get(Uri.parse('/$id'),
    headers: {
          'Content-Type': 'application/json', // Define o tipo do conteúdo
        });

        if (response.statusCode == 200) {
        // Decodifica o corpo da resposta e converte para uma instância de Pessoa
        final Map<String, dynamic> json = jsonDecode(response.body);
        return Pessoa.fromJson(json);
      }
      else {
        print('Erro ao buscar pessoa: ${response.statusCode}');
        return null;
      }
  }
  catch(e) {
    print("erro: $e" );
  }
  print("Read operation: Fetching data...");
}

Future<List<Pessoa>> readAll() async{
  try{
      final response = await http.get(Uri.parse(''),
      headers: {
        'Content-Type': 'application/json',
      });


      if(response.statusCode == 200) {

        final List<dynamic> jsonLista = jsonDecode(response.body);
        return jsonLista.map((json) => Pessoa.fromJson(json)).toList();

      }else {
        print("erro: ${response.statusCode}");
        return [];
      }
  }catch(e) {
    print("erro : $e");  
    return [];
}

}

Future<bool> update(int id, Pessoa pessoa) async {
 try{

    final body = jsonEncode(pessoa.toJson());
    final response = await http.put(Uri.parse('/$id'),
    headers: {'Content-Type': 'application/json'},
    body: body);

    if(response.statusCode == 200){
      print("atualizado!");
      return true;
    }else{
      print("erro: ${response.statusCode}");
      return false;
    }
 }catch(e){
  print("erro: $e");
  return false;
 }
}

Future<bool> delete(int id) async{
 try{
  final response = await http.delete(Uri.parse("/$id"), headers: {});
  if(response.statusCode == 200 || response.statusCode == 204){
    print("sucesso");
    return true;
  }else{
    print("erro");
    return false;
  }
 }
 catch(e){
  print("erro $e");
  return false;
 }
}