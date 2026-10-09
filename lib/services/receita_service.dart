import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/receita.dart';

class ReceitaService {
  static const String baseUrl = 'https://receitasapi-b-2025.vercel.app';

  Future<List<Receita>> listar() async {
    final resposta = await http.get(Uri.parse('$baseUrl/receitas'));

    if (resposta.statusCode != 200) {
      throw Exception('Erro ao carregar receitas: ${resposta.statusCode}');
    }

    final dados = jsonDecode(utf8.decode(resposta.bodyBytes));

    dynamic lista = dados;

    if (dados is Map<String, dynamic>) {
      lista = dados['receitas'] ?? dados['data'] ?? dados['items'];
    }

    if (lista is! List) {
      throw Exception('Formato de resposta inesperado.');
    }

    return lista
        .whereType<Map>()
        .map((item) => Receita.fromJson(Map<String, dynamic>.from(item)))
        .toList();
  }

  Future<void> criar(Receita receita) async {
    final resposta = await http.post(
      Uri.parse('$baseUrl/receitas'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode(receita.toJson()),
    );

    if (resposta.statusCode < 200 || resposta.statusCode >= 300) {
      throw Exception(
        'Não foi possível cadastrar. '
        'Código: ${resposta.statusCode}',
      );
    }
  }

  Future<void> atualizar(Receita receita) async {
    final resposta = await http.put(
      Uri.parse('$baseUrl/receitas/${receita.id}'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode(receita.toJson()),
    );

    if (resposta.statusCode < 200 || resposta.statusCode >= 300) {
      throw Exception('Não foi possível atualizar a receita.');
    }
  }

  Future<void> excluir(dynamic id) async {
    final resposta = await http.delete(Uri.parse('$baseUrl/receitas/$id'));

    if (resposta.statusCode < 200 || resposta.statusCode >= 300) {
      throw Exception('Não foi possível excluir a receita.');
    }
  }
}
