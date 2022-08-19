class Task {
  final int? id;
  final String titulo;
  final String descricao;
  final String duracao;
  final String data;

  Task(
      { this.id,
        required this.titulo,
        required this.descricao,
        required this.duracao,
        required this.data}
  );

  Task.fromMap(Map<String, dynamic> res):
        id = res["id"],
        titulo = res["titulo"],
        descricao = res["descricao"],
        duracao = res["duracao"],
        data = res["data"];


  Map<String, Object?> toMap() {
    return {'id':id,'titulo': titulo, 'descricao': descricao, 'duracao': duracao, 'data': data};
  }
}