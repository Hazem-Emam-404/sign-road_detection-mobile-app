/// Maps internal sign labels (from detection model/filenames) to Arabic text for TTS.
final Map<String, String> signTranslations = {
  // Stop & Yield
  'stop': 'قف',
  'yield': 'أفسح الطريق',
  
  // Speed Limits
  'speed_limit20': 'السرعة القصوى عشرون',
  'speed_limit30': 'السرعة القصوى ثلاثون',
  'speed_limit50': 'السرعة القصوى خمسون',
  'speed_limit60': 'السرعة القصوى ستون',
  'speed_limit70': 'السرعة القصوى سبعون',
  'speed_limit80': 'السرعة القصوى ثمانون',
  'speed_limit100': 'السرعة القصوى مئة',
  'speed_limit120': 'السرعة القصوى مئة وعشرون',
  'end_speed_limit80': 'نهاية حد السرعة ثمانون',

  // Prohibitory
  'no_entry': 'ممنوع الدخول',
  'no_passing': 'ممنوع التجاوز',
  'no_passing_trucks': 'ممنوع التجاوز للشاحنات',
  'no_trucks': 'ممنوع مرور الشاحنات',
  'no_vehicles': 'ممنوع مرور المركبات',

  // Warning / Danger
  'general_caution': 'انتبه، خذر عام',
  'curve_left': 'منعطف لليسار',
  'curve_right': 'منعطف لليمين',
  'double_curve': 'منعطف مزدوج',
  'priority_road': 'طريق ذو أولوية',
  'right_of_way': 'حق الأولوية',

  // Fallback
  'no_sign': '',
};
