import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../env.dart';
import '../../utils/dimensions.dart';
import '../../utils/theme/theme_styles.dart';
import '../../utils/token_manager.dart';

class ApiImageLoader extends StatelessWidget {
  final String? imageFilename;
  final double? height;
  final double? width;
  final BoxFit? boxFit;
  final bool isCircular;

  const ApiImageLoader({
    super.key,
    required this.imageFilename,
    this.height,
    this.width,
    this.boxFit,
    this.isCircular = false,
  });

  @override
  Widget build(BuildContext context) {
    return imageFilename != null
        ? CachedNetworkImage(
            key: Key(imageFilename.toString()),
            height: height,
            width: width,
            cacheKey: imageFilename.toString(),
            imageUrl: "$imagesUrl/$imageFilename",
            httpHeaders: {
              "Authorization": "Bearer ${(TokenManager.storedToken)}"
            },
            imageBuilder: (context, imageProvider) {
              return isCircular
                  ? CircleAvatar(backgroundImage: imageProvider)
                  : Image(image: imageProvider, fit: boxFit);
            },
            progressIndicatorBuilder: (context, url, progress) {
              return Center(
                child: CircularProgressIndicator(
                  color: Styles.primaryColor,
                ),
              );
            },
            errorWidget: (context, url, error) {
              return _buildErrorWidget(
                height: height,
                width: width,
                isCircular: isCircular,
              );
            },
          )
        : _buildNoImageWidget(
            height: height,
            width: width,
            isCircular: isCircular,
          );
  }

  static Widget _buildErrorWidget({
    double? height,
    double? width,
    bool isCircular = false,
  }) {
    return SizedBox(
      height: height,
      width: width,
      child: isCircular
          ? const CircleAvatar(
              backgroundImage: AssetImage("assets/images/no-profile-pic.png"),
            )
          : Container(
              decoration: BoxDecoration(
                color: darkColor.withOpacity(0.6),
                borderRadius: Dimensions.roundedBorderMedium,
              ),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.broken_image_outlined,
                    color: lightColor,
                    size: 60,
                  ),
                  Text(
                    "Couldn't load image",
                    style: TextStyle(color: lightColor),
                  )
                ],
              ),
            ),
    );
  }

  static Widget _buildNoImageWidget({
    double? height,
    double? width,
    bool isCircular = false,
  }) {
    return SizedBox(
      height: height,
      width: width,
      child: isCircular
          ? const CircleAvatar(
              backgroundImage: AssetImage("assets/images/no-profile-pic.png"),
            )
          : Container(
              decoration: BoxDecoration(
                color: darkColor.withOpacity(0.6),
                borderRadius: Dimensions.roundedBorderMedium,
              ),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.image_outlined,
                    color: lightColor,
                    size: 60,
                  ),
                  Text(
                    "No image",
                    style: TextStyle(color: lightColor),
                  )
                ],
              ),
            ),
    );
  }
}
