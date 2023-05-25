import 'dart:io';

import 'package:flutter/material.dart';

import 'package:path_provider/path_provider.dart';
import 'package:mockingjae2_mobile/utils/colors.dart';

Text idTextParser({required String id, int maxLength = 20}) {
  if (id.length >= maxLength) {
    id = '${id.substring(0, 16)}...';
  }
  return Text(
    id,
    style: TextStyle(
        color: mainBackgroundColor,
        fontWeight: FontWeight.w400,
        decoration: TextDecoration.none,
        fontSize: 14.5),
  );
}

String numberParser({required int number}) {
  if (number < 1100) {
    return '$number';
  }
  return (number / 1000).toStringAsFixed(1) + 'k';
}

double fontSizeParser({required int length}) {
  if (length <= 2) {
    return 15;
  } else if (length <= 4) {
    return 13;
  } else if (length <= 6) {
    return 12;
  }
  return 11;
}

String parseRelativeTime(String dateTimeString) {
  DateTime dateTime = DateTime.parse(dateTimeString);
  DateTime now = DateTime.now();
  Duration timeDifference = now.difference(dateTime);

  if (timeDifference.inSeconds < 60) {
    return 'a moment ago';
  } else if (timeDifference.inMinutes < 60) {
    return '${timeDifference.inMinutes} min ago';
  } else if (timeDifference.inHours < 24) {
    if (timeDifference.inHours == 1) {
      return 'an hour ago';
    } else {
      return '${timeDifference.inHours} hours ago';
    }
  } else if (timeDifference.inDays == 1 && now.day - dateTime.day == 1) {
    return 'yesterday';
  } else if (timeDifference.inDays < 7) {
    return '${timeDifference.inDays} days ago';
  } else if (timeDifference.inDays < 14) {
    int weeks = (timeDifference.inDays / 7).floor();
    return '${weeks} week ago';
  } else if (timeDifference.inDays < 30) {
    int weeks = (timeDifference.inDays / 7).floor();
    return '${weeks} weeks ago';
  } else if (timeDifference.inDays < 60) {
    return 'a month ago';
  } else if (timeDifference.inDays < 365) {
    int months = (timeDifference.inDays / 30).floor();
    return '${months} months ago';
  } else if (timeDifference.inDays < 365 * 5) {
    int years = (timeDifference.inDays / 365).floor();
    return '${years} year${years > 1 ? 's' : ''} ago';
  } else {
    return 'several years ago';
  }
}
