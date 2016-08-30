import 'package:inline_assets/transformer.dart';
import 'package:test/test.dart';
import 'package:transformer_test/utils.dart';

void main() {
  group('GlslIncludeTransformer', () {
    testPhases('correctly substitutes an include with a relative URI', [
      [new InlineAssetTransformer()]
    ], {
      'a|lib/a.dart': 'void main() { var a = INLINE_ASSET("b/b.txt"); }',
      'a|lib/b/b.txt': 'test'
    }, {
      'a|lib/a.dart': 'void main() { var a = """test"""; }',
      'a|lib/b/b.txt': 'test'
    });
  });

  group('GlslIncludeTransformer', () {
    testPhases('correctly substitutes an include with a package URI', [
      [new InlineAssetTransformer()]
    ], {
      'a|lib/a.dart': 'void main() { var a = INLINE_ASSET("package:b/b.txt"); }',
      'b|lib/b.txt': 'test'
    }, {
      'a|lib/a.dart': 'void main() { var a = """test"""; }',
      'b|lib/b.txt': 'test'
    });
  });
}
