import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SegmentedToggle extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const SegmentedToggle({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: const Color(0xFF151515),
        borderRadius: BorderRadius.circular(50.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () => onChanged(true),
            child: Container(
              width: 140.w,
              padding: EdgeInsets.symmetric(vertical: 10.h),
              decoration: BoxDecoration(
                color: value ? const Color(0xFF39D2B4) : Colors.transparent,
                borderRadius: BorderRadius.circular(50.r),
              ),
              alignment: Alignment.center,
              child: Text(
                'Login',
                style: TextStyle(
                  color: value ? Colors.black : Colors.white70,
                  fontSize: 14.sp,
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () => onChanged(false),
            child: Container(
              width: 140.w,
              padding: EdgeInsets.symmetric(vertical: 10.h),
              decoration: BoxDecoration(
                color: !value ? const Color(0xFF39D2B4) : Colors.transparent,
                borderRadius: BorderRadius.circular(50.r),
              ),
              alignment: Alignment.center,
              child: Text(
                'Sign Up',
                style: TextStyle(
                  color: !value ? Colors.black : Colors.white70,
                  fontSize: 14.sp,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
