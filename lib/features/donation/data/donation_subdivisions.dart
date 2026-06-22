import 'donation_picker_option.dart';

/// US states and territories with USPS abbreviations.
const usStateOptions = <DonationPickerOption>[
  DonationPickerOption(value: 'AL', label: 'Alabama', keywords: ['AL']),
  DonationPickerOption(value: 'AK', label: 'Alaska', keywords: ['AK']),
  DonationPickerOption(value: 'AZ', label: 'Arizona', keywords: ['AZ']),
  DonationPickerOption(value: 'AR', label: 'Arkansas', keywords: ['AR']),
  DonationPickerOption(value: 'CA', label: 'California', keywords: ['CA', 'Calif']),
  DonationPickerOption(value: 'CO', label: 'Colorado', keywords: ['CO', 'Colo']),
  DonationPickerOption(value: 'CT', label: 'Connecticut', keywords: ['CT', 'Conn']),
  DonationPickerOption(value: 'DE', label: 'Delaware', keywords: ['DE', 'Del']),
  DonationPickerOption(value: 'DC', label: 'District of Columbia', keywords: ['DC', 'Washington DC']),
  DonationPickerOption(value: 'FL', label: 'Florida', keywords: ['FL', 'Fla']),
  DonationPickerOption(value: 'GA', label: 'Georgia', keywords: ['GA']),
  DonationPickerOption(value: 'HI', label: 'Hawaii', keywords: ['HI']),
  DonationPickerOption(value: 'ID', label: 'Idaho', keywords: ['ID']),
  DonationPickerOption(value: 'IL', label: 'Illinois', keywords: ['IL', 'Ill']),
  DonationPickerOption(value: 'IN', label: 'Indiana', keywords: ['IN', 'Ind']),
  DonationPickerOption(value: 'IA', label: 'Iowa', keywords: ['IA']),
  DonationPickerOption(value: 'KS', label: 'Kansas', keywords: ['KS', 'Kans']),
  DonationPickerOption(value: 'KY', label: 'Kentucky', keywords: ['KY']),
  DonationPickerOption(value: 'LA', label: 'Louisiana', keywords: ['LA']),
  DonationPickerOption(value: 'ME', label: 'Maine', keywords: ['ME']),
  DonationPickerOption(value: 'MD', label: 'Maryland', keywords: ['MD']),
  DonationPickerOption(value: 'MA', label: 'Massachusetts', keywords: ['MA', 'Mass']),
  DonationPickerOption(value: 'MI', label: 'Michigan', keywords: ['MI', 'Mich']),
  DonationPickerOption(value: 'MN', label: 'Minnesota', keywords: ['MN', 'Minn']),
  DonationPickerOption(value: 'MS', label: 'Mississippi', keywords: ['MS', 'Miss']),
  DonationPickerOption(value: 'MO', label: 'Missouri', keywords: ['MO']),
  DonationPickerOption(value: 'MT', label: 'Montana', keywords: ['MT', 'Mont']),
  DonationPickerOption(value: 'NE', label: 'Nebraska', keywords: ['NE', 'Nebr']),
  DonationPickerOption(value: 'NV', label: 'Nevada', keywords: ['NV', 'Nev']),
  DonationPickerOption(value: 'NH', label: 'New Hampshire', keywords: ['NH']),
  DonationPickerOption(value: 'NJ', label: 'New Jersey', keywords: ['NJ']),
  DonationPickerOption(value: 'NM', label: 'New Mexico', keywords: ['NM']),
  DonationPickerOption(value: 'NY', label: 'New York', keywords: ['NY']),
  DonationPickerOption(value: 'NC', label: 'North Carolina', keywords: ['NC', 'NC']),
  DonationPickerOption(value: 'ND', label: 'North Dakota', keywords: ['ND']),
  DonationPickerOption(value: 'OH', label: 'Ohio', keywords: ['OH']),
  DonationPickerOption(value: 'OK', label: 'Oklahoma', keywords: ['OK', 'Okla']),
  DonationPickerOption(value: 'OR', label: 'Oregon', keywords: ['OR', 'Ore']),
  DonationPickerOption(value: 'PA', label: 'Pennsylvania', keywords: ['PA', 'Penn']),
  DonationPickerOption(value: 'RI', label: 'Rhode Island', keywords: ['RI']),
  DonationPickerOption(value: 'SC', label: 'South Carolina', keywords: ['SC']),
  DonationPickerOption(value: 'SD', label: 'South Dakota', keywords: ['SD']),
  DonationPickerOption(value: 'TN', label: 'Tennessee', keywords: ['TN', 'Tenn']),
  DonationPickerOption(value: 'TX', label: 'Texas', keywords: ['TX', 'Tex']),
  DonationPickerOption(value: 'UT', label: 'Utah', keywords: ['UT']),
  DonationPickerOption(value: 'VT', label: 'Vermont', keywords: ['VT']),
  DonationPickerOption(value: 'VA', label: 'Virginia', keywords: ['VA']),
  DonationPickerOption(value: 'WA', label: 'Washington', keywords: ['WA', 'Wash']),
  DonationPickerOption(value: 'WV', label: 'West Virginia', keywords: ['WV', 'W Va']),
  DonationPickerOption(value: 'WI', label: 'Wisconsin', keywords: ['WI', 'Wis']),
  DonationPickerOption(value: 'WY', label: 'Wyoming', keywords: ['WY', 'Wyo']),
  DonationPickerOption(value: 'AS', label: 'American Samoa', keywords: ['AS']),
  DonationPickerOption(value: 'GU', label: 'Guam', keywords: ['GU']),
  DonationPickerOption(value: 'MP', label: 'Northern Mariana Islands', keywords: ['MP']),
  DonationPickerOption(value: 'PR', label: 'Puerto Rico', keywords: ['PR']),
  DonationPickerOption(value: 'VI', label: 'U.S. Virgin Islands', keywords: ['VI']),
];

