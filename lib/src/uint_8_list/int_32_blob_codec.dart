import 'dart:typed_data';

/// メモリ領域にある、連続した 32bit 整数を [Uint8List] として参照するためのクラス。
class Int32Blob {
  /// メモリ領域の、連続した 32bit 整数を [Uint8List] として参照
  final Uint8List data;

  Int32Blob.fromIntList(List<int> intList): data = intList.toInt32Blob();

  const Int32Blob._(this.data);

  /// 外部の [Uint8List] の生データを [Int32Blob] に当てはめるファクトリコンストラクタ
  ///
  /// インスタンス化前に、適切なデータであるかどうかのバリデーションを挟む。
  factory Int32Blob.fromUint8List(Uint8List data) {
    // インスタンス化の前にバリデーション（バイト長を検証）する
    if (data.length % 4 != 0) {
      throw FormatException(
        "[Int32Blob.fromUint8List] 連続した 32bit 整数データになっていません。",
      );
    }
    // バリデーションを終えてからインスタンス化する
    return Int32Blob._(data);
  }

  /// [Uint8List]（4バイト区切り）を List＜int＞ に変換する
  List<int> toIntList() {
    if (data.isEmpty) return <int>[];

    // Uint8List のメモリ領域を安全に Int32List として展開し、List<int> を生成する
    return Int32List.sublistView(data).toList();
  }
}

extension EncodeToInt32Blob on List<int> {
  /// List＜int＞ を最小サイズ（1要素4バイト）の [Uint8List] に変換する
  Uint8List toInt32Blob() {
    if (isEmpty) return Uint8List(0);

    // 連続した 32bit 整数用のメモリ領域 (ByteBuffer) を新規作成して値をコピーする
    final int32List = Int32List.fromList(this);
    // 生のメモリ領域（buffer）に 1 バイト単位（Uint8List）としてのビューを新しく作って返す
    return int32List.buffer.asUint8List(
      // 開始オフセットとバイト長を渡して、参照の範囲を明示する
      int32List.offsetInBytes,
      int32List.lengthInBytes,
    );
  }
}