import 'package:flutter/material.dart';
import '../../../constance.dart';

SelectIndexButton(select) {
  List<Color> selectColorButton;

  if (select == 0) {
    selectColorButton = [
      goldenSecondary,
      Colors.white,
      Colors.white,
      Colors.white,
      Colors.white,
    ];
  } else if (select == 1) {
    selectColorButton = [
      Colors.white,
      goldenSecondary,
      Colors.white,
      Colors.white,
      Colors.white,
    ];
  } else if (select == 2) {
    selectColorButton = [
      Colors.white,
      Colors.white,
      goldenSecondary,
      Colors.white,
      Colors.white,
    ];
  } else if (select == 3) {
    selectColorButton = [
      Colors.white,
      Colors.white,
      Colors.white,
      goldenSecondary,
      Colors.white,
    ];
  } else {
    selectColorButton = [
      Colors.white,
      Colors.white,
      Colors.white,
      Colors.white,
      goldenSecondary,
    ];
  }

  return selectColorButton;
}

SelectIndexElem(select) {
  List<Color> selectColorElem;

  if (select == 0) {
    selectColorElem = [
      Colors.white,
      goldenSecondary,
      goldenSecondary,
      goldenSecondary,
      goldenSecondary,
    ];
  } else if (select == 1) {
    selectColorElem = [
      goldenSecondary,
      Colors.white,
      goldenSecondary,
      goldenSecondary,
      goldenSecondary,
    ];
  } else if (select == 2) {
    selectColorElem = [
      goldenSecondary,
      goldenSecondary,
      Colors.white,
      goldenSecondary,
      goldenSecondary,
    ];
  } else if (select == 3) {
    selectColorElem = [
      goldenSecondary,
      goldenSecondary,
      goldenSecondary,
      Colors.white,
      goldenSecondary,
    ];
  } else {
    selectColorElem = [
      goldenSecondary,
      goldenSecondary,
      goldenSecondary,
      goldenSecondary,
      Colors.white,
    ];
  }

  return selectColorElem;
}