/// Canadian provinces and territories with standard abbreviations.
const canadaProvinceOptions = <DonationPickerOption>[
  DonationPickerOption(value: 'AB', label: 'Alberta', keywords: ['AB', 'Alta']),
  DonationPickerOption(value: 'BC', label: 'British Columbia', keywords: ['BC']),
  DonationPickerOption(value: 'MB', label: 'Manitoba', keywords: ['MB', 'Man']),
  DonationPickerOption(value: 'NB', label: 'New Brunswick', keywords: ['NB']),
  DonationPickerOption(value: 'NL', label: 'Newfoundland and Labrador', keywords: ['NL', 'NF']),
  DonationPickerOption(value: 'NS', label: 'Nova Scotia', keywords: ['NS']),
  DonationPickerOption(value: 'NT', label: 'Northwest Territories', keywords: ['NT', 'NWT']),
  DonationPickerOption(value: 'NU', label: 'Nunavut', keywords: ['NU']),
  DonationPickerOption(value: 'ON', label: 'Ontario', keywords: ['ON', 'Ont']),
  DonationPickerOption(value: 'PE', label: 'Prince Edward Island', keywords: ['PE', 'PEI']),
  DonationPickerOption(value: 'QC', label: 'Quebec', keywords: ['QC', 'Que']),
  DonationPickerOption(value: 'SK', label: 'Saskatchewan', keywords: ['SK', 'Sask']),
  DonationPickerOption(value: 'YT', label: 'Yukon', keywords: ['YT', 'Yuk']),
];

List<DonationPickerOption> subdivisionOptionsForCountry(String countryCode) {
  switch (countryCode) {
    case 'US':
      return usStateOptions;
    case 'CA':
      return canadaProvinceOptions;
    default:
      return const [];
  }
}

bool countryUsesSearchableSubdivisions(String countryCode) =>
    countryCode == 'US' || countryCode == 'CA';

DonationPickerOption? subdivisionOptionByCode(
  String countryCode,
  String code,
) {
  for (final option in subdivisionOptionsForCountry(countryCode)) {
    if (option.value == code) {
      return option;
    }
  }
  return null;
}
