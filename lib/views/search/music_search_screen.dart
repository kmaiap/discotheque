import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../models/playlist_model.dart';
import '../../models/track_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/music_search_provider.dart';
import '../../providers/playlist_provider.dart';
import '../../services/firestore_service.dart';
import '../widgets/custom_toast.dart';
import '../widgets/mini_player_dock.dart';

// Tela de busca de faixas musicais integrada à API externa
class MusicSearchScreen extends StatefulWidget {
  final String? targetPlaylistId;

  const MusicSearchScreen({super.key, this.targetPlaylistId});

  @override
  State<MusicSearchScreen> createState() => _MusicSearchScreenState();
}

class _MusicSearchScreenState extends State<MusicSearchScreen> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MusicSearchProvider>().search('Synthwave');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Buscar Músicas', style: AppTextStyles.headlineSm),
      ),
      body: Column(
        children: [
          _buildSearchBox(),
          _buildFilterPills(),
          Expanded(child: _buildResultsList()),
          const MiniPlayerDock(),
        ],
      ),
    );
  }

  // Campo de busca com ícone neon e botão de pesquisa
  Widget _buildSearchBox() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: TextField(
        controller: _searchController,
        style: AppTextStyles.bodyMd.copyWith(color: Colors.white),
        decoration: InputDecoration(
          hintText: 'Música, artista ou álbum...',
          prefixIcon: const Icon(Icons.search, color: AppColors.tertiary),
          suffixIcon: IconButton(
            icon: const Icon(Icons.arrow_forward, color: AppColors.primary),
            onPressed: () => _triggerSearch(),
          ),
        ),
        onSubmitted: (_) => _triggerSearch(),
      ),
    );
  }

  // Pílulas de filtro temáticas
  Widget _buildFilterPills() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        children: [
          _buildPill('Todas', isActive: true),
          const SizedBox(width: 8),
          _buildPill('Músicas'),
          const SizedBox(width: 8),
          _buildPill('Artistas'),
          const SizedBox(width: 8),
          _buildPill('Álbuns em Vinil'),
        ],
      ),
    );
  }

  // Pílula individual
  Widget _buildPill(String label, {bool isActive = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isActive ? AppColors.tertiary.withValues(alpha: 0.2) : AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isActive ? AppColors.tertiary : Colors.white10,
        ),
      ),
      child: Text(
        label,
        style: AppTextStyles.labelMd.copyWith(
          color: isActive ? AppColors.tertiary : AppColors.onSurfaceVariant,
        ),
      ),
    );
  }

  // Lista com os resultados retornados pela API
  Widget _buildResultsList() {
    final search = context.watch<MusicSearchProvider>();
    if (search.isSearching) {
      return const Center(child: CircularProgressIndicator(color: AppColors.tertiary));
    }
    if (search.results.isEmpty) {
      return Center(
        child: Text('Nenhuma música encontrada.', style: AppTextStyles.bodySm),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: search.results.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final track = search.results[index];
        return _buildTrackResultCard(track);
      },
    );
  }

  // Card para cada faixa encontrada
  Widget _buildTrackResultCard(TrackModel track) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        children: [
          _buildCoverArt(track),
          const SizedBox(width: 12),
          Expanded(child: _buildTrackMetadata(track)),
          _buildAddButton(track),
        ],
      ),
    );
  }

  // Miniatura da capa do álbum retornado pela API
  Widget _buildCoverArt(TrackModel track) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: CachedNetworkImage(
        imageUrl: track.albumCoverUrl,
        width: 48,
        height: 48,
        fit: BoxFit.cover,
        errorWidget: (_, __, ___) => Container(
          width: 48,
          height: 48,
          color: AppColors.surfaceContainerHighest,
          child: const Icon(Icons.music_note, color: AppColors.primary),
        ),
      ),
    );
  }

  // Metadados da música (Título, Artista, Duração)
  Widget _buildTrackMetadata(TrackModel track) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          track.title,
          style: AppTextStyles.bodyMd.copyWith(fontWeight: FontWeight.bold, color: Colors.white),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        Text(
          '${track.artist} • (${track.formattedDuration})',
          style: AppTextStyles.bodySm,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  // Botão neon para adicionar à playlist
  Widget _buildAddButton(TrackModel track) {
    return ElevatedButton.icon(
      onPressed: () => _handleAddToPlaylist(track),
      icon: const Icon(Icons.add, size: 16),
      label: const Text('Adicionar'),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryContainer,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }

  void _triggerSearch() {
    context.read<MusicSearchProvider>().search(_searchController.text);
  }

  // Executa adição da faixa na playlist alvo ou abre seletor
  void _handleAddToPlaylist(TrackModel track) async {
    if (widget.targetPlaylistId != null) {
      final success = await context.read<PlaylistProvider>().addTrack(
            widget.targetPlaylistId!,
            track,
          );
      if (mounted && success) {
        CustomToast.showSuccess(context, 'Música adicionada à playlist!');
      }
    } else {
      _showPlaylistPicker(track);
    }
  }

  // Exibe modal para escolher em qual playlist adicionar
  void _showPlaylistPicker(TrackModel track) {
    final user = context.read<AuthProvider>().currentUser;
    if (user == null) return;

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surfaceContainerLow,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => _buildPlaylistPickerList(ctx, user.uid, track),
    );
  }

  // Lista de playlists do usuário para seleção rápida
  Widget _buildPlaylistPickerList(BuildContext ctx, String uid, TrackModel track) {
    return StreamBuilder<List<PlaylistModel>>(
      stream: FirestoreService().streamUserPlaylists(uid),
      builder: (context, snapshot) {
        final list = snapshot.data ?? [];
        return ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.all(20),
          children: [
            Text('Escolha uma Discoteca', style: AppTextStyles.headlineSm),
            const SizedBox(height: 12),
            ...list.map((p) => ListTile(
                  leading: const Icon(Icons.album, color: AppColors.primary),
                  title: Text(p.title, style: AppTextStyles.bodyMd),
                  onTap: () async {
                    Navigator.pop(ctx);
                    await context.read<PlaylistProvider>().addTrack(p.id, track);
                    if (mounted) {
                      CustomToast.showSuccess(context, 'Música adicionada!');
                    }
                  },
                )),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

