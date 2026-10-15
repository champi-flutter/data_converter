import 'package:custom_core_types/custom_core_types.dart';

extension DateTimeToIntIdentifier on DateTime{
  /// int 型の識別子に変換 `YYYYMMDD`
  int toIntIdentifier(){
    return year * 10000 + month * 100 + day;
  }
}

extension DateToIntIdentifier on Date{
  /// int 型の識別子に変換 `YYYYMMDD`
  int toIntIdentifier(){
    return year * 10000 + month * 100 + day;
  }
}

extension MonthToIntIdentifier on Month{
  /// int 型の識別子に変換 `YYYYMMDD`
  int toIntIdentifier(){
    return year * 100 + month;
  }
}

extension IntIdentifierToDateType on int{
  /// int 型の識別子（ YYYYMMDD ）を Date に変換
  Date toDate (){
    // 西暦 1000 年未満は無効
    assert(this > 10000000, "この int は日付に変換できません。");
    // 10000 で割った商が year （余り切り捨て）
    final int year = this ~/ 10000;
    // year を省いた残りの部分
    final int residue = this % 10000;
    assert(residue < 1232, "この int は日付に変換できません。");
    // 残りを 100 で割った商が month （余り切り捨て）
    final int month = residue ~/ 100;
    // year と month を省いた残りの部分が day
    final int day = residue % 100;
    assert(day < 32, "この int は日付に変換できません。");
    return Date(year, month, day);
  }

  /// int 型の識別子（ YYYYMMDD ）を [Month] に変換
  Month toMonth (){
    // 西暦 1000 年以下は無効
    assert(this > 100000, "この int は月に変換できません。");
    // 100 で割った商が year （余り切り捨て）
    final int year = this ~/ 100;
    // year を省いた残りの部分
    final int residue = this % 100;
    // "12" 月まで
    assert(residue <= 12, "この int は月に変換できません。");
    return Month(year, residue);
  }
}
