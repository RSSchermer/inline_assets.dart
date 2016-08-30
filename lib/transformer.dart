import 'dart:async';

import 'package:barback/barback.dart';
import 'package:code_transformers/messages/build_logger.dart';
import 'package:code_transformers/assets.dart';
import 'package:source_span/source_span.dart';

/// Substitutes `INLINE_ASSET("uri")` placeholders with the contents of the
/// asset they reference.
///
/// The `uri` should be a valid Dart URI. It may be a relative URI or a
/// `package:` URI:
///
///     // my_package|lib/my_lib.dart
///
///     // Import the INLINE_ASSET placeholder function
///     import 'package:inline_assets/inline_assets.dart';
///
///     // Will be set to the contents of my_package|lib/queries/my_query.sql
///     String query = INLINE_ASSET('package:my_package/queries/my_query.sql');
///
///     // Will be set to the contents of 3d|lib/shaders/some_shader.glsl
///     String shader = INLINE_ASSET('package:3d/shaders/some_shader.glsl');
///
/// Absolute URIs are not allowed.
class InlineAssetTransformer extends Transformer {
  final RegExp _pattern =
      new RegExp(r"""INLINE_ASSET\s*\(\s*["'](.*)\s*["']\)""", multiLine: true);

  InlineAssetTransformer();

  InlineAssetTransformer.asPlugin();

  String get allowedExtensions => '.dart';

  Future apply(Transform transform) async {
    final logger = new BuildLogger(transform);
    final contents = await transform.primaryInput.readAsString();
    final id = transform.primaryInput.id;

    // TODO: use proper Dart parser (dartanalyzer?) rather than regex?
    final newContents =
        await _replaceAllMappedAsync(contents, _pattern, (match) async {
      final sourceSpan =
          new SourceFile(contents, url: id.path).span(match.start, match.end);
      final assetId = uriToAssetId(id, match[1], logger, sourceSpan);

      if (!await transform.hasInput(assetId)) {
        logger.error('Could not find asset $assetId.', span: sourceSpan);

        return match[0];
      } else {
        final assetSource = await transform.readInputAsString(assetId);

        return '"""$assetSource"""';
      }
    });

    transform.addOutput(new Asset.fromString(id, newContents));
  }
}

Future<String> _replaceAllMappedAsync(
    String string, Pattern exp, Future<String> replace(Match match)) async {
  final replaced = new StringBuffer();
  var currentIndex = 0;

  for (var match in exp.allMatches(string)) {
    var prefix = match.input.substring(currentIndex, match.start);

    currentIndex = match.end;

    replaced..write(prefix)..write(await replace(match));
  }

  replaced.write(string.substring(currentIndex));

  return replaced.toString();
}
