import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:hci_mi5y_dormconnect/models/community.dart';
import 'package:hci_mi5y_dormconnect/theme/theme.dart';
import 'package:hci_mi5y_dormconnect/theme/icons.dart';
import 'package:hci_mi5y_dormconnect/theme/colors.dart';

class CommunityCard extends StatefulWidget {
  final Community                community;
  final void Function(Community)  onTap;

  const CommunityCard({
    super.key,
    required this.community,
    required this.onTap,
  });

  @override
  State<CommunityCard> createState() => _CommunityCardState();
}

class _CommunityCardState extends State<CommunityCard> {
  bool _isPressed = false;
  int _eventCount = 0;
  bool _isLoadingEvents = true;

  @override
  void initState() {
    super.initState();
    _loadEventCount();
  }

  Future<void> _loadEventCount() async {
    try {
      final response = await Supabase.instance.client
          .from('activities')
          .select('id')
          .eq('community', widget.community.name);

      if (mounted) {
        setState(() {
          _eventCount = response.length;
          _isLoadingEvents = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _eventCount = 0;
          _isLoadingEvents = false;
        });
      }
    }
  }

  ImageProvider _imageProvider(String? url) {
    if (url == null || url.isEmpty) {
      return const AssetImage('assets/images/placeholder.png');
    }
    return url.startsWith('http')
        ? NetworkImage(url)
        : AssetImage(url) as ImageProvider;
  }

  @override
  Widget build(BuildContext context) {
    final c       = widget.community;
    final members = c.memberCount;

    return GestureDetector(
      onTapDown   : (_) => setState(() => _isPressed = true),
      onTapUp     : (_) => setState(() => _isPressed = false),
      onTapCancel : ()  => setState(() => _isPressed = false),
      onTap       : ()  => widget.onTap(c),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        transformAlignment: Alignment.center,
        transform: Matrix4.identity()..scale(_isPressed ? 0.98 : 1.0),
        padding  : const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color       : Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow   : [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Hero(
              tag: 'community-image-${c.id}',
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image(
                  image : _imageProvider(c.image),
                  width : 80,
                  height: 80,
                  fit   : BoxFit.cover,
                ),
              ),
            ),

            const SizedBox(width: 16),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    c.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTheme()
                        .light(context)
                        .textTheme
                        .labelLarge
                        ?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary(context),
                    ),
                  ),
                  const SizedBox(height: 4),

                  Text(
                    c.location,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTheme()
                        .light(context)
                        .textTheme
                        .labelMedium
                        ?.copyWith(color: AppColors.textPrimary(context).withOpacity(0.9)),
                  ),
                  const SizedBox(height: 8),

                  Row(
                    children: [
                      AppIcons.group_filled(color: AppColors.secondary(context), size: 16),
                      const SizedBox(width: 4),
                      Text(
                        '$members members',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),

                  Row(
                    children: [
                      AppIcons.event(color: AppColors.secondary(context), size: 16),
                      const SizedBox(width: 4),
                      _isLoadingEvents
                          ? SizedBox(
                        width: 12,
                        height: 12,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.grey[700]!,
                          ),
                        ),
                      )
                          : Text(
                        '$_eventCount ongoing events',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}