import 'package:flutter/material.dart';
import '../Utils/SizingInformation.dart';
import '../Utils/UiUtils.dart';

class BaseWidget extends StatelessWidget {
  final Widget Function(
      BuildContext context, SizingInformation sizingInformation) builder;
  const BaseWidget({Key key, this.builder}) : super(key: key);

  @override
  // ignore: missing_return
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints boxConstraints) {
        var sizingInformation = SizingInformation(
            orientation: mediaQuery.orientation,
            deviceScreenType: getDeviceType(mediaQuery),
            screenSize: mediaQuery.size,
            localWidgetSize:
                Size(boxConstraints.maxWidth, boxConstraints.maxHeight));
        return builder(context, sizingInformation);
      },
    );
  }
}
