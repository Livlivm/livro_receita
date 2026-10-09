class Receita {
  final dynamic id;
  final String nome;
  final String tipo;
  final String ingredientes;
  final String modoFazer;
  final String img;
  final double custoAproximado;

  const Receita({
    required this.id,
    required this.nome,
    required this.tipo,
    required this.ingredientes,
    required this.modoFazer,
    required this.img,
    required this.custoAproximado,
  });

  factory Receita.fromJson(Map<String, dynamic> json) {
    return Receita(
      id: json['id'] ?? json['_id'],
      nome: (json['nome'] ?? '').toString(),
      tipo: (json['tipo'] ?? 'SALGADA').toString(),
      ingredientes: (json['ingredientes'] ?? '').toString(),
      modoFazer: (json['modoFazer'] ?? json['modoPreparo'] ?? '').toString(),
      img: (json['img'] ?? json['imagem'] ?? '').toString(),
      custoAproximado:
          double.tryParse(
            (json['custoAproximado'] ?? 0).toString().replaceAll(',', '.'),
          ) ??
          0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nome': nome,
      'tipo': tipo,
      'ingredientes': ingredientes,
      'modoFazer': modoFazer,
      'img': img,
      'custoAproximado': custoAproximado,
    };
  }
}
