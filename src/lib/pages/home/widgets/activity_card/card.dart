import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:hci_mi5y_dormconnect/models/activity/activity.dart';
import 'package:hci_mi5y_dormconnect/theme/theme.dart';
import 'package:hci_mi5y_dormconnect/theme/icons.dart';
import 'package:hci_mi5y_dormconnect/theme/colors.dart';
import 'package:hci_mi5y_dormconnect/widgets/category_badge.dart';


class ActivityCard extends StatefulWidget {
  final Activity activity;
  final String Function(DateTime) formatDate;
  final void Function(Activity) onTap;

  final double? width;
  final double? height;
  final EdgeInsets? margin;

  const ActivityCard({
    super.key,
    required this.activity,
    required this.formatDate,
    required this.onTap,
    this.width,
    this.height,
    this.margin,
  });

  @override
  State<ActivityCard> createState() => _ActivityCardState();
}

class _ActivityCardState extends State<ActivityCard> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final a = widget.activity;
    final screen = MediaQuery.of(context).size;
    final h = widget.height ?? screen.height * 0.3;

    final String participantsText =
        a.maxParticipants != null
            ? '${a.participantCount}/${a.maxParticipants}'
            : '${a.participantCount}';

    ImageProvider _img(String? path) {
      if (path == null || path.isEmpty) {
        return const NetworkImage('https://placehold.co/600x400?text=No+image');
      }

      if (path.startsWith('assets/')) {
        return AssetImage(path);
      }

      if (path.startsWith('http')) {
        return NetworkImage(path);
      }

      final publicUrl = Supabase.instance.client
          .storage
          .from('assets')
          .getPublicUrl(path);

      return NetworkImage(publicUrl);
    }

    Widget _heroShuttle(
      BuildContext _,
      Animation<double> anim,
      HeroFlightDirection __,
      BuildContext ___,
      BuildContext ____,
    ) {
      return AnimatedBuilder(
        animation: anim,
        builder: (_, child) {
          final t = Curves.easeOutExpo.transform(anim.value);
          return ClipRRect(
            borderRadius: BorderRadius.circular(10 * (1 - t)),
            child: child,
          );
        },
        child: Image(image: _img(a.image), fit: BoxFit.cover),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTapDown: (_) => setState(() => _isPressed = true),
          onTapUp: (_) => setState(() => _isPressed = false),
          onTapCancel: () => setState(() => _isPressed = false),
          onTap: () => widget.onTap(a),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            height: h,
            width: widget.width,
            transformAlignment: Alignment.center,
            transform: Matrix4.identity()..scale(_isPressed ? 0.98 : 1.0),
            margin: widget.margin,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
            clipBehavior: Clip.hardEdge,
            child: Column(
              children: [
                Expanded(
                  flex: 11,
                  child: Hero(
                    tag: a.id,
                    flightShuttleBuilder: _heroShuttle,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image(
                            image: _img(a.image),
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                          ),

                          if (a.categoryEnum != null)
                            Positioned(
                              top: 8,
                              right: 8,
                              child: CategoryBadge(
                                icon: a.categoryEnum!.getIcon(
                                  color: AppColors.secondary(context),
                                  size: 12,
                                ),
                                label: a.categoryEnum!.chipLabel,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),

                Expanded(
                  flex: 6,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(12, 12, 16, 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          a.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: AppTheme()
                              .light(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(
                            color: const Color(0xFF1b1b1b),
                            height: 1.1,
                          ),
                        ),
                        const SizedBox(height: 4),

                        Text(
                          'by ${a.community}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTheme()
                              .light(context)
                              .textTheme
                              .labelMedium
                              ?.copyWith(
                            color: const Color(0xFF1b1b1b).withOpacity(.7),
                            fontSize: 12,
                          ),
                        ),
                        const Spacer(),

                        Row(
                          children: [
                            AppIcons.calendar(
                              size: 16,
                              color: AppColors.secondary(context),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              widget.formatDate(a.startDate ?? DateTime.now()),
                              style: AppTheme()
                                  .light(context)
                                  .textTheme
                                  .headlineSmall
                                  ?.copyWith(fontSize: 14),
                            ),
                            const SizedBox(width: 12),
                            AppIcons.group_filled(
                              size: 14,
                              color: AppColors.secondary(context),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              participantsText,
                              style: AppTheme()
                                  .light(context)
                                  .textTheme
                                  .headlineSmall
                                  ?.copyWith(fontSize: 14),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
