import 'dart:convert';

// 14-agregacao.dart
// Agregação e Composição

class Dependente {
  late String _nome;

  Dependente(String nome) {
    this._nome = nome;
  }

  Map<String, dynamic> toJson() => {'nome': _nome};
}

class Funcionario {
  late String _nome;
  late List<Dependente> _dependentes;

  Funcionario(String nome, List<Dependente> dependentes) {
    this._nome = nome;
    this._dependentes = dependentes;
  }

  Map<String, dynamic> toJson() => {'nome': _nome, 'dependentes': _dependentes};
}

class EquipeProjeto {
  late String _nomeProjeto;
  late List<Funcionario> _funcionarios;

  EquipeProjeto(String nomeprojeto, List<Funcionario> funcionarios) {
    _nomeProjeto = nomeprojeto;
    _funcionarios = funcionarios;
  }

  Map<String, dynamic> toJson() => {
    'nomeProjeto': _nomeProjeto,
    'funcionarios': _funcionarios,
  };
}

void main() {
  final dependentePedro = Dependente('Ana');
  final dependenteMaria = Dependente('Lucas');
  final dependenteJoao = Dependente('Clara');

  final funcionarioPedro = Funcionario('Pedro', [dependentePedro]);
  final funcionarioMaria = Funcionario('Maria', [dependenteMaria]);
  final funcionarioJoao = Funcionario('Joao', [dependenteJoao]);

  final funcionarios = [funcionarioPedro, funcionarioMaria, funcionarioJoao];
  final equipeProjeto = EquipeProjeto('Projeto Dart', funcionarios);

  print(jsonEncode(equipeProjeto));
}
