// Copyright 2015 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:synchronized/synchronized.dart';

// Examples can assume:
// enum Department { treasury, state }
// BuildContext context;

/// A material design dialog.
///
/// This dialog widget does not have any opinion about the contents of the
/// dialog. Rather than using this widget directly, consider using [AlertDialog]
/// or [SimpleDialog], which implement specific kinds of material design
/// dialogs.
///
/// See also:
///
///  * [AlertDialog], for dialogs that have a message and some buttons.
///  * [SimpleDialog], for dialogs that offer a variety of options.
///  * [showDialog], which actually displays the dialog and returns its result.
///  * <https://material.google.com/components/dialogs.html>
class DDSProgressDialog extends StatelessWidget {
  /// Creates a dialog.
  ///
  /// Typically used in conjunction with [showDialog].
  const DDSProgressDialog({
    Key key,
    this.child,
    this.insetAnimationDuration = const Duration(milliseconds: 100),
    this.insetAnimationCurve = Curves.decelerate,
    this.shape,
  }) : super(key: key);

  /// The widget below this widget in the tree.
  ///
  /// {@macro flutter.widgets.child}
  final Widget child;

  /// The duration of the animation to show when the system keyboard intrudes
  /// into the space that the dialog is placed in.
  ///
  /// Defaults to 100 milliseconds.
  final Duration insetAnimationDuration;

  /// The curve to use for the animation shown when the system keyboard intrudes
  /// into the space that the dialog is placed in.
  ///
  /// Defaults to [Curves.fastOutSlowIn].
  final Curve insetAnimationCurve;

  /// {@template flutter.material.dialog.shape}
  /// The shape of this dialog's border.
  ///
  /// Defines the dialog's [Material.shape].
  ///
  /// The default shape is a [RoundedRectangleBorder] with a radius of 2.0.
  /// {@endtemplate}
  final ShapeBorder shape;

  Color _getColor(BuildContext context) {
    return Colors.black; //Theme.of(context).dialogBackgroundColor;
  }

  static const RoundedRectangleBorder _defaultDialogShape =
      RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(4.0)));

  @override
  Widget build(BuildContext context) {
    final DialogTheme dialogTheme = DialogTheme.of(context);
    return WillPopScope(
        onWillPop: () => Future.value(false),
        child: AnimatedPadding(
          padding: MediaQuery.of(context).viewInsets +
              const EdgeInsets.symmetric(horizontal: 40.0, vertical: 24.0),
          duration: insetAnimationDuration,
          curve: insetAnimationCurve,
          child: MediaQuery.removeViewInsets(
            removeLeft: true,
            removeTop: true,
            removeRight: true,
            removeBottom: true,
            context: context,
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(),
                child: Material(
                  elevation: 24.0,
                  color: _getColor(context),
                  type: MaterialType.card,
                  child: child,
                  shape: shape ?? dialogTheme.shape ?? _defaultDialogShape,
                ),
              ),
            ),
          ),
        ));
  }
}

//the code below is writeen by Vikas and the above code is from existing material dialog library
class ProgressDialog {
  bool isDismissed = true;
  var lock = Lock();
  Timer _timer;
  Future<void> dismissProgressDialog(BuildContext context) async {
    _timer?.cancel();
    await lock.synchronized(() async {
      if (isDismissed) {
        // logData('progress already dismissed');
        return;
      }
      isDismissed = true;
      Navigator.of(context, rootNavigator: true).pop(true);
    });
  }

  void showProgressDialog(BuildContext context,
      {Color barrierColor = const Color(0x55222222),
      String textToBeDisplayed,
      Duration dismissAfter = const Duration(seconds: 5),
      Function onDismiss}) {
    dismissProgressDialog(context).then((_) {
      isDismissed = false;
      showGeneralDialog(
        context: context,
        barrierColor: barrierColor,
        pageBuilder: (context, animation1, animation2) {
          return DDSProgressDialog(
            child: Container(
                decoration: const BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.all(Radius.circular(5))),
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Platform.isIOS
                        ? CupertinoActivityIndicator(
                            radius: 15,
                          )
                        : CircularProgressIndicator(),
                    textToBeDisplayed == null
                        ? const Padding(
                            padding: EdgeInsets.all(0),
                          )
                        : Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Text(
                              textToBeDisplayed,
                              style: const TextStyle(
                                  fontFamily: 'AvenirLTStd-Roman',
                                  color: Colors.white),
                              textAlign: TextAlign.center,
                            ))
                  ],
                )),
          );
        },
        barrierDismissible: false,
        transitionDuration: const Duration(milliseconds: 100),
      ).then((dismissed) {
        isDismissed = dismissed;
      });
      if (dismissAfter == null) return;
      _timer = Timer(dismissAfter, () async {
        await dismissProgressDialog(context);
        if (onDismiss != null) onDismiss();
      });
    });
  }
}
