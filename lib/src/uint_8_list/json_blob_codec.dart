import 'dart:convert';

import 'package:flutter/foundation.dart';

/// Json文字列経由で 8 ビット固定長リストを保有するクラス
class JsonBlob {
  /// Json文字列経由で符号付き整数のリストから変換された 8 ビット固定長リスト
  final Uint8List data;

  JsonBlob.fromIntList(List<int> intList)
    : data = intList.toJsonBlob();

  const JsonBlob._(this.data);

  /// 外部の [Uint8List] の生データを [JsonBlob] に当てはめるファクトリコンストラクタ
  ///
  /// インスタンス化前に、適切なデータであるかどうかのバリデーションを挟む。
  factory JsonBlob.fromUint8List(Uint8List data) {
    if (data.isNotEmpty) {
      try {
        // UTF-8 デコードチェック
        final String jsonString = utf8.decode(data);
        // JSON パースチェック
        final dynamic decoded = json.decode(jsonString);
        // JSON 配列であるか、とすべての要素が int 型であるかの検証
        if (decoded is! List || !decoded.every((e) => e is int)) {
          throw const FormatException(
            "[JsonBlob.fromUint8List] データが整数の JSON 配列（List<int>）ではありません。",
          );
        }
      } catch (e, st) {
        throw FormatException(
          "[JsonBlob.fromUint8List] 有効な UTF-8 かつ整数の JSON 配列ではありません。\n$e\n$st",
        );
      }
    }
    return JsonBlob._(data);
  }

  /// 整数値の可変長リストに変換する
  ///  1. [utf8.decode]: 8ビットの符号なし整数（0から255までの数値）を JSON 文字列に変換する
  ///  2. [json.decode]: JSON 文字列を符号付き整数の可変長リストに変換する
  List<int> toIntList() {
    if (data.isEmpty) {
      return <int>[];
    } else {
      try {
        // JSON文字列としてデコードする
        final String jsonString = utf8.decode(data);
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
    return intList.toJsonBlob();
  }
}

extension EncodeToJsonBlob on List<int> {
  /// 8 ビット固定長リストに変換する
  ///  1. [json.encode]: JSON 文字列に変換する
  ///  2. [utf8.encode]: JSON 文字列を 8ビットの符号なし整数（0から255までの数値）に変換する
  Uint8List toJsonBlob() => Uint8List.fromList(utf8.encode(json.encode(this)));
}
