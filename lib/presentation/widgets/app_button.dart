import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../utils/app_radius.dart';
import '../themes/colors.dart';

class AppButton extends StatelessWidget {
  final String text;
  final double width;
  final bool isLoading;
  final bool secondButton;
  final bool isSelectedButton;
  final Color? color;
  final VoidCallback onClick;
  final bool isDisable;
  final double? borderRadius;

  const AppButton({
    Key? key,
    required this.text,
    required this.width,
    this.isLoading = false,
    this.secondButton = false,
    this.isSelectedButton = false,
    this.color,
    required this.onClick,
    this.isDisable = false,
    this.borderRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final responsive = size.height > 600;
    return MaterialButton(
      padding: EdgeInsets.zero,
      onPressed: isLoading || isDisable ? () {} : onClick,
      color: secondButton
          ? color!.withOpacity(!isLoading ? 1 : 0.2)
          : isLoading || isDisable
              ? Colors.orange.shade200
              : const Color(AppColors.primaryColor),
      minWidth: width,
      height: responsive ? 40 : 30,
      shape: secondButton && isSelectedButton
          ? RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                borderRadius ?? AppBorderRadius.borderRadius,
              ),
            )
          : secondButton
              ? RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    borderRadius ?? AppBorderRadius.borderRadius,
                  ),
                  side: const BorderSide(
                    color: Color(AppColors.primaryColor),
                    width: 1,
                  ),
                )
              : RoundedRectangleBorder(
                  borderRadius: !secondButton
                      ? BorderRadius.circular(
                          borderRadius ?? AppBorderRadius.borderRadius,
                        )
                      : BorderRadius.circular(0),
                ),
      child: isLoading
          ? const CupertinoActivityIndicator()
          : Text(
              text,
              style: TextStyle(
                color: secondButton && isSelectedButton
                    ? Colors.white
                    : secondButton
                        ? const Color(AppColors.primaryColor)
                        : Colors.white,
                fontSize: responsive ? 14 : 12,
              ),
            ),
    );
  }
}
