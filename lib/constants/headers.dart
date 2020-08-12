class Headers {
  static const Map<String, String> loginHeaders = {
    'User-Agent':
        'Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:77.0) Gecko/20100101 Firefox/77.0',
    'Content-Type': 'application/x-www-form-urlencoded'
  };

  static Map<String, String> timetableHeaders(String cookie) {
    return {
      'User-Agent':
          'Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:77.0) Gecko/20100101 Firefox/77.0',
      'Content-Type': 'application/x-www-form-urlencoded',
      'X-Requested-With': 'XMLHttpRequest',
      'Origin': 'https://intranet.tam.ch',
      'Cookie': cookie
    };
  }
}
