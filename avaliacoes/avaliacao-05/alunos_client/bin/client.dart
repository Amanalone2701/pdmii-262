import 'dart:convert';
import 'dart:io';

Future<void> main() async {
  final url = Uri.parse('http://localhost:8080/api/alunos');
  final client = HttpClient();

  try {
    // 1. Faz a requisição GET ao Servidor Web
    final request = await client.getUrl(url);
    final response = await request.close();

    if (response.statusCode == 200) {
      // Decode da resposta JSON
      final responseBody = await response.transform(utf8.decoder).join();
      final Map<String, dynamic> json = jsonDecode(responseBody);
      final List<dynamic> alunos = json['dados'] as List<dynamic>;

      // 2. Iteração sobre a lista de alunos
      for (var aluno in alunos) {
        final id = aluno['id'];
        final nome = aluno['nome'];
        final disciplina = aluno['disciplina'];
        final media = (aluno['media'] as num).toDouble();
        final faltas = aluno['faltas'] as int;

        // Lógica para gerar uma ÚNICA mensagem por aluno:
        // A regra de faltas (> 20) tem precedência sob a média.
        String mensagem;
        if (faltas > 20) {
          mensagem = 'Reprovado por Faltas';
        } else if (media < 6.0) {
          mensagem = 'Reprovado';
        } else {
          mensagem = 'Aprovado';
        }

        // Impressão no formato: ID NOME DISCIPLINA MEDIA FALTAS MENSAGEM
        print('$id $nome $disciplina $media $faltas $mensagem');
      }
    } else {
      print('Erro ao acessar o servidor. Status: ${response.statusCode}');
    }
  } catch (e) {
    print('Erro na conexão com o servidor: $e');
  } finally {
    client.close();
  }
}