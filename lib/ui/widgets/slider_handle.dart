// Copyright 2020-2022 Ben Hills. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

class SliderHandle extends StatelessWidget {
  final double scrollPos;
  final EdgeInsets padding;

  const SliderHandle({
    this.scrollPos,
    this.padding,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ColorTween handleColor = ColorTween(
      begin: theme.bottomAppBarColor,
      end: theme.scaffoldBackgroundColor,
    );

    return Padding(
      padding: padding ?? const EdgeInsets.all(8.0),
      child: Container(
        width: 36,
        height: 4,
        decoration: BoxDecoration(
          color: scrollPos != null ? handleColor.animate(AlwaysStoppedAnimation(scrollPos)).value : Theme.of(context).hintColor,
          borderRadius: BorderRadius.all(Radius.circular(4.0)),
        ),
      ),
    );
  }
}
