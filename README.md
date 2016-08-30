# inline_assets.dart

Transformer that inlines asset files into Dart source files as strings.

[![Build Status](https://travis-ci.org/RSSchermer/inline_assets.dart.svg?branch=master)](https://travis-ci.org/RSSchermer/inline_assets.dart)

## Usage

Add the `inline_assets` transformer to the transformer list in your 
`pubspec.yaml`:

```yaml
transformers:
  - inline_assets
```

This transformer substitutes `INLINE_ASSET("uri")` placeholders with the 
contents of the asset they reference. The `uri` should be a valid Dart URI. It 
may be a relative URI or a `package:` URI:

```dart
// my_package|lib/my_lib.dart

// Import the INLINE_ASSET placeholder function
import 'package:inline_assets/inline_assets.dart';

// Will be set to the contents of my_package|lib/queries/my_query.sql
String query = INLINE_ASSET('package:my_package/queries/my_query.sql');

// Will be set to the contents of 3d|lib/shaders/some_shader.glsl
String shader = INLINE_ASSET('package:3d/shaders/some_shader.glsl');
```

Absolute URIs are not allowed.
