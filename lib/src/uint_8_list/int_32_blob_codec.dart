
import 'package:flutter/foundation.dart';

/// メモリ領域にある、連続した 32bit の整数（n 個の 4 bite）を
/// [Uint8List] （(4*n) 個の 1 bite）として参照できるリストクラス。
///
/// コンストラクタはデータのコピーを受け取り、各参照メソッドでデータのコピーを渡しているので、
/// このクラス自体は immutable 。
@immutable
class Int32Blob {
  /// 本体
  final Int32List _source;

  // todo コンストラクタ
  Int32Blob.fromIntList(List<int> intList): _source = intList.toInt32List();

  /// 外部の [Uint8List] の生データを [Int32Blob] に当てはめるファクトリコンストラクタ
  ///
  /// インスタンス化前に、適切なデータであるかどうかのバリデーションを挟む。
  Int32Blob.fromUint8List(Uint8List uint8List)  : _source = _applyUint8List(uint8List);

  @protected
  static Int32List _applyUint8List(Uint8List uint8List){
    // インスタンス化の前にバリデーション（バイト長を検証）する
    if (uint8List.offsetInBytes % 4 != 0 ||
        uint8List.lengthInBytes % 4 != 0) {
      throw FormatException(
        "[Int32Blob.fromUint8List] 連続した 32bit 整数データになっていません。",
      );
    }
    return Int32List.fromList(Int32List.sublistView(uint8List));
  }

  // todo 参照
  /// 本体のメモリ領域（n 個の 32 bit （ 4 bite ）整数）の、 [Uint8List]
  /// （(4*n) 個の 1 bite データ）としての参照
  Uint8List getAsUint8List() => Uint8List.fromList(
    Uint8List.sublistView(_source),
  );

  /// [Uint8List] （1 bite のデータ (4*n) 個）を `List<int>` （n 個の int データ）
  /// に変換する
  List<int> toIntList() {
    if (_source.isEmpty) return <int>[];
    // Uint8List のメモリ領域を安全に Int32List として展開し、List<int> を生成する
    return _source.toList();
  }
}

// class Int32Blob {
//   /// メモリ領域の、連続した 32bit （ 4 bite ）の整数を [Uint8List] として参照
//   final Uint8List _refAsUint8List;
//
//   /// メモリ領域の、連続した 32bit （ 4 bite ）の整数を [Uint8List] として参照
//   Uint8List get uint8List => _refAsUint8List;
//
//   Int32Blob.fromIntList(List<int> intList): _refAsUint8List = intList.toUint8List();
//
//   const Int32Blob._(this._refAsUint8List);
//
//   /// 外部の [Uint8List] の生データを [Int32Blob] に当てはめるファクトリコンストラクタ
//   ///
//   /// インスタンス化前に、適切なデータであるかどうかのバリデーションを挟む。
//   factory Int32Blob.fromUint8List(Uint8List uint8List) {
//     // インスタンス化の前にバリデーション（バイト長を検証）する
//     if (uint8List.length % 4 != 0) {
//       throw FormatException(
//         "[Int32Blob.fromUint8List] 連続した 32bit 整数データになっていません。",
//       );
//     }
//     // バリデーションを終えてからインスタンス化する
//     return Int32Blob._(uint8List);
//   }
//
//   /// [Uint8List] （1 bite のデータ (4*n) 個）を `List<int>` （n 個の int データ）
//   /// に変換する
//   List<int> toIntList() {
//     if (_refAsUint8List.isEmpty) return <int>[];
//
//     // Uint8List のメモリ領域を安全に Int32List として展開し、List<int> を生成する
//     return Int32List.sublistView(_refAsUint8List).toList();
//   }
// }

extension EncodeToInt32Blob on List<int> {

  /// [Int32List] に変換する
  Int32List toInt32List() {
    for (final value in this) {
      if (value < -2147483648 || value > 2147483647) {
        throw RangeError.range(
          value,
          -2147483648,
          2147483647,
          'value',
          '32bit符号付き整数の範囲を超えています。',
        );
      }
    }

    if (isEmpty) return Int32List(0);

    // 連続した 32bit 整数用のメモリ領域 (ByteBuffer) を新規作成して値をコピーする
    return Int32List.fromList(this);
  }

  // /// List＜int＞ を最小サイズ（1要素4バイト）の [Uint8List] に変換する
  // Uint8List toUint8List() {
  //   for (final value in this) {
  //     if (value < -2147483648 || value > 2147483647) {
  //       throw RangeError.range(
  //         value,
  //         -2147483648,
  //         2147483647,
  //         'value',
  //         '32bit符号付き整数の範囲を超えています。',
  //       );
  //     }
  //   }
  //
  //   if (isEmpty) return Uint8List(0);
  //
  //   // 連続した 32bit 整数用のメモリ領域 (ByteBuffer) を新規作成して値をコピーする
  //   final int32List = Int32List.fromList(this);
  //   // 生のメモリ領域（buffer）に 1 バイト単位（Uint8List）としてのビューを新しく作って返す
  //   return int32List.buffer.asUint8List(
  //     // 開始オフセットとバイト長を渡して、参照の範囲を明示する
  //     int32List.offsetInBytes,
  //     int32List.lengthInBytes,
  //   );
  // }
}