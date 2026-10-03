import 'package:flutter/material.dart';

/// Custom right-to-left slide transition used for all forward navigation
/// in the booking flow, replacing the platform-default [MaterialPageRoute]
/// transition. Pair with [SlideBackRoute] semantics are handled
/// automatically by Navigator.pop (it reverses this same transition).
class SlidePageRoute<T> extends PageRouteBuilder<T> {
  final Widget page;

  SlidePageRoute({required this.page})
      : super(
          transitionDuration: const Duration(milliseconds: 320),
          reverseTransitionDuration: const Duration(milliseconds: 260),
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final slideIn = Tween<Offset>(
              begin: const Offset(1, 0),
              end: Offset.zero,
            ).chain(CurveTween(curve: Curves.easeOutCubic));

            final slideOut = Tween<Offset>(
              begin: Offset.zero,
              end: const Offset(-0.25, 0),
            ).chain(CurveTween(curve: Curves.easeOutCubic));

            return SlideTransition(
              position: secondaryAnimation.drive(slideOut),
              child: SlideTransition(
                position: animation.drive(slideIn),
                child: child,
              ),
            );
          },
        );
}

/// Fade+scale transition, used for terminal / replace navigation
/// (e.g. Login -> Home, Payment -> Confirmation) where a slide would
/// feel out of place.
class FadeScalePageRoute<T> extends PageRouteBuilder<T> {
  final Widget page;

  FadeScalePageRoute({required this.page})
      : super(
          transitionDuration: const Duration(milliseconds: 350),
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final curved = CurvedAnimation(parent: animation, curve: Curves.easeOut);
            return FadeTransition(
              opacity: curved,
              child: ScaleTransition(
                scale: Tween<double>(begin: 0.96, end: 1).animate(curved),
                child: child,
              ),
            );
          },
        );
}
