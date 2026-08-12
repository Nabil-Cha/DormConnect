import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hci_mi5y_dormconnect/theme/icons.dart';

enum ActivityCategory {
  sports('Sports', 'Sports'),
  artsCulture('Arts & Culture', 'Arts'),
  academics('Academics & Learning', 'Academics'),
  foodDrink('Food & Drink', 'Food'),
  games('Games & Entertainment', 'Games'),
  wellbeing('Wellness & Lifestyle', 'Wellness'),
  community('Community & Networking', 'Community'),
  diy('DIY & Hobbies', 'DIY'),
  socials('Celebrations & Socials', 'Socials'),
  cultural('Cultural & International', 'Culture'),
  outdoors('Trips & Outdoors', 'Outdoors'),
  career('Career & Skills', 'Career');

  final String label;
  final String chipLabel;

  const ActivityCategory(this.label, this.chipLabel);

  SvgPicture getIcon({Color? color, double? size}) {
    switch (this) {
      case ActivityCategory.sports:
        return AppIcons.sports(color: color, size: size);
      case ActivityCategory.artsCulture:
        return AppIcons.arts(color: color, size: size);
      case ActivityCategory.academics:
        return AppIcons.academics(color: color, size: size);
      case ActivityCategory.foodDrink:
        return AppIcons.food(color: color, size: size);
      case ActivityCategory.games:
        return AppIcons.games(color: color, size: size);
      case ActivityCategory.wellbeing:
        return AppIcons.wellness(color: color, size: size);
      case ActivityCategory.community:
        return AppIcons.community(color: color, size: size);
      case ActivityCategory.diy:
        return AppIcons.diy(color: color, size: size);
      case ActivityCategory.socials:
        return AppIcons.socials(color: color, size: size);
      case ActivityCategory.cultural:
        return AppIcons.culture(color: color, size: size);
      case ActivityCategory.outdoors:
        return AppIcons.outdoors(color: color, size: size);
      case ActivityCategory.career:
        return AppIcons.career(color: color, size: size);
    }
  }
}

ActivityCategory activityFromCategory(String s) => ActivityCategory.values.firstWhere(
      (t) => t.label.toLowerCase() == s.toLowerCase(),
  orElse: () => ActivityCategory.values.first,
);