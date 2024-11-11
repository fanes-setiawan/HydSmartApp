/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: directives_ordering,unnecessary_import,implicit_dynamic_list_literal,deprecated_member_use

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart' as _svg;
import 'package:vector_graphics/vector_graphics.dart' as _vg;

class $AssetsIconsGen {
  const $AssetsIconsGen();

  /// File path: assets/icons/activity.svg
  SvgGenImage get activity => const SvgGenImage('assets/icons/activity.svg');

  /// File path: assets/icons/alert-triangle.svg
  SvgGenImage get alertTriangle =>
      const SvgGenImage('assets/icons/alert-triangle.svg');

  /// File path: assets/icons/bar-chart-2.svg
  SvgGenImage get barChart2 =>
      const SvgGenImage('assets/icons/bar-chart-2.svg');

  /// File path: assets/icons/box-wire.svg
  SvgGenImage get boxWire => const SvgGenImage('assets/icons/box-wire.svg');

  /// File path: assets/icons/box.svg
  SvgGenImage get box => const SvgGenImage('assets/icons/box.svg');

  /// File path: assets/icons/check-stamp-filled.svg
  SvgGenImage get checkStampFilled =>
      const SvgGenImage('assets/icons/check-stamp-filled.svg');

  /// File path: assets/icons/check-stamp.svg
  SvgGenImage get checkStamp =>
      const SvgGenImage('assets/icons/check-stamp.svg');

  /// File path: assets/icons/chevron-down.svg
  SvgGenImage get chevronDown =>
      const SvgGenImage('assets/icons/chevron-down.svg');

  /// File path: assets/icons/chevron-right.svg
  SvgGenImage get chevronRight =>
      const SvgGenImage('assets/icons/chevron-right.svg');

  /// File path: assets/icons/chevron-up.svg
  SvgGenImage get chevronUp => const SvgGenImage('assets/icons/chevron-up.svg');

  /// File path: assets/icons/clipboard.svg
  SvgGenImage get clipboard => const SvgGenImage('assets/icons/clipboard.svg');

  /// File path: assets/icons/clock.svg
  SvgGenImage get clock => const SvgGenImage('assets/icons/clock.svg');

  /// File path: assets/icons/fan-svgrepo-com.svg
  SvgGenImage get fanSvgrepoCom =>
      const SvgGenImage('assets/icons/fan-svgrepo-com.svg');

  /// File path: assets/icons/file-text.svg
  SvgGenImage get fileText => const SvgGenImage('assets/icons/file-text.svg');

  /// File path: assets/icons/fountain-14-svgrepo-com.svg
  SvgGenImage get fountain14SvgrepoCom =>
      const SvgGenImage('assets/icons/fountain-14-svgrepo-com.svg');

  /// File path: assets/icons/grid.svg
  SvgGenImage get grid => const SvgGenImage('assets/icons/grid.svg');

  /// File path: assets/icons/home.svg
  SvgGenImage get home => const SvgGenImage('assets/icons/home.svg');

  /// File path: assets/icons/info.svg
  SvgGenImage get info => const SvgGenImage('assets/icons/info.svg');

  /// File path: assets/icons/message-circle.svg
  SvgGenImage get messageCircle =>
      const SvgGenImage('assets/icons/message-circle.svg');

  /// File path: assets/icons/moon-filled.svg
  SvgGenImage get moonFilled =>
      const SvgGenImage('assets/icons/moon-filled.svg');

  /// File path: assets/icons/moon.svg
  SvgGenImage get moon => const SvgGenImage('assets/icons/moon.svg');

  /// File path: assets/icons/more-cirle (1).svg
  SvgGenImage get moreCirle1 =>
      const SvgGenImage('assets/icons/more-cirle (1).svg');

  /// File path: assets/icons/more-cirle.svg
  SvgGenImage get moreCirle => const SvgGenImage('assets/icons/more-cirle.svg');

