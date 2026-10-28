
/// 2つの `int` の情報の組み合わせロジック
class Int32Packer {
  Int32Packer._();

  /// 32ビットの最大値の定義（バリデーション用）
  static const int _max32 = 2147483647;      //  (2^31) - 1

  /// 32ビットの最小値の定義（バリデーション用）
  static const int _min32 = -2147483648;     // -(2^31)

  /// 下位32ビットをくり抜くためのマスク（16進数で 0xFFFFFFFF）
  static const int _mask32 = 0xFFFFFFFF;

  /// 2つの32ビット整数を1つの64ビット整数に結合する
  /// [highValue] : 上位32ビットに配置する数値（-2147483648 〜 2147483647）
  /// [lowValue]  : 下位32ビットに配置する数値（-2147483648 〜 2147483647）
  static int pack(int highValue, int lowValue) {
    // 範囲チェック
    if (highValue < _min32 || highValue > _max32 || lowValue < _min32 || lowValue > _max32) {
      throw ArgumentError('値は32ビット符号あり整数の範囲内である必要があります（$_min32 から $_max32 まで）');
    }

    // highValue を32ビット左にシフトする
    // lowValue の下位32ビット分だけを安全にマスクして、論理和（|）で合体させる
    return (highValue << 32) | (lowValue & _mask32);
  }

  /// 結合された値から「上位32ビットの数値」を取り出す
  static int unpackHigh(int packedValue) {
    // 符号を維持したまま32ビット右にシフトする
    return packedValue >> 32;
  }

  /// 結合された値から「下位32ビットの数値」を取り出す
  static int unpackLow(int packedValue) {
    // 下位32ビットをマスクしてくり抜く（この時点では正の数として扱われる）
    int low = packedValue & _mask32;

    // 32ビット目が1の場合、負の数（補数表現）として正しく復元する処理
    // 32ビット符号あり整数として最上位ビットが1（0x80000000以上）なら負の数に変換
    if ((low & 0x80000000) != 0) {
      low -= 0x100000000; // 2^32 を引くことで符号反転
    }
    return low;
  }
}