// alerts and dialogs
import 'package:flutter/material.dart';

enum LoadingVisibility {
  inactive,
  active,
}

LoadingVisibility _loadingVisibility = LoadingVisibility.inactive;

void showLoading(BuildContext context, String message) {

  _loadingVisibility = LoadingVisibility.active;
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return Dialog(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(message),
              ),
            ],
          ),
        ),
      );
    },
  );
}

void dismissLoading(BuildContext context) {

  if (_loadingVisibility == LoadingVisibility.active)
    Navigator.pop(context);

  _loadingVisibility = LoadingVisibility.inactive;

}