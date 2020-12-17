class Strings {
  static const List<String> weekDays = ["Mo", "Di", "Mi", "Do", "Fr"];
  static const Map<String, String> schoolNames = {
    'kme': "Kantonale Maturitätsschule für Erwachsene",
    'kbw': "Kantonsschule Büelrain",
    'ken': "Kantonsschule Enge",
    'kfr': "Kantonsschule Freudenberg/Liceo",
    'khp': "Kantonsschule Hohe Promenade",
    'ksh': "Kantonsschule Hottingen",
    'klw': "Kantonsschule Im Lee",
    'kkn': "Kantonsschule Küsnacht",
    'ksl': "Kantonsschule Limmattal",
    'krw': "Kantonsschule Rychenberg",
    'kst': "Kantonsschule Stadelhofen",
    'kue': "Kantonsschule Uetikon am See",
    'kus': "Kantonsschule Uster",
    'kwi': "Kantonsschule Wiedikon",
    'kzi': "Kantonsschule Zimmerberg",
    'kzo': "Kantonsschule Zürcher Oberland",
    'kzu': "Kantonsschule Zürcher Unterland",
    'kzn': "Kantonsschule Zürich Nord",
    'krl': "Literargymnasium Rämibühl",
    'krm': "Math.-Naturw. Gymnasium Rämibühl",
    'krr': "Realgymnasium Rämibühl",
    'slk': "Schulleiterkonferenz",
  };

  static Map<String, String> headers(String cookie) {
    return {
      'User-Agent':
          'Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:77.0) Gecko/20100101 Firefox/77.0',
      'Content-Type': 'application/x-www-form-urlencoded',
      'X-Requested-With': 'XMLHttpRequest',
      'Referer': 'https://intranet.tam.ch/kfr/calendar',
      'Cookie': cookie
    };
  }
}
