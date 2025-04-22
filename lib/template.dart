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
    // 先去掉路径前缀，只保留文件名部分
    String fileName = path.split('/').last;
    // 去掉文件名中的非法字符，按 . - _ 空格 分割
    List<String> parts = fileName
        .replaceAll(RegExp(r'[\s\-_@]+'), ' ')
        .replaceAll('.', ' ')
        .split(' ')
        .where((e) => e.isNotEmpty)
        .toList();

    // 第一个单词小写，后面每个单词首字母大写
    String camelCase = parts.asMap().entries.map((entry) {
      int idx = entry.key;
      String word = entry.value;
      if (idx == 0) {
        return word.toLowerCase();
      } else {
        return word[0].toUpperCase() + word.substring(1).toLowerCase();
      }
    }).join();

    // 如果路径中有子目录，加上目录名（同样驼峰处理）
    List<String> dirs = path.split('/')..removeLast();
    if (dirs.isNotEmpty) {
      String dirCamel = dirs.map((d) {
        List<String> dParts = d
            .replaceAll(RegExp(r'[\s\-_@]+'), ' ')
            .split(' ')
            .where((e) => e.isNotEmpty)
            .toList();
        return dParts.map((w) => w[0].toUpperCase() + w.substring(1).toLowerCase()).join();
      }).join();
      // 目录首字母小写
      if (dirCamel.isNotEmpty) {
        dirCamel = dirCamel[0].toLowerCase() + dirCamel.substring(1);
      }
      return dirCamel + camelCase;
    }
    return camelCase;
  }

  String toUppercaseFirstLetter(String str) {
    return '${str[0].toUpperCase()}${str.substring(1)}';
  }
}
