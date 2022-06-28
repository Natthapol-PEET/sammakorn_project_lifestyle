import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import '../../../constance.dart';

RxList selectIndexButton(select) {
  RxList<dynamic> selectColorButton = [].obs;

  if (select == 0) {
    selectColorButton.assignAll([
      goldenSecondary,
      Colors.white,
      Colors.white,
      Colors.white,
    ]);
  } else if (select == 1) {
    selectColorButton.assignAll([
      Colors.white,
      goldenSecondary,
      Colors.white,
      Colors.white,
    ]);
  } else if (select == 2) {
    selectColorButton.assignAll([
      Colors.white,
      Colors.white,
      goldenSecondary,
      Colors.white,
    ]);
  } else {
    selectColorButton.assignAll([
      Colors.white,
      Colors.white,
      Colors.white,
      goldenSecondary,
    ]);
  }

  return selectColorButton;
}

RxList selectIndexElem(select) {
  RxList<dynamic> selectColorElem = [].obs;

  if (select == 0) {
    selectColorElem.assignAll([
      Colors.white,
      goldenSecondary,
      goldenSecondary,
      goldenSecondary,
    ]);
  } else if (select == 1) {
    selectColorElem.assignAll([
      goldenSecondary,
      Colors.white,
      goldenSecondary,
      goldenSecondary,
    ]);
  } else if (select == 2) {
    selectColorElem.assignAll([
      goldenSecondary,
      goldenSecondary,
      Colors.white,
      goldenSecondary,
    ]);
  } else {
    selectColorElem.assignAll([
      goldenSecondary,
      goldenSecondary,
      goldenSecondary,
      Colors.white,
    ]);
  }

  return selectColorElem;
}
