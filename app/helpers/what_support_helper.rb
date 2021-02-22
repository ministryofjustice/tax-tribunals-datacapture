# rubocop:disable Metrics/ModuleLength
# rubocop:disable Metrics/MethodLength
module WhatSupportHelper
  def languages
    [
      'Acholi',
      'Afrikaans',
      'Akan',
      'Albanian',
      'Algerian',
      'Amharic',
      'Arabic',
      'Arabic (Middle Eastern)',
      'Arabic (North African)',
      'Armenian',
      'Ashanti',
      'Assyrian',
      'Ateso',
      'Azari',
      'Azerbajani (aka Nth Azari)',
      'Bajan (West Indian)',
      'Bajuni',
      'Baluchi',
      'Bambara',
      'Banjuni',
      'Bardini',
      'Bassa',
      'Belorussian',
      'Benba (Bemba)',
      'Bengali',
      'Bengali (Sylheti)',
      'Benin/Edo',
      'Berber',
      'Bharuchi',
      'Bhutanese',
      'Bihari',
      'Bilin',
      'Bravanese',
      'Brong',
      'Bulgarian',
      'Burmese',
      'Cambellpuri',
      'Cantonese',
      'Cebuano',
      'Chechen',
      'Chichewa',
      'Chittagonain',
      'Creole (English)',
      'Creole (French)',
      'Creole (Portuguese)',
      'Creole (Spanish)',
      'Czech',
      'Danish',
      'Dari',
      'Dinka',
      'Dioula',
      'Douala',
      'Dutch',
      'Edo/Benin',
      'Efik',
      'Emakhuna',
      'Estonian',
      'Ewe',
      'Ewondo',
      'Fanti',
      'Farsi',
      'Feili',
      'Fijian',
      'Flemish',
      'French',
      'French (Arabic)',
      'French(African)',
      'Fula',
      'Ga',
      'Gallacian',
      'Georgian',
      'German',
      'Gorani',
      'Greek',
      'Gujarati',
      'Gurage',
      'Guran',
      'Hakka',
      'Hausa',
      'Hebrew',
      'Hendko',
      'Herero',
      'Hindi',
      'Hindko',
      'Hokkien',
      'Hungarian',
      'Ibibio',
      'Igbo (Also Known As Ibo)',
      'Ilocano',
      'Indonesian',
      'Ishan',
      'Isoko',
      'Italian',
      'Jamaican',
      'Japanese',
      'Javanese',
      'Kachi',
      'Karaninka',
      'Kashmiri',
      'Khalanga',
      'Khmer',
      'Khymer Khymer',
      'Kibajuni,Kibanjuni,Bajuni,Ban',
      'Kibanjuni',
      'Kichagga',
      'Kikongo',
      'Kikuyu',
      'Kinyarwandan',
      'Kirundi',
      'Kisakata',
      'Kiswahili',
      'Konkani',
      'Korean',
      'Krio (Sierra Leone)',
      'Kru',
      'Kurdish (Bardini)',
      'Kurdish (Kurmanji)',
      'Kurdish (Sorani)',
      'Kutchi',
      'Kyrgyz',
      'Lango',
      'Latvian',
      'Lingala',
      'Lithuanian',
      'Luba (Tshiluba)',
      'Lugandan',
      'Lugisa',
      'Lunyankole',
      'Luo',
      'Luo (Kenyan)',
      'Luo (Ugandan[Acholi District])',
      'Luo (Ugandan[Lango District])',
      'Lusoga',
      'Lutoro',
      'Macedonian',
      'Maghreb',
      'Malay',
      'Malayalam',
      'Maldivian',
      'Malinke',
      'Maltese',
      'Mandarin',
      'Mandinka',
      'Marathi',
      'Mende',
      'Mina',
      'Mirpuri',
      'Moldovan',
      'Mongolian',
      'Monokutuba',
      'Navsari',
      'Ndebele',
      'Nepali',
      'Ngwa',
      'Norwegian',
      'Nzima',
      'Oromo',
      'Pahari',
      'Pampangan',
      'Pangasinan',
      'Pathwari',
      'Patois',
      'Pidgin English',
      'Polish',
      'Portuguese',
      'Pothohari',
      'Punjabi',
      'Punjabi (Indian)',
      'Punjabi (Pakistani)',
      'Pushtu (Also Known As Pashto)',
      'Putonghue',
      'Roma',
      'Romanian',
      'Romany',
      'Rukiga',
      'Runyoro',
      'Russian',
      'Rutoro',
      'Sarahuleh',
      'Saraiki (Seraiki)',
      'Sarpo',
      'Senegal (French) Olof Dialect',
      'Senegal (Wolof)',
      'Serbo‑Croatian',
      'Setswana',
      'Shina',
      'Shona',
      'Sindhi',
      'Sinhalese',
      'Slovak',
      'Slovenian',
      'Somali',
      'Spanish',
      'Susu',
      'Swahili',
      'Swedish',
      'Sylheti',
      'Tagalog',
      'Taiwanese',
      'Tamil',
      'Telugu',
      'Temne',
      'Thai',
      'Tibetan',
      'Tigre',
      'Tigrinya',
      'Toura',
      'Training',
      'Turkish',
      'Turkmen',
      'Twi',
      'Uighur',
      'Ukrainian',
      'Urdu',
      'Urohobo',
      'Uzbek',
      'Vietnamese',
      'Visayan',
      'Welsh',
      'Wolof',
      'Xhosa',
      'Yoruba',
      'Zaghawa',
      'Zaza',
      'Zulu'
    ]
  end
  # rubocop:enable Metrics/MethodLength

  def sign_languages
    [
      'American Sign Language (ASL)',
      'British Sign Language (BSL)',
      'Hands on signing',
      'International Sign (IS)',
      'Lipspeaker',
      'Makaton',
      'Deafblind manual alphabet',
      'Notetaker',
      'Deaf Relay',
      'Speech Supported English (SSE)',
      'Visual frame signing',
      'Palantypist / Speech to text'
    ]
  end

  def lang_options(language_method)
    send(language_method)
      .map { |s| t("#{language_method}.#{locale_key(s)}") }
      .unshift('')
  end

  def locale_key(str)
    str.downcase.tr('/(), ', '_')
  end
end

# rubocop:enable Metrics/ModuleLength