  /// File path: assets/icons/pie-chart.svg
  SvgGenImage get pieChart => const SvgGenImage('assets/icons/pie-chart.svg');

  /// File path: assets/icons/server.svg
  SvgGenImage get server => const SvgGenImage('assets/icons/server.svg');

  /// File path: assets/icons/toggle-left.svg
  SvgGenImage get toggleLeft =>
      const SvgGenImage('assets/icons/toggle-left.svg');

  /// File path: assets/icons/toggle-right.svg
  SvgGenImage get toggleRight =>
      const SvgGenImage('assets/icons/toggle-right.svg');

  /// File path: assets/icons/trending-down-square.svg
  SvgGenImage get trendingDownSquare =>
      const SvgGenImage('assets/icons/trending-down-square.svg');

  /// File path: assets/icons/x-circle.svg
  SvgGenImage get xCircle => const SvgGenImage('assets/icons/x-circle.svg');

  /// File path: assets/icons/x-octagon.svg
  SvgGenImage get xOctagon => const SvgGenImage('assets/icons/x-octagon.svg');

  /// List of all assets
  List<SvgGenImage> get values => [
        activity,
        alertTriangle,
        barChart2,
        boxWire,
        box,
        checkStampFilled,
        checkStamp,
        chevronDown,
        chevronRight,
        chevronUp,
        clipboard,
        clock,
        fanSvgrepoCom,
        fileText,
        fountain14SvgrepoCom,
        grid,
        home,
        info,
        messageCircle,
        moonFilled,
        moon,
        moreCirle1,
        moreCirle,
        pieChart,
        server,
        toggleLeft,
        toggleRight,
        trendingDownSquare,
        xCircle,
        xOctagon
      ];
}

class Assets {
  Assets._();

  static const $AssetsIconsGen icons = $AssetsIconsGen();
}

class SvgGenImage {
  const SvgGenImage(
    this._assetName, {
    this.size,
    this.flavors = const {},
  }) : _isVecFormat = false;

  const SvgGenImage.vec(
    this._assetName, {
    this.size,
    this.flavors = const {},
  }) : _isVecFormat = true;

  final String _assetName;
  final Size? size;
  final Set<String> flavors;
  final bool _isVecFormat;

  _svg.SvgPicture svg({
    Key? key,
    bool matchTextDirection = false,
    AssetBundle? bundle,
    String? package,
    double? width,
    double? height,
    BoxFit fit = BoxFit.contain,
    AlignmentGeometry alignment = Alignment.center,
    bool allowDrawingOutsideViewBox = false,
    WidgetBuilder? placeholderBuilder,
    String? semanticsLabel,
    bool excludeFromSemantics = false,
    _svg.SvgTheme? theme,
    ColorFilter? colorFilter,
    Clip clipBehavior = Clip.hardEdge,
    @deprecated Color? color,
    @deprecated BlendMode colorBlendMode = BlendMode.srcIn,
    @deprecated bool cacheColorFilter = false,
  }) {
    final _svg.BytesLoader loader;
    if (_isVecFormat) {
      loader = _vg.AssetBytesLoader(
        _assetName,
        assetBundle: bundle,
        packageName: package,
      );
    } else {
      loader = _svg.SvgAssetLoader(
        _assetName,
        assetBundle: bundle,
        packageName: package,
        theme: theme,
      );
    }
    return _svg.SvgPicture(
      loader,
      key: key,
      matchTextDirection: matchTextDirection,
      width: width,
      height: height,
      fit: fit,
      alignment: alignment,
      allowDrawingOutsideViewBox: allowDrawingOutsideViewBox,
      placeholderBuilder: placeholderBuilder,
      semanticsLabel: semanticsLabel,
      excludeFromSemantics: excludeFromSemantics,
      colorFilter: colorFilter ??
          (color == null ? null : ColorFilter.mode(color, colorBlendMode)),
      clipBehavior: clipBehavior,
      cacheColorFilter: cacheColorFilter,
    );
  }

  String get path => _assetName;

  String get keyName => _assetName;
}
