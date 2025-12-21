import '../../../shared/models/traffic_sign.dart';

const signs = <TrafficSign>[
  TrafficSign(
    id: 'stop',
    nameEn: 'Stop',
    nameAr: 'قف',
    imageAsset: 'assets/signs/stop.png',
    descriptionEn: 'Come to a complete stop before proceeding.',
    descriptionAr: 'التوقف التام قبل المتابعة.',
  ),
  // ClassId 0
  TrafficSign(
    id: 'speed_20',
    nameEn: 'Speed limit (20km/h)',
    nameAr: 'السرعة القصوى 20 كم/س',
    imageAsset: 'assets/signs/speed_limit20.png',
    descriptionEn: 'Maximum allowed speed is 20 km/h.',
    descriptionAr: 'السرعة القصوى المسموح بها هي 20 كم/س.',
  ),
  // ClassId 1
  TrafficSign(
    id: 'speed_30',
    nameEn: 'Speed limit (30km/h)',
    nameAr: 'السرعة القصوى 30 كم/س',
    imageAsset: 'assets/signs/speed_limit30.png',
    descriptionEn: 'Maximum allowed speed is 30 km/h.',
    descriptionAr: 'السرعة القصوى المسموح بها هي 30 كم/س.',
  ),
  // ClassId 2
  TrafficSign(
    id: 'speed_50',
    nameEn: 'Speed limit (50km/h)',
    nameAr: 'السرعة القصوى 50 كم/س',
    imageAsset: 'assets/signs/speed_limit50.png',
    descriptionEn: 'Maximum allowed speed is 50 km/h.',
    descriptionAr: 'السرعة القصوى المسموح بها هي 50 كم/س.',
  ),
  // ClassId 3
  TrafficSign(
    id: 'speed_60',
    nameEn: 'Speed limit (60km/h)',
    nameAr: 'السرعة القصوى 60 كم/س',
    imageAsset: 'assets/signs/speed_limit60.png',
    descriptionEn: 'Maximum allowed speed is 60 km/h.',
    descriptionAr: 'السرعة القصوى المسموح بها هي 60 كم/س.',
  ),
  // ClassId 4
  TrafficSign(
    id: 'speed_70',
    nameEn: 'Speed limit (70km/h)',
    nameAr: 'السرعة القصوى 70 كم/س',
    imageAsset: 'assets/signs/speed_limit70.png',
    descriptionEn: 'Maximum allowed speed is 70 km/h.',
    descriptionAr: 'السرعة القصوى المسموح بها هي 70 كم/س.',
  ),
  // ClassId 5
  TrafficSign(
    id: 'speed_80',
    nameEn: 'Speed limit (80km/h)',
    nameAr: 'السرعة القصوى 80 كم/س',
    imageAsset: 'assets/signs/speed_limit80.png',
    descriptionEn: 'Maximum allowed speed is 80 km/h.',
    descriptionAr: 'السرعة القصوى المسموح بها هي 80 كم/س.',
  ),
  // ClassId 6
  TrafficSign(
    id: 'end_speed_80',
    nameEn: 'End of speed limit (80km/h)',
    nameAr: 'نهاية السرعة القصوى 80 كم/س',
    imageAsset: 'assets/signs/end_speed_limit80.png',
    descriptionEn: 'The 80 km/h speed limit ends here.',
    descriptionAr: 'نهاية منطقة السرعة القصوى 80 كم/س.',
  ),
  // ClassId 7
  TrafficSign(
    id: 'speed_100',
    nameEn: 'Speed limit (100km/h)',
    nameAr: 'السرعة القصوى 100 كم/س',
    imageAsset: 'assets/signs/speed_limit100.png',
    descriptionEn: 'Maximum allowed speed is 100 km/h.',
    descriptionAr: 'السرعة القصوى المسموح بها هي 100 كم/س.',
  ),
  // ClassId 8
  TrafficSign(
    id: 'speed_120',
    nameEn: 'Speed limit (120km/h)',
    nameAr: 'السرعة القصوى 120 كم/س',
    imageAsset: 'assets/signs/speed_limit120.png',
    descriptionEn: 'Maximum allowed speed is 120 km/h.',
    descriptionAr: 'السرعة القصوى المسموح بها هي 120 كم/س.',
  ),
  // ClassId 9
  TrafficSign(
    id: 'no_passing',
    nameEn: 'No passing',
    nameAr: 'ممنوع التجاوز',
    imageAsset: 'assets/signs/no_passing.png',
    descriptionEn: 'Overtaking other vehicles is prohibited.',
    descriptionAr: 'تجاوز المركبات الأخرى ممنوع.',
  ),
  // ClassId 10
  TrafficSign(
    id: 'no_passing_trucks',
    nameEn: 'No passing for vehicles over 3.5 metric tons',
    nameAr: 'ممنوع التجاوز للمركبات التي تزن أكثر من 3.5 طن',
    imageAsset: 'assets/signs/no_passing_trucks.png',
    descriptionEn: 'Vehicles over 3.5 tons are prohibited from overtaking.',
    descriptionAr: 'المركبات التي تزن أكثر من 3.5 طن ممنوعة من التجاوز.',
  ),
  // ClassId 11
  TrafficSign(
    id: 'right_of_way',
    nameEn: 'Right-of-way at the next intersection',
    nameAr: 'الأولوية في التقاطع التالي',
    imageAsset: 'assets/signs/right_of_way.png',
    descriptionEn: 'You have the right of way at the next intersection.',
    descriptionAr: 'لديك حق الأولوية في التقاطع التالي.',
  ),
  // ClassId 12
  TrafficSign(
    id: 'priority_road',
    nameEn: 'Priority road',
    nameAr: 'طريق له الأولوية',
    imageAsset: 'assets/signs/priority_road.png',
    descriptionEn: 'You are on a priority road. Other vehicles must give way.',
    descriptionAr:
        'أنت على طريق له الأولوية. يجب على المركبات الأخرى إفساح الطريق.',
  ),
  // ClassId 13
  TrafficSign(
    id: 'yield',
    nameEn: 'Yield',
    nameAr: 'إفسح الطريق',
    imageAsset: 'assets/signs/yield.png',
    descriptionEn: 'You must yield to traffic on the main road.',
    descriptionAr: 'يجب إفساح الطريق لحركة المرور على الطريق الرئيسي.',
  ),
  // ClassId 14
  // ClassId 15
  TrafficSign(
    id: 'no_vehicles',
    nameEn: 'No vehicles',
    nameAr: 'ممنوع دخول المركبات',
    imageAsset: 'assets/signs/no_vehicles.png',
    descriptionEn: 'Entry of all vehicles is prohibited.',
    descriptionAr: 'دخول جميع المركبات ممنوع.',
  ),
  // ClassId 16
  TrafficSign(
    id: 'no_trucks',
    nameEn: 'Vehicles over 3.5 metric tons prohibited',
    nameAr: 'ممنوع دخول المركبات التي تزن أكثر من 3.5 طن',
    imageAsset: 'assets/signs/no_trucks.png',
    descriptionEn: 'Vehicles over 3.5 tons are prohibited.',
    descriptionAr: 'المركبات التي تزن أكثر من 3.5 طن ممنوعة من الدخول.',
  ),
  // ClassId 17
  TrafficSign(
    id: 'no_entry',
    nameEn: 'No entry',
    nameAr: 'ممنوع الدخول',
    imageAsset: 'assets/signs/no_entry.png',
    descriptionEn: 'Entry is prohibited for all vehicles.',
    descriptionAr: 'الدخول ممنوع لجميع المركبات.',
  ),
  // ClassId 18
  TrafficSign(
    id: 'general_caution',
    nameEn: 'General caution',
    nameAr: 'تحذير عام',
    imageAsset: 'assets/signs/general_caution.png',
    descriptionEn: 'General warning for potential hazards.',
    descriptionAr: 'تحذير عام من مخاطر محتملة.',
  ),
  // ClassId 19
  TrafficSign(
    id: 'curve_left',
    nameEn: 'Dangerous curve to the left',
    nameAr: 'منعطف خطير إلى اليسار',
    imageAsset: 'assets/signs/curve_left.png',
    descriptionEn: 'Dangerous left curve ahead.',
    descriptionAr: 'منعطف خطير إلى اليسار أمامك.',
  ),
  // ClassId 20
  TrafficSign(
    id: 'curve_right',
    nameEn: 'Dangerous curve to the right',
    nameAr: 'منعطف خطير إلى اليمين',
    imageAsset: 'assets/signs/curve_right.png',
    descriptionEn: 'Dangerous right curve ahead.',
    descriptionAr: 'منعطف خطير إلى اليمين أمامك.',
  ),
  // ClassId 21
  TrafficSign(
    id: 'double_curve',
    nameEn: 'Double curve',
    nameAr: 'منعطف مزدوج',
    imageAsset: 'assets/signs/double_curve.png',
    descriptionEn: 'Double curve ahead, first to left then to right.',
    descriptionAr: 'منعطف مزدوج أمامك، أولاً إلى اليسار ثم إلى اليمين.',
  ),
  // ClassId 22
  TrafficSign(
    id: 'bumpy_road',
    nameEn: 'Bumpy road',
    nameAr: 'طريق وعر',
    imageAsset: 'assets/signs/bumpy_road.png',
    descriptionEn: 'Uneven or bumpy road surface ahead.',
    descriptionAr: 'سطح طريق غير مستوي أو وعر أمامك.',
  ),
  // ClassId 23
  TrafficSign(
    id: 'slippery_road',
    nameEn: 'Slippery road',
    nameAr: 'طريق زلق',
    imageAsset: 'assets/signs/slippery_road.png',
    descriptionEn: 'Road may be slippery, especially when wet.',
    descriptionAr: 'الطريق قد يكون زلقاً، خاصة عندما يكون رطباً.',
  ),
  // ClassId 24
  TrafficSign(
    id: 'road_narrows_right',
    nameEn: 'Road narrows on the right',
    nameAr: 'الطريق يضيق على اليمين',
    imageAsset: 'assets/signs/road_narrows_right.png',
    descriptionEn: 'Road narrows on the right side ahead.',
    descriptionAr: 'الطريق يضيق على الجانب الأيمن أمامك.',
  ),
  // ClassId 25
  TrafficSign(
    id: 'road_work',
    nameEn: 'Road work',
    nameAr: 'أعمال على الطريق',
    imageAsset: 'assets/signs/road_work.png',
    descriptionEn: 'Road construction or maintenance ahead.',
    descriptionAr: 'أعمال بناء أو صيانة على الطريق أمامك.',
  ),
  // ClassId 26
  TrafficSign(
    id: 'traffic_signals',
    nameEn: 'Traffic signals',
    nameAr: 'إشارات مرور',
    imageAsset: 'assets/signs/traffic_signals.png',
    descriptionEn: 'Traffic signals ahead.',
    descriptionAr: 'إشارات مرور أمامك.',
  ),
  // ClassId 27
  TrafficSign(
    id: 'pedestrians',
    nameEn: 'Pedestrians',
    nameAr: 'مشاة',
    imageAsset: 'assets/signs/pedestrians.png',
    descriptionEn: 'Pedestrian crossing area ahead.',
    descriptionAr: 'منطقة عبور المشاة أمامك.',
  ),
  // ClassId 28
  TrafficSign(
    id: 'children_crossing',
    nameEn: 'Children crossing',
    nameAr: 'أطفال يعبرون',
    imageAsset: 'assets/signs/children_crossing.png',
    descriptionEn: 'Children crossing area ahead. Exercise extra caution.',
    descriptionAr: 'منطقة عبور الأطفال أمامك. توخى الحذر الشديد.',
  ),
  // ClassId 29
  TrafficSign(
    id: 'bicycles_crossing',
    nameEn: 'Bicycles crossing',
    nameAr: 'دراجات هوائية تعبر',
    imageAsset: 'assets/signs/bicycles_crossing.png',
    descriptionEn: 'Bicycle crossing area ahead.',
    descriptionAr: 'منطقة عبور الدراجات الهوائية أمامك.',
  ),
  // ClassId 30
  TrafficSign(
    id: 'ice_snow',
    nameEn: 'Beware of ice/snow',
    nameAr: 'احذر من الجليد/الثلج',
    imageAsset: 'assets/signs/ice_snow.png',
    descriptionEn: 'Road may be icy or snowy. Drive with caution.',
    descriptionAr: 'الطريق قد يكون جليدياً أو ثلجياً. قم بالقيادة بحذر.',
  ),
  // ClassId 31
  TrafficSign(
    id: 'wild_animals',
    nameEn: 'Wild animals crossing',
    nameAr: 'حيوانات برية تعبر',
    imageAsset: 'assets/signs/wild_animals.png',
    descriptionEn: 'Wild animals may cross the road ahead.',
    descriptionAr: 'حيوانات برية قد تعبر الطريق أمامك.',
  ),
  // ClassId 32
  TrafficSign(
    id: 'end_all_speed_passing',
    nameEn: 'End of all speed and passing limits',
    nameAr: 'نهاية جميع قيود السرعة والتجاوز',
    imageAsset: 'assets/signs/end_all_speed_passing.png',
    descriptionEn: 'All previous speed and passing restrictions end here.',
    descriptionAr: 'جميع قيود السرعة والتجاوز السابقة تنتهي هنا.',
  ),
  // ClassId 33
  TrafficSign(
    id: 'turn_right_ahead',
    nameEn: 'Turn right ahead',
    nameAr: 'انعطف يميناً أمامك',
    imageAsset: 'assets/signs/turn_right_ahead.png',
    descriptionEn: 'Mandatory right turn ahead.',
    descriptionAr: 'انعطف يميناً أمامك.',
  ),
  // ClassId 34
  TrafficSign(
    id: 'turn_left_ahead',
    nameEn: 'Turn left ahead',
    nameAr: 'انعطف يساراً أمامك',
    imageAsset: 'assets/signs/turn_left_ahead.png',
    descriptionEn: 'Mandatory left turn ahead.',
    descriptionAr: 'انعطف يساراً أمامك.',
  ),
  // ClassId 35
  TrafficSign(
    id: 'ahead_only',
    nameEn: 'Ahead only',
    nameAr: 'للأمام فقط',
    imageAsset: 'assets/signs/ahead_only.png',
    descriptionEn: 'You must go straight ahead.',
    descriptionAr: 'يجب السير للأمام فقط.',
  ),
  // ClassId 36
  TrafficSign(
    id: 'straight_or_right',
    nameEn: 'Go straight or right',
    nameAr: 'أمامك أو يمين',
    imageAsset: 'assets/signs/straight_or_right.png',
    descriptionEn: 'You may go straight or turn right.',
    descriptionAr: 'يمكنك السير للأمام أو الانعطاف يميناً.',
  ),
  // ClassId 37
  TrafficSign(
    id: 'straight_or_left',
    nameEn: 'Go straight or left',
    nameAr: 'أمامك أو يسار',
    imageAsset: 'assets/signs/straight_or_left.png',
    descriptionEn: 'You may go straight or turn left.',
    descriptionAr: 'يمكنك السير للأمام أو الانعطاف يساراً.',
  ),
  // ClassId 38
  TrafficSign(
    id: 'keep_right',
    nameEn: 'Keep right',
    nameAr: 'إبقى على اليمين',
    imageAsset: 'assets/signs/keep_right.png',
    descriptionEn: 'Keep to the right side of the road.',
    descriptionAr: 'ابق على الجانب الأيمن من الطريق.',
  ),
  // ClassId 39
  TrafficSign(
    id: 'keep_left',
    nameEn: 'Keep left',
    nameAr: 'إبقى على اليسار',
    imageAsset: 'assets/signs/keep_left.png',
    descriptionEn: 'Keep to the left side of the road.',
    descriptionAr: 'ابق على الجانب الأيسر من الطريق.',
  ),
  // ClassId 40
  TrafficSign(
    id: 'roundabout_mandatory',
    nameEn: 'Roundabout mandatory',
    nameAr: 'دوار إجباري',
    imageAsset: 'assets/signs/roundabout_mandatory.png',
    descriptionEn:
        'Roundabout ahead. Vehicles must travel in circular direction.',
    descriptionAr: 'دوار أمامك. يجب على المركبات السير في الاتجاه الدائري.',
  ),
  // ClassId 41
  TrafficSign(
    id: 'end_no_passing',
    nameEn: 'End of no passing',
    nameAr: 'نهاية حظر التجاوز',
    imageAsset: 'assets/signs/end_no_passing.png',
    descriptionEn: 'No passing restriction ends here.',
    descriptionAr: 'حظر التجاوز ينتهي هنا.',
  ),
  // ClassId 42
  TrafficSign(
    id: 'end_no_passing_trucks',
    nameEn: 'End of no passing by vehicles over 3.5 metric tons',
    nameAr: 'نهاية حظر تجاوز المركبات التي تزن أكثر من 3.5 طن',
    imageAsset: 'assets/signs/end_no_passing_trucks.png',
    descriptionEn: 'No passing restriction for heavy vehicles ends here.',
    descriptionAr: 'حظر تجاوز المركبات الثقيلة ينتهي هنا.',
  ),
];
