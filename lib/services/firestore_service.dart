import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../core/constants/app_constants.dart';
import '../models/playlist_model.dart';
import '../models/track_model.dart';
import '../models/user_model.dart';

// Serviço para operações no Cloud Firestore com responsabilidade única
class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference get _playlistsRef =>
      _firestore.collection(AppConstants.playlistsCollection);

  CollectionReference get _usersRef =>
      _firestore.collection(AppConstants.usersCollection);

  // Cria uma nova playlist no Firestore
  Future<String> createPlaylist({
    required String title,
    required String description,
    required String ownerId,
  }) async {
    final doc = await _playlistsRef.add({
      'title': title.trim(),
      'description': description.trim(),
      'ownerId': ownerId,
      'collaborators': <String>[],
      'createdAt': FieldValue.serverTimestamp(),
      'tracks': <Map<String, dynamic>>[],
    });
    return doc.id;
  }

  // Escuta alterações em tempo real de uma playlist específica
  Stream<PlaylistModel> streamPlaylist(String playlistId) {
    return _playlistsRef.doc(playlistId).snapshots().map(
          (doc) => PlaylistModel.fromFirestore(doc),
        );
  }

  // Stream combinando playlists onde o usuário é Dono ou Colaborador
  Stream<List<PlaylistModel>> streamUserPlaylists(String userId) {
    final ownerStream = _playlistsRef
        .where('ownerId', isEqualTo: userId)
        .snapshots();

    final collabStream = _playlistsRef
        .where('collaborators', arrayContains: userId)
        .snapshots();

    return _combinePlaylistStreams(ownerStream, collabStream);
  }

  // Combina dois streams de consulta em uma única lista sem duplicatas
  Stream<List<PlaylistModel>> _combinePlaylistStreams(
    Stream<QuerySnapshot> stream1,
    Stream<QuerySnapshot> stream2,
  ) {
    late StreamController<List<PlaylistModel>> controller;
    List<PlaylistModel> list1 = [];
    List<PlaylistModel> list2 = [];

    void emitMerged() {
      final map = <String, PlaylistModel>{};
      for (var item in list1) { map[item.id] = item; }
      for (var item in list2) { map[item.id] = item; }
      final result = map.values.toList()
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
      if (!controller.isClosed) controller.add(result);
    }

    controller = StreamController<List<PlaylistModel>>(onListen: () {
      stream1.listen((s) {
        list1 = s.docs.map((d) => PlaylistModel.fromFirestore(d)).toList();
        emitMerged();
      });
      stream2.listen((s) {
        list2 = s.docs.map((d) => PlaylistModel.fromFirestore(d)).toList();
        emitMerged();
      });
    });

    return controller.stream;
  }

  // Adiciona uma nova faixa musical à playlist
  Future<void> addTrack(String playlistId, TrackModel track) async {
    await _playlistsRef.doc(playlistId).update({
      'tracks': FieldValue.arrayUnion([track.toMap()]),
    });
  }

  // Remove uma faixa da playlist existente
  Future<void> removeTrack(String playlistId, TrackModel track) async {
    await _playlistsRef.doc(playlistId).update({
      'tracks': FieldValue.arrayRemove([track.toMap()]),
    });
  }

  // Convida um colaborador buscando o UID correspondente ao e-mail
  Future<void> addCollaboratorByEmail(String playlistId, String email) async {
    final query = await _usersRef
        .where('email', isEqualTo: email.trim().toLowerCase())
        .limit(1)
        .get();

    if (query.docs.isEmpty) {
      throw Exception('Nenhum usuário cadastrado com este e-mail.');
    }

    final targetUid = query.docs.first.id;
    await _playlistsRef.doc(playlistId).update({
      'collaborators': FieldValue.arrayUnion([targetUid]),
    });
  }

  // Remove um colaborador pelo UID
  Future<void> removeCollaborator(String playlistId, String collaboratorUid) async {
    await _playlistsRef.doc(playlistId).update({
      'collaborators': FieldValue.arrayRemove([collaboratorUid]),
    });
  }

  // Exclui a playlist do Firestore
  Future<void> deletePlaylist(String playlistId) async {
    await _playlistsRef.doc(playlistId).delete();
  }

  // Busca dados de perfil de um usuário pelo UID
  Future<UserModel?> getUserProfile(String uid) async {
    final doc = await _usersRef.doc(uid).get();
    if (!doc.exists || doc.data() == null) return null;
    return UserModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
  }

  // Busca lista de perfis correspondentes a uma lista de UIDs
  Future<List<UserModel>> getUsersByIds(List<String> uids) async {
    if (uids.isEmpty) return [];
    final List<UserModel> users = [];
    for (final uid in uids) {
      final user = await getUserProfile(uid);
      if (user != null) users.add(user);
    }
    return users;
  }
}

