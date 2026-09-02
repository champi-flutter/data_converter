import 'dart:convert';

import 'package:flutter/foundation.dart';

extension BlobCodec on Uint8List {
  /// 整数値の可変長リストに変換する
  ///  1. [utf8.decode]: 8ビットの符号なし整数（0から255までの数値）を JSON 文字列に変換する
  ///  2. [json.decode]: JSON 文字列を符号付き整数の可変長リストに変換する
  List<int> toIntList() {
    if (isEmpty) {
      return <int>[];
    } else {
      try {
        // JSON文字列としてデコードする
        final String jsonString = utf8.decode(this);
        // dart の List<int> に変換して返す
        return [...json.decode(jsonString) as List];
      } catch (e, st) {
        throw Exception("DECODE_ERROR: $e\n$st\n[Uint8List.toIntList]");
      }
    }
  }

  /// BLOB(`Uint8List`)に `int` （符号付き整数）を追加する
  ///
  /// **【注意】** void Function ではなく、新たなメモリを生成する。
  Uint8List updateWith(int value) {
    // 可変長リストとして参照する
    final List<int> intList = toIntList();
    // 新しい整数値を追加する
    intList.add(value);
    // Uint8List に変換して返す
    return intList.toUint8List();
  }
}

extension EncodeToUint8List on List<int> {
  /// 8 ビット固定長リストに変換する
  ///  1. [json.encode]: JSON 文字列に変換する
  ///  2. [utf8.encode]: JSON 文字列を 8ビットの符号なし整数（0から255までの数値）に変換する
  Uint8List toUint8List() => Uint8List.fromList(utf8.encode(json.encode(this)));
}
