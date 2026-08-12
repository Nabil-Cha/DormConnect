import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';

class AppIcons {
  static SvgPicture calendar({Color? color, double? size}) =>
      SvgPicture.asset(
        'assets/icons/calendar.svg',
        colorFilter: color != null ? ColorFilter.mode(color, BlendMode.srcIn) : null,
        height: size,
      );

  static SvgPicture location({Color? color, double? size}) =>
      SvgPicture.asset(
        'assets/icons/location.svg',
        colorFilter: color != null ? ColorFilter.mode(color, BlendMode.srcIn) : null,
        height: size,
      );

  static SvgPicture heart({Color? color, double? size}) =>
      SvgPicture.asset(
        'assets/icons/heart.svg',
        colorFilter: color != null ? ColorFilter.mode(color, BlendMode.srcIn) : null,
        height: size,
      );

  static SvgPicture search({Color? color, double? size}) =>
      SvgPicture.asset(
        'assets/icons/search.svg',
        colorFilter: color != null ? ColorFilter.mode(color, BlendMode.srcIn) : null,
        height: size,
      );

  static SvgPicture explore_hollow({Color? color, double? size}) =>
      SvgPicture.asset(
        'assets/icons/navigation_bar/explore_hollow.svg',
        colorFilter: color != null ? ColorFilter.mode(color, BlendMode.srcIn) : null,
        height: size,
      );

  static SvgPicture explore_filled({Color? color, double? size}) =>
      SvgPicture.asset(
        'assets/icons/navigation_bar/explore_filled.svg',
        colorFilter: color != null ? ColorFilter.mode(color, BlendMode.srcIn) : null,
        height: size,
      );

  static SvgPicture person_hollow({Color? color, double? size}) =>
      SvgPicture.asset(
        'assets/icons/navigation_bar/person_hollow.svg',
        colorFilter: color != null ? ColorFilter.mode(color, BlendMode.srcIn) : null,
        height: size,
      );
  static SvgPicture person_filled({Color? color, double? size}) =>
      SvgPicture.asset(
        'assets/icons/navigation_bar/person_filled.svg',
        colorFilter: color != null ? ColorFilter.mode(color, BlendMode.srcIn) : null,
        height: size,
      );

  static SvgPicture group_hollow({Color? color, double? size}) =>
      SvgPicture.asset(
        'assets/icons/navigation_bar/group_hollow.svg',
        colorFilter: color != null ? ColorFilter.mode(color, BlendMode.srcIn) : null,
        height: size,
      );

  static SvgPicture group_filled({Color? color, double? size}) =>
      SvgPicture.asset(
        'assets/icons/navigation_bar/group_filled.svg',
        colorFilter: color != null ? ColorFilter.mode(color, BlendMode.srcIn) : null,
        height: size,
      );

  static SvgPicture event({Color? color, double? size}) =>
      SvgPicture.asset(
        'assets/icons/event.svg',
        colorFilter: color != null ? ColorFilter.mode(color, BlendMode.srcIn) : null,
        height: size,
      );

  static SvgPicture home_hollow({Color? color, double? size}) =>
      SvgPicture.asset(
        'assets/icons/navigation_bar/home_hollow.svg',
        colorFilter: color != null ? ColorFilter.mode(color, BlendMode.srcIn) : null,
        height: size,
      );

  static SvgPicture home_filled({Color? color, double? size}) =>
      SvgPicture.asset(
        'assets/icons/navigation_bar/home_filled.svg',
        colorFilter: color != null ? ColorFilter.mode(color, BlendMode.srcIn) : null,
        height: size,
      );

  // Category Icons
  static SvgPicture academics({Color? color, double? size}) =>
      SvgPicture.asset(
        'assets/icons/categories/academics.svg',
        colorFilter: color != null ? ColorFilter.mode(color, BlendMode.srcIn) : null,
        height: size,
      );

  static SvgPicture arts({Color? color, double? size}) =>
      SvgPicture.asset(
        'assets/icons/categories/arts.svg',
        colorFilter: color != null ? ColorFilter.mode(color, BlendMode.srcIn) : null,
        height: size,
      );

  static SvgPicture career({Color? color, double? size}) =>
      SvgPicture.asset(
        'assets/icons/categories/career.svg',
        colorFilter: color != null ? ColorFilter.mode(color, BlendMode.srcIn) : null,
        height: size,
      );

  static SvgPicture community({Color? color, double? size}) =>
      SvgPicture.asset(
        'assets/icons/categories/community.svg',
        colorFilter: color != null ? ColorFilter.mode(color, BlendMode.srcIn) : null,
        height: size,
      );

  static SvgPicture culture({Color? color, double? size}) =>
      SvgPicture.asset(
        'assets/icons/categories/culture.svg',
        colorFilter: color != null ? ColorFilter.mode(color, BlendMode.srcIn) : null,
        height: size,
      );

  static SvgPicture diy({Color? color, double? size}) =>
      SvgPicture.asset(
        'assets/icons/categories/diy.svg',
        colorFilter: color != null ? ColorFilter.mode(color, BlendMode.srcIn) : null,
        height: size,
      );

  static SvgPicture food({Color? color, double? size}) =>
      SvgPicture.asset(
        'assets/icons/categories/food.svg',
        colorFilter: color != null ? ColorFilter.mode(color, BlendMode.srcIn) : null,
        height: size,
      );

  static SvgPicture games({Color? color, double? size}) =>
      SvgPicture.asset(
        'assets/icons/categories/games.svg',
        colorFilter: color != null ? ColorFilter.mode(color, BlendMode.srcIn) : null,
        height: size,
      );

  static SvgPicture outdoors({Color? color, double? size}) =>
      SvgPicture.asset(
        'assets/icons/categories/outdoors.svg',
        colorFilter: color != null ? ColorFilter.mode(color, BlendMode.srcIn) : null,
        height: size,
      );

  static SvgPicture socials({Color? color, double? size}) =>
      SvgPicture.asset(
        'assets/icons/categories/socials.svg',
        colorFilter: color != null ? ColorFilter.mode(color, BlendMode.srcIn) : null,
        height: size,
      );

  static SvgPicture sports({Color? color, double? size}) =>
      SvgPicture.asset(
        'assets/icons/categories/sports.svg',
        colorFilter: color != null ? ColorFilter.mode(color, BlendMode.srcIn) : null,
        height: size,
      );

  static SvgPicture wellness({Color? color, double? size}) =>
      SvgPicture.asset(
        'assets/icons/categories/wellness.svg',
        colorFilter: color != null ? ColorFilter.mode(color, BlendMode.srcIn) : null,
        height: size,
      );
}
