/// Option keys for the optional basic-detail fields (lowercase API keys).
enum MaritalStatus {
  single('single'),
  married('married'),
  widowed('widowed'),
  divorced('divorced'),
  separated('separated');

  const MaritalStatus(this.apiValue);
  final String apiValue;
}

enum PrimaryLanguage {
  amharic('amharic'),
  afaanOromo('afaan_oromo'),
  tigrinya('tigrinya'),
  somali('somali'),
  afar('afar'),
  other('other');

  const PrimaryLanguage(this.apiValue);
  final String apiValue;
}
