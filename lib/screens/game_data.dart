// game_data.dart

class GameData {
  String name;
  GameInfo data;

  GameData(this.name, this.data);

  // Factory constructor para la decodificación desde JSON
  factory GameData.fromJson(Map<String, dynamic> json) {
  return GameData(
    json['name'] as String,
    GameInfo.fromJson(json['data'] as Map<String, dynamic>),
  );
}

  // Método para codificar a JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'data': data.toJson(),
    };
  }
}

class GameInfo {
  String userName;
  int score;

  GameInfo(this.userName, this.score);

  // Factory constructor para la decodificación desde JSON
  factory GameInfo.fromJson(Map<String, dynamic> json) {
  return GameInfo(
    json['userName'] as String? ?? '', // Puedes proporcionar un valor predeterminado
    json['score'] as int? ?? 0,       // Puedes proporcionar un valor predeterminado
  );
}

  // Método para codificar a JSON
  Map<String, dynamic> toJson() {
    return {
      'userName': userName,
      'score': score,
    };
  }
}

