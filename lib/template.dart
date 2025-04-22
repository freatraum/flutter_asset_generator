import 'package:flutter_asset_generator_latest/config.dart';
import 'package:path/path.dart' as path_library;

import 'replace.dart';

class Template {
  Template(
    this.className,
    this.config,
  );

  final String className;
  final Config config;

  late final Replacer replacer = Replacer(config: config);

  String license = '''
/// Generate by [asset_generator](https://github.com/fluttercandies/flutter_asset_generator) library.
/// PLEASE DO NOT EDIT MANUALLY.
// ignore_for_file: constant_identifier_names\n''';

  String get classDeclare => '''
class $className {\n
  const $className._();\n''';

  String get classDeclareFooter => '}\n';

  String formatFiled(String path, String projectPath, bool isPreview) {
    if (isPreview) {
      return '''

  /// ![preview](file://$projectPath${path_library.separator}${_formatPreviewName(path)})
  static const String ${_formatFiledName(path)} = '$path';\n''';
    }
    return '''

  static const String ${_formatFiledName(path)} = '$path';\n''';
  }

  String _formatPreviewName(String path) {
    path = path.replaceAll(' ', '%20').replaceAll('/', path_library.separator);
    return path;
  }

  String _formatFiledName(String path) {
    // 先用 replacer 处理
    String replaced = replacer.replaceName(path);

    // 去掉最前面的下划线
    replaced = replaced.replaceFirst(RegExp(r'^_+'), '');

    // 按下划线分割，转为小驼峰
    List<String> parts = replaced.split('_').where((e) => e.isNotEmpty).toList();
    if (parts.isEmpty) return '';

    String camelCase = parts.first +
        parts.skip(1).map((s) => s.isNotEmpty ? s[0].toUpperCase() + s.substring(1) : '').join();

    return camelCase;
  }

  String toUppercaseFirstLetter(String str) {
    return '${str[0].toUpperCase()}${str.substring(1)}';
  }
}
