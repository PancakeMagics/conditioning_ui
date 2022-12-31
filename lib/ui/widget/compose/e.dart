part of compose;

class CustomError extends Error {
  final Object? error;
  @override
  final StackTrace? stackTrace;

  CustomError(this.error, {this.stackTrace});

  @override
  String toString() => error.toString();
}

class StreamError extends CustomError {
  StreamError(super.error, {super.stackTrace});
}

/// e for widget
class ScreenNotFoundError extends CustomError {
  ScreenNotFoundError(super.message);
}

class ScreenNotInGraphException implements Exception {}

/// e for material
class TemplateError extends Error {}
class AlignmentUnImplementsError extends Error {}
class DirectionUnImplementsError extends Error {}
class OverlayEntryNotExistError extends Error {}
class OverlayEntriesEmptyError extends Error {}
class PropertyNotProvideError extends Error {}
class MotivationNoWidgetError extends Error {}
class MotivationCurveConflictError extends CustomError {
  MotivationCurveConflictError() : super(
    "invalid to curve at both "
        "'Motivation' and 'AnimationControllerSetting'",
  );
}

/// e for custom usages
abstract class CoordinateError extends Error {}
class CoordinateUnImplementError extends CoordinateError {}
class CoordinateNotValidError extends CoordinateError {}
class GraphConfigurationNoValidationError extends CoordinateError {}
class CombinationUnImplementError extends Error {}
class PlanesMotivationNotMotivatableError extends CustomError {
  PlanesMotivationNotMotivatableError() : super(
    "invalid to motivate 'PlanesMotivation' without invoke 'motivate' method",
  );
}