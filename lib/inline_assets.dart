/// Provides a placeholder that will be replaced by the `inline_assets`
/// transformer.
library inline_assets;

/// Substitution target for the `inline_assets` transformer.
///
/// Will be replaced with the contents of [uri].
///
/// Throws an [UnsupportedError] if it was not processed by the `inline_assets`
/// transformer.
String INLINE_ASSET(String uri) {
  throw new UnsupportedError('Asset was not inlined. Did you add the '
      'inline_assets transformer to your pubspec.yaml?');
}
