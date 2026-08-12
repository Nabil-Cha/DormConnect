import 'package:flutter/material.dart';

const double _kBaseWidth  = 375.0;
const double _kBaseHeight = 813.0;

double duW(BuildContext ctx, double px) =>
    MediaQuery.of(ctx).size.width / _kBaseWidth * px;

double duH(BuildContext ctx, double px) =>
    MediaQuery.of(ctx).size.height / _kBaseHeight * px;