/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

import 'package:flutter/widgets.dart';

class $AssetsConfigsGen {
  const $AssetsConfigsGen();

  String get config => 'assets/configs/config.yaml';
}

class $AssetsImagesGen {
  const $AssetsImagesGen();

  $AssetsImagesLoginGen get login => const $AssetsImagesLoginGen();
  $AssetsImagesLogoGen get logo => const $AssetsImagesLogoGen();
}

class $AssetsImagesLoginGen {
  const $AssetsImagesLoginGen();

  AssetGenImage get wlb => const AssetGenImage('assets/images/login/wlb.png');
}

class $AssetsImagesLogoGen {
  const $AssetsImagesLogoGen();

  AssetGenImage get logo => const AssetGenImage('assets/images/logo/logo.png');
}

class Assets {
  Assets._();

  static const $AssetsConfigsGen configs = $AssetsConfigsGen();
  static const $AssetsImagesGen images = $AssetsImagesGen();
}

class AssetGenImage extends AssetImage {
  const AssetGenImage(String assetName) : super(assetName);

  Image image({
    Key? key,
    ImageFrameBuilder? frameBuilder,
    ImageLoadingBuilder? loadingBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? width,
    double? height,
    Color? color,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = false,
    bool isAntiAlias = false,
    FilterQuality filterQuality = FilterQuality.low,
  }) {
    return Image(
      key: key,
      image: this,
      frameBuilder: frameBuilder,
      loadingBuilder: loadingBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      width: width,
      height: height,
      color: color,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      filterQuality: filterQuality,
    );
  }

  String get path => assetName;
}
