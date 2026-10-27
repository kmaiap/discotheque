// Modelo de Usuário persistido no Cloud Firestore
class UserModel {
  final String uid;
  final String email;
  final String displayName;

  const UserModel({
    required this.uid,
    required this.email,
    required this.displayName,
  });

  // Converte mapa do Firestore em instância de UserModel
  factory UserModel.fromMap(Map<String, dynamic> map, String id) {
    return UserModel(
      uid: id,
      email: map['email'] as String? ?? '',
      displayName: map['displayName'] as String? ?? 'Usuário Sem Nome',
    );
  }

  // Converte a instância em mapa para gravação no Firestore
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
    };
  }
}

