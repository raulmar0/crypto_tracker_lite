// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get appTitle => 'CryptoTracker Lite';

  @override
  String get home => '홈';

  @override
  String get favorites => '즐겨찾기';

  @override
  String get profile => '프로필';

  @override
  String get settings => '설정';

  @override
  String get myProfile => '내 프로필';

  @override
  String get name => '이름';

  @override
  String get email => '이메일';

  @override
  String get detail => '상세';

  @override
  String get currentPrice => '현재 가격';

  @override
  String get high24h => '24시간 최고가';

  @override
  String get low24h => '24시간 최저가';

  @override
  String get marketCap => '시가총액';

  @override
  String get volume24h => '24시간 거래량';

  @override
  String get priceHistory7d => '가격 이력 (7일)';

  @override
  String get about => '소개';

  @override
  String get noDescriptionAvailable => '설명이 없습니다.';

  @override
  String get chartStart => '시작';

  @override
  String get chartToday => '오늘';

  @override
  String get errorLoadingChart => '차트 로딩 오류';

  @override
  String get errorLoadingDescription => '설명 로딩 오류';

  @override
  String get noDataAvailable => '데이터 없음';

  @override
  String get rateLimitTitle => '요청 한도 초과.';

  @override
  String get rateLimitSubtitle => '재시도 중...';

  @override
  String get rateLimitDataUnavailable => '일부 데이터를 사용할 수 없습니다.';

  @override
  String get errorTitle => '문제가 발생했습니다 😢';

  @override
  String get errorMessage =>
      'CoinGecko API에 속도 제한이 있습니다. 잠시 후 \"다시 시도\"를 눌러주세요.';

  @override
  String get retry => '다시 시도';

  @override
  String get loadDataFirst => '먼저 데이터를 로드하세요';

  @override
  String get noFavoritesYet => '아직 즐겨찾기가 없습니다';

  @override
  String get language => '언어';

  @override
  String get spanish => '스페인어';

  @override
  String get english => '영어';

  @override
  String get french => '프랑스어';

  @override
  String get korean => '한국어';
}
