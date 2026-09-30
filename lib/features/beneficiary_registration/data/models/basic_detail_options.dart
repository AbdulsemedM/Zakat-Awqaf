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
