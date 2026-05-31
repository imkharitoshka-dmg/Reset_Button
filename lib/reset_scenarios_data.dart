import 'reset_scenario.dart';

class ResetCluster {
  const ResetCluster({
    required this.id,
    required this.title,
    required this.stateTitles,
  });

  final String id;
  final String title;
  final List<String> stateTitles;
}

const resetClusters = [
  ResetCluster(
    id: 'calm-down',
    title: 'Успокоиться',
    stateTitles: [
      'Меня накрыл стресс',
      'Я тревожусь',
      'Я переживаю из-за будущего',
    ],
  ),
  ResetCluster(
    id: 'recover',
    title: 'Восстановиться',
    stateTitles: [
      'Усталость',
      'Эмоциональное истощение',
      'Мне ничего не хочется',
    ],
  ),
  ResetCluster(
    id: 'clear-head',
    title: 'Разгрузить голову',
    stateTitles: [
      'У меня хаос в голове',
      'Слишком много задач',
      'Слишком много информации',
    ],
  ),
  ResetCluster(
    id: 'focus',
    title: 'Сфокусироваться',
    stateTitles: [
      'Я не могу сфокусироваться',
      'Я не могу начать',
      'Я распыляюсь',
    ],
  ),
  ResetCluster(
    id: 'after-communication',
    title: 'Переключиться после общения',
    stateTitles: [
      'Усталость от общения',
      'Был тяжёлый разговор',
      'Мне нужно собраться перед встречей',
    ],
  ),
];

const resetStateTitles = [
  'Меня накрыл стресс',
  'Я тревожусь',
  'Я переживаю из-за будущего',
  'Усталость',
  'Эмоциональное истощение',
  'Мне ничего не хочется',
  'У меня хаос в голове',
  'Слишком много задач',
  'Слишком много информации',
  'Я не могу сфокусироваться',
  'Я не могу начать',
  'Я распыляюсь',
  'Усталость от общения',
  'Был тяжёлый разговор',
  'Мне нужно собраться перед встречей',
];

const quickResetScenario = ResetScenario(
  id: 'quick-reset-3',
  stateTitle: 'Быстрый reset',
  title: 'Быстрый reset',
  durationMinutes: 3,
  description: 'Короткий reset, чтобы быстро вернуться в устойчивое состояние.',
  steps: [
    'Поставь обе стопы на пол и выпрями спину.',
    'Сделай три медленных вдоха и выдоха.',
    'Назови одно действие, которое сделаешь следующим.',
  ],
);

ResetScenario _scenarioWithVariants({
  required String id,
  required String stateTitle,
  required int durationMinutes,
  required String title,
  required String shortDescription,
  required List<String> defaultItems,
  required String secondTitle,
  required String secondDescription,
  required List<String> secondItems,
  required String thirdTitle,
  required String thirdDescription,
  required List<String> thirdItems,
}) {
  return ResetScenario.withVariants(
    id: id,
    stateTitle: stateTitle,
    durationMinutes: durationMinutes,
    defaultVariantId: '$id-default',
    variants: [
      ResetScenarioVariant(
        id: '$id-default',
        title: title,
        shortDescription: shortDescription,
        stateTitle: stateTitle,
        durationMinutes: durationMinutes,
        checklistItems: defaultItems,
      ),
      ResetScenarioVariant(
        id: '$id-pause',
        title: secondTitle,
        shortDescription: secondDescription,
        stateTitle: stateTitle,
        durationMinutes: durationMinutes,
        checklistItems: secondItems,
      ),
      ResetScenarioVariant(
        id: '$id-next-step',
        title: thirdTitle,
        shortDescription: thirdDescription,
        stateTitle: stateTitle,
        durationMinutes: durationMinutes,
        checklistItems: thirdItems,
      ),
    ],
  );
}

List<ResetScenario> _scenarioSet({
  required String idPrefix,
  required String stateTitle,
  required String focus,
  required String firstStep,
  required String sortingStep,
  required String returnStep,
}) {
  return [
    _scenarioWithVariants(
      id: '$idPrefix-3',
      stateTitle: stateTitle,
      durationMinutes: 3,
      title: '3 минуты: $focus',
      shortDescription: 'Короткий reset, чтобы снизить лишнюю нагрузку.',
      defaultItems: [
        firstStep,
        'Сделай короткую паузу и несколько спокойных выдохов.',
        returnStep,
      ],
      secondTitle: '3 минуты паузы',
      secondDescription:
          'Быстрый вариант через тело, пространство и один выбор.',
      secondItems: [
        'Снизь яркость экрана или убери лишний раздражитель.',
        'Отметь, что изменилось в состоянии.',
        'Выбери один следующий шаг.',
      ],
      thirdTitle: '3 минуты ясности',
      thirdDescription: 'Короткая сортировка мыслей без длинного анализа.',
      thirdItems: [
        sortingStep,
        'Проверь, что можно отложить.',
        'Закрой сценарий и отметь результат.',
      ],
    ),
    _scenarioWithVariants(
      id: '$idPrefix-5',
      stateTitle: stateTitle,
      durationMinutes: 5,
      title: '5 минут: $focus',
      shortDescription:
          'Небольшой reset, чтобы упорядочить состояние и ближайший шаг.',
      defaultItems: [
        firstStep,
        'Убери один источник шума, если это возможно.',
        sortingStep,
        'Отметь, что можно отложить.',
        returnStep,
      ],
      secondTitle: '5 минут разгрузки',
      secondDescription:
          'Практичный вариант через запись, паузу и короткий выбор.',
      secondItems: [
        'Открой заметку или лист бумаги.',
        sortingStep,
        'Выдели только то, на что можно повлиять сейчас.',
        'Выбери один следующий шаг.',
      ],
      thirdTitle: '5 минут мягкого старта',
      thirdDescription:
          'Reset для возвращения к одному действию без лишнего давления.',
      thirdItems: [
        'Сделай несколько спокойных выдохов.',
        'Проверь, что можно отложить.',
        'Подготовь только то, что нужно для ближайшего действия.',
        returnStep,
      ],
    ),
    _scenarioWithVariants(
      id: '$idPrefix-10',
      stateTitle: stateTitle,
      durationMinutes: 10,
      title: '10 минут: $focus',
      shortDescription:
          'Более длинный reset с паузой, сортировкой и мягким возвращением.',
      defaultItems: [
        firstStep,
        'Снизь лишнюю нагрузку: звук, экран, переписки или вкладки.',
        'Сделай спокойную растяжку плеч, шеи и кистей.',
        sortingStep,
        'Отметь, что можно отложить.',
        returnStep,
      ],
      secondTitle: '10 минут порядка',
      secondDescription:
          'Reset через список, приоритет и один понятный следующий шаг.',
      secondItems: [
        'Выпиши всё, что сейчас занимает внимание.',
        sortingStep,
        'Раздели список на сейчас, позже и можно убрать.',
        'Оставь одну важную точку внимания.',
        'Выбери один следующий шаг.',
        'Закрой сценарий и отметь результат.',
      ],
      thirdTitle: '10 минут возвращения',
      thirdDescription:
          'Спокойный вариант для возвращения к делам после короткой паузы.',
      thirdItems: [
        'Налей воды или сделай несколько глотков, если вода рядом.',
        'Убери один лишний раздражитель из пространства.',
        'Запиши ближайшее действие одной короткой фразой.',
        'Проверь, что можно отложить.',
        'Подготовь только нужный файл, предмет или заметку.',
        returnStep,
      ],
    ),
  ];
}

final resetScenarios = [
  ResetScenario.withVariants(
    id: 'tired-3',
    stateTitle: 'Усталость',
    durationMinutes: 3,
    defaultVariantId: 'tired-3-default',
    variants: [
      ResetScenarioVariant(
        id: 'tired-3-default',
        title: '3 минуты восстановления',
        shortDescription: 'Короткая пауза, чтобы дать телу немного отдыха.',
        stateTitle: 'Усталость',
        durationMinutes: 3,
        checklistItems: [
          'Отложи телефон и закрой лишние вкладки.',
          'Расслабь плечи, челюсть и кисти рук.',
          'Сделай несколько спокойных вдохов и выбери самое лёгкое следующее действие.',
        ],
      ),
      ResetScenarioVariant(
        id: 'tired-3-physical',
        title: 'Короткая разминка',
        shortDescription: 'Физический reset, чтобы мягко переключить внимание.',
        stateTitle: 'Усталость',
        durationMinutes: 3,
        checklistItems: [
          'Встань или сядь устойчиво, почувствуй опору стоп.',
          'Медленно потянись вверх и расслабь плечи.',
          'Поверни голову вправо и влево без усилия.',
          'Сделай один спокойный вдох и вернись к ближайшему действию.',
        ],
      ),
      ResetScenarioVariant(
        id: 'tired-3-next-step',
        title: 'Один маленький шаг',
        shortDescription:
            'Мягкий reset через снижение нагрузки и выбор простого шага.',
        stateTitle: 'Усталость',
        durationMinutes: 3,
        checklistItems: [
          'Запиши всё, что сейчас требует внимания.',
          'Выбери одну задачу, которую можно отложить.',
          'Оставь один маленький шаг на ближайшие несколько минут.',
          'Начни с действия, которое проще всего выполнить.',
        ],
      ),
    ],
  ),
  ResetScenario.withVariants(
    id: 'tired-5',
    stateTitle: 'Усталость',
    durationMinutes: 5,
    defaultVariantId: 'tired-5-default',
    variants: [
      ResetScenarioVariant(
        id: 'tired-5-default',
        title: '5 минут восстановления',
        shortDescription:
            'Мягкий reset для усталости без попытки сразу ускориться.',
        stateTitle: 'Усталость',
        durationMinutes: 5,
        checklistItems: [
          'Сядь удобно и убери визуальный шум вокруг себя.',
          'Медленно просканируй тело от головы до стоп.',
          'Запиши одну задачу, которую можно отложить.',
          'Выбери маленькое действие, которое не требует усилия.',
        ],
      ),
      ResetScenarioVariant(
        id: 'tired-5-body',
        title: 'Мягкая пауза для тела',
        shortDescription: 'Телесный reset на несколько спокойных движений.',
        stateTitle: 'Усталость',
        durationMinutes: 5,
        checklistItems: [
          'Поставь стопы на пол и расслабь плечи.',
          'Медленно потянись вверх, затем отпусти напряжение.',
          'Сделай несколько кругов плечами в удобном темпе.',
          'Разомни кисти и пальцы без усилия.',
          'Сделай спокойный вдох и выбери, куда вернуться дальше.',
        ],
      ),
      ResetScenarioVariant(
        id: 'tired-5-load-water-step',
        title: 'Пауза и один шаг',
        shortDescription:
            'Reset через снижение нагрузки, воду и маленькое следующее действие.',
        stateTitle: 'Усталость',
        durationMinutes: 5,
        checklistItems: [
          'Налей воды или сделай несколько глотков, если вода рядом.',
          'Отложи одну задачу, которую не обязательно делать сейчас.',
          'Убери один источник шума: вкладку, чат или лишний предмет.',
          'Запиши самый маленький следующий шаг.',
          'Начни с него или оставь его первым в списке.',
        ],
      ),
    ],
  ),
  ResetScenario.withVariants(
    id: 'tired-10',
    stateTitle: 'Усталость',
    durationMinutes: 10,
    defaultVariantId: 'tired-10-default',
    variants: [
      ResetScenarioVariant(
        id: 'tired-10-default',
        title: '10 минут восстановления',
        shortDescription: 'Более длинная пауза перед возвращением к делам.',
        stateTitle: 'Усталость',
        durationMinutes: 10,
        checklistItems: [
          'Налей воды и отойди от рабочего места.',
          'Сделай спокойную растяжку шеи, плеч и спины.',
          'Запиши, что именно забирает больше всего сил.',
          'Оставь только одну обязательную задачу на ближайший час.',
        ],
      ),
      ResetScenarioVariant(
        id: 'tired-10-sensory-pause',
        title: 'Тихая пауза для тела',
        shortDescription:
            'Восстановительный reset через паузу, тело и меньше сенсорной нагрузки.',
        stateTitle: 'Усталость',
        durationMinutes: 10,
        checklistItems: [
          'Отложи телефон экраном вниз или убери его в сторону.',
          'Приглуши свет, звук или другой раздражитель, если это возможно.',
          'Налей воды и сделай несколько спокойных глотков.',
          'Медленно потянись, расслабь плечи и кисти.',
          'Посиди одну минуту без новых задач и сообщений.',
          'Выбери, возвращаться к делу сейчас или взять ещё короткую паузу.',
        ],
      ),
      ResetScenarioVariant(
        id: 'tired-10-work-return',
        title: 'Разобрать нагрузку',
        shortDescription:
            'Reset через разбор нагрузки, один следующий шаг и мягкое возвращение.',
        stateTitle: 'Усталость',
        durationMinutes: 10,
        checklistItems: [
          'Выпиши всё, что сейчас занимает внимание.',
          'Отметь задачи, которые можно отложить до завтра или позже.',
          'Выбери одно действие, которое действительно важно сейчас.',
          'Сделай его настолько маленьким, чтобы начать было легко.',
          'Подготовь только то, что нужно для этого шага.',
          'Вернись к работе с этого одного действия.',
        ],
      ),
    ],
  ),
  ResetScenario.withVariants(
    id: 'emotional-exhaustion-3',
    stateTitle: 'Эмоциональное истощение',
    durationMinutes: 3,
    defaultVariantId: 'emotional-exhaustion-3-default',
    variants: [
      ResetScenarioVariant(
        id: 'emotional-exhaustion-3-default',
        title: '3 минуты тишины',
        shortDescription:
            'Короткая пауза без новых решений и лишнего контакта.',
        stateTitle: 'Эмоциональное истощение',
        durationMinutes: 3,
        checklistItems: [
          'Отложи переписки и закрой лишние вкладки.',
          'Сделай несколько спокойных выдохов в удобном темпе.',
          'Выбери один следующий шаг без общения, если это возможно.',
        ],
      ),
      ResetScenarioVariant(
        id: 'emotional-exhaustion-3-boundary',
        title: 'Мягкая граница',
        shortDescription:
            'Reset через короткую паузу и снижение внешней нагрузки.',
        stateTitle: 'Эмоциональное истощение',
        durationMinutes: 3,
        checklistItems: [
          'Поставь телефон экраном вниз или убери его в сторону.',
          'Назови одну вещь, которую можно не решать прямо сейчас.',
          'Отметь, что можно отложить до следующего свободного окна.',
          'Вернись к одной маленькой задаче.',
        ],
      ),
      ResetScenarioVariant(
        id: 'emotional-exhaustion-3-grounding',
        title: 'Вернуться к опоре',
        shortDescription: 'Короткий reset через тело и один простой ориентир.',
        stateTitle: 'Эмоциональное истощение',
        durationMinutes: 3,
        checklistItems: [
          'Поставь стопы на пол и почувствуй опору.',
          'Расслабь плечи, челюсть и кисти рук.',
          'Посмотри вокруг и назови один спокойный предмет.',
          'Выбери один следующий шаг.',
        ],
      ),
    ],
  ),
  ResetScenario.withVariants(
    id: 'emotional-exhaustion-5',
    stateTitle: 'Эмоциональное истощение',
    durationMinutes: 5,
    defaultVariantId: 'emotional-exhaustion-5-default',
    variants: [
      ResetScenarioVariant(
        id: 'emotional-exhaustion-5-default',
        title: '5 минут без давления',
        shortDescription:
            'Спокойный reset, чтобы уменьшить количество входящих стимулов.',
        stateTitle: 'Эмоциональное истощение',
        durationMinutes: 5,
        checklistItems: [
          'Убери один источник шума: чат, вкладку или уведомления.',
          'Сядь удобнее и сделай несколько длинных выдохов.',
          'Запиши, что сейчас требует эмоционального внимания.',
          'Отметь, что можно отложить.',
          'Выбери один следующий шаг без лишней нагрузки.',
        ],
      ),
      ResetScenarioVariant(
        id: 'emotional-exhaustion-5-after-contact',
        title: 'После контакта',
        shortDescription:
            'Reset после общения через отделение фактов от впечатлений.',
        stateTitle: 'Эмоциональное истощение',
        durationMinutes: 5,
        checklistItems: [
          'Запиши одной строкой, что именно забрало больше всего сил.',
          'Отдели факт от предположения или внутреннего вывода.',
          'Отметь одну границу, которую важно сохранить.',
          'Выбери спокойное действие на ближайшие минуты.',
          'Оставь заметку, если нужно.',
        ],
      ),
      ResetScenarioVariant(
        id: 'emotional-exhaustion-5-low-input',
        title: 'Меньше входящего',
        shortDescription:
            'Reset через короткую сенсорную паузу и простую сортировку.',
        stateTitle: 'Эмоциональное истощение',
        durationMinutes: 5,
        checklistItems: [
          'Снизь яркость экрана или убери лишние раздражители.',
          'Сделай несколько глотков воды, если это уместно.',
          'Выпиши три дела, которые сейчас требуют внимания.',
          'Оставь только одно дело для ближайшего шага.',
          'Вернись к одной маленькой задаче.',
        ],
      ),
    ],
  ),
  ResetScenario.withVariants(
    id: 'emotional-exhaustion-10',
    stateTitle: 'Эмоциональное истощение',
    durationMinutes: 10,
    defaultVariantId: 'emotional-exhaustion-10-default',
    variants: [
      ResetScenarioVariant(
        id: 'emotional-exhaustion-10-default',
        title: '10 минут восстановления контакта с собой',
        shortDescription:
            'Более длинная пауза с телом, тишиной и одним мягким решением.',
        stateTitle: 'Эмоциональное истощение',
        durationMinutes: 10,
        checklistItems: [
          'Отойди от переписки, звонков или шумного места.',
          'Приглуши один раздражитель, если это возможно.',
          'Сделай спокойную растяжку плеч, шеи и кистей.',
          'Запиши, что можно не решать сегодня.',
          'Выбери одно действие, которое поддержит ближайший час.',
          'Вернись к одной маленькой задаче.',
        ],
      ),
      ResetScenarioVariant(
        id: 'emotional-exhaustion-10-unload',
        title: 'Разгрузить эмоции',
        shortDescription:
            'Reset через запись, паузу и выбор минимального действия.',
        stateTitle: 'Эмоциональное истощение',
        durationMinutes: 10,
        checklistItems: [
          'Выпиши всё, что сейчас давит эмоционально.',
          'Отметь, где факт, а где ожидание или вывод.',
          'Подчеркни одну тему, которую можно закрыть или отложить.',
          'Сделай несколько спокойных выдохов.',
          'Выбери один следующий шаг.',
          'Оставь заметку, если нужно.',
        ],
      ),
      ResetScenarioVariant(
        id: 'emotional-exhaustion-10-soft-return',
        title: 'Мягкое возвращение',
        shortDescription:
            'Reset перед возвращением к делам без резкого ускорения.',
        stateTitle: 'Эмоциональное истощение',
        durationMinutes: 10,
        checklistItems: [
          'Налей воды или подготовь спокойное рабочее место.',
          'Закрой лишние окна, вкладки или переписки.',
          'Запиши список дел без сортировки.',
          'Отметь одно дело, которое можно отложить.',
          'Выбери действие на ближайшие несколько минут.',
          'Начни с самой простой части.',
        ],
      ),
    ],
  ),
  ResetScenario.withVariants(
    id: 'low-motivation-3',
    stateTitle: 'Мне ничего не хочется',
    durationMinutes: 3,
    defaultVariantId: 'low-motivation-3-default',
    variants: [
      ResetScenarioVariant(
        id: 'low-motivation-3-default',
        title: '3 минуты минимального старта',
        shortDescription:
            'Короткий reset, чтобы выбрать действие без давления.',
        stateTitle: 'Мне ничего не хочется',
        durationMinutes: 3,
        checklistItems: [
          'Сядь удобнее или встань устойчиво.',
          'Убери одну лишнюю вещь из поля зрения.',
          'Выбери один следующий шаг, который занимает меньше минуты.',
        ],
      ),
      ResetScenarioVariant(
        id: 'low-motivation-3-one-thing',
        title: 'Одна вещь',
        shortDescription:
            'Reset через выбор самого маленького полезного действия.',
        stateTitle: 'Мне ничего не хочется',
        durationMinutes: 3,
        checklistItems: [
          'Запиши три возможных действия без оценки.',
          'Вычеркни всё, что сейчас кажется слишком большим.',
          'Оставь один самый маленький шаг.',
          'Начни с него или оставь заметку, если нужно.',
        ],
      ),
      ResetScenarioVariant(
        id: 'low-motivation-3-body-start',
        title: 'Старт через тело',
        shortDescription:
            'Короткое переключение через движение и простой выбор.',
        stateTitle: 'Мне ничего не хочется',
        durationMinutes: 3,
        checklistItems: [
          'Поставь стопы на пол и выпрями спину без усилия.',
          'Медленно потянись вверх и расслабь плечи.',
          'Сделай несколько спокойных выдохов.',
          'Вернись к одной маленькой задаче.',
        ],
      ),
    ],
  ),
  ResetScenario.withVariants(
    id: 'low-motivation-5',
    stateTitle: 'Мне ничего не хочется',
    durationMinutes: 5,
    defaultVariantId: 'low-motivation-5-default',
    variants: [
      ResetScenarioVariant(
        id: 'low-motivation-5-default',
        title: '5 минут мягкого запуска',
        shortDescription:
            'Reset через снижение требований и выбор очень простого шага.',
        stateTitle: 'Мне ничего не хочется',
        durationMinutes: 5,
        checklistItems: [
          'Запиши всё, что сейчас кажется слишком большим.',
          'Отметь, что можно отложить.',
          'Разбей одну задачу на действие меньше двух минут.',
          'Подготовь только то, что нужно для старта.',
          'Вернись к одной маленькой задаче.',
        ],
      ),
      ResetScenarioVariant(
        id: 'low-motivation-5-environment',
        title: 'Среда для старта',
        shortDescription:
            'Reset через маленькое изменение пространства и один выбор.',
        stateTitle: 'Мне ничего не хочется',
        durationMinutes: 5,
        checklistItems: [
          'Убери один предмет, который мешает начать.',
          'Открой только один нужный файл, список или экран.',
          'Выпей воды, если это уместно.',
          'Выбери действие, после которого можно остановиться.',
          'Начни с самого лёгкого движения.',
        ],
      ),
      ResetScenarioVariant(
        id: 'low-motivation-5-no-pressure',
        title: 'Без давления',
        shortDescription:
            'Reset, чтобы снизить ожидания и оставить маленький следующий шаг.',
        stateTitle: 'Мне ничего не хочется',
        durationMinutes: 5,
        checklistItems: [
          'Напиши: что достаточно сделать минимально.',
          'Убери из списка всё, что не обязательно сейчас.',
          'Оставь один короткий шаг.',
          'Определи, где можно остановиться после него.',
          'Оставь заметку, если нужно.',
        ],
      ),
    ],
  ),
  ResetScenario.withVariants(
    id: 'low-motivation-10',
    stateTitle: 'Мне ничего не хочется',
    durationMinutes: 10,
    defaultVariantId: 'low-motivation-10-default',
    variants: [
      ResetScenarioVariant(
        id: 'low-motivation-10-default',
        title: '10 минут бережного старта',
        shortDescription:
            'Восстановительный reset с паузой и одним небольшим действием.',
        stateTitle: 'Мне ничего не хочется',
        durationMinutes: 10,
        checklistItems: [
          'Сделай короткую паузу без новых задач и сообщений.',
          'Снизь яркость экрана или убери лишние раздражители.',
          'Выпиши дела, которые сейчас занимают внимание.',
          'Отметь, что можно отложить.',
          'Выбери один следующий шаг.',
          'Вернись к одной маленькой задаче.',
        ],
      ),
      ResetScenarioVariant(
        id: 'low-motivation-10-sort',
        title: 'Разобрать ожидания',
        shortDescription:
            'Reset через сортировку нагрузки и мягкое возвращение к делу.',
        stateTitle: 'Мне ничего не хочется',
        durationMinutes: 10,
        checklistItems: [
          'Запиши, что сейчас ожидается сделать.',
          'Раздели список на обязательно, можно позже и можно убрать.',
          'Оставь одну обязательную задачу.',
          'Сделай её первый шаг максимально маленьким.',
          'Подготовь нужный файл, предмет или заметку.',
          'Начни с простого действия.',
        ],
      ),
      ResetScenarioVariant(
        id: 'low-motivation-10-support',
        title: 'Поддержать старт',
        shortDescription:
            'Reset через воду, пространство и один понятный следующий шаг.',
        stateTitle: 'Мне ничего не хочется',
        durationMinutes: 10,
        checklistItems: [
          'Налей воды или сделай несколько глотков, если вода рядом.',
          'Проветри комнату или смени положение тела, если это удобно.',
          'Убери один источник шума или визуальной перегрузки.',
          'Запиши самый маленький полезный шаг.',
          'Отметь, что можно отложить.',
          'Оставь заметку, если нужно.',
        ],
      ),
    ],
  ),
  ..._scenarioSet(
    idPrefix: 'stress',
    stateTitle: 'Меня накрыл стресс',
    focus: 'снизить напряжение',
    firstStep: 'Почувствуй опору стоп, спины или ладоней.',
    sortingStep: 'Назови, что именно сейчас требует внимания.',
    returnStep: 'Выбери один следующий шаг.',
  ),
  ..._scenarioSet(
    idPrefix: 'anxious',
    stateTitle: 'Я тревожусь',
    focus: 'заземлиться',
    firstStep: 'Почувствуй опору стоп и спины.',
    sortingStep: 'Отдели факт от предположения одной короткой строкой.',
    returnStep: 'Сформулируй первый безопасный шаг.',
  ),
  ..._scenarioSet(
    idPrefix: 'future-worry',
    stateTitle: 'Я переживаю из-за будущего',
    focus: 'вернуться к ближайшему шагу',
    firstStep: 'Запиши тревожную мысль о будущем одной фразой.',
    sortingStep: 'Отметь, на что можно повлиять сегодня.',
    returnStep: 'Выбери один следующий шаг на ближайшее время.',
  ),
  ..._scenarioSet(
    idPrefix: 'mental-chaos',
    stateTitle: 'У меня хаос в голове',
    focus: 'навести ясность',
    firstStep: 'Выпиши мысли потоком без редактирования.',
    sortingStep: 'Раздели список на мысли, чувства и действия.',
    returnStep: 'Вернись к одной маленькой задаче.',
  ),
  ..._scenarioSet(
    idPrefix: 'too-many-tasks',
    stateTitle: 'Слишком много задач',
    focus: 'разгрузить список',
    firstStep: 'Открой заметку или лист бумаги.',
    sortingStep: 'Раздели задачи на сейчас, позже и можно убрать.',
    returnStep: 'Выбери один следующий шаг.',
  ),
  ..._scenarioSet(
    idPrefix: 'too-much-info',
    stateTitle: 'Слишком много информации',
    focus: 'снизить информационную нагрузку',
    firstStep: 'Закрой лишние вкладки, чаты или материалы.',
    sortingStep: 'Запиши, какая информация действительно нужна сейчас.',
    returnStep: 'Вернись к одному источнику или одной маленькой задаче.',
  ),
  ..._scenarioSet(
    idPrefix: 'unfocused',
    stateTitle: 'Я не могу сфокусироваться',
    focus: 'выбрать одну точку внимания',
    firstStep: 'Закрой всё, что не относится к текущей задаче.',
    sortingStep: 'Запиши задачу одним предложением.',
    returnStep: 'Вернись к одной маленькой задаче.',
  ),
  ..._scenarioSet(
    idPrefix: 'cannot-start',
    stateTitle: 'Я не могу начать',
    focus: 'найти первый шаг',
    firstStep: 'Запиши задачу, к которой трудно подступиться.',
    sortingStep:
        'Сделай первый шаг настолько маленьким, чтобы начать было легко.',
    returnStep: 'Выбери один следующий шаг.',
  ),
  ..._scenarioSet(
    idPrefix: 'scattered',
    stateTitle: 'Я распыляюсь',
    focus: 'собрать внимание',
    firstStep:
        'Запиши все направления, между которыми сейчас переключается внимание.',
    sortingStep: 'Оставь одну точку внимания на ближайшие минуты.',
    returnStep: 'Вернись к одной маленькой задаче.',
  ),
  ..._scenarioSet(
    idPrefix: 'social-tired',
    stateTitle: 'Усталость от общения',
    focus: 'снизить контактную нагрузку',
    firstStep: 'Отложи переписки или звонки, если это возможно.',
    sortingStep: 'Отметь, какой контакт можно отложить.',
    returnStep: 'Выбери один следующий шаг без лишнего общения.',
  ),
  ..._scenarioSet(
    idPrefix: 'hard-talk',
    stateTitle: 'Был тяжёлый разговор',
    focus: 'отделить разговор от следующего шага',
    firstStep: 'Отойди от переписки или места разговора.',
    sortingStep: 'Выпиши факты разговора без интерпретаций.',
    returnStep: 'Оставь заметку, если нужно.',
  ),
  ..._scenarioSet(
    idPrefix: 'before-meeting',
    stateTitle: 'Мне нужно собраться перед встречей',
    focus: 'подготовиться к встрече',
    firstStep: 'Проверь время, ссылку или место встречи.',
    sortingStep: 'Запиши цель встречи и один важный вопрос.',
    returnStep: 'Закрой сценарий и отметь результат.',
  ),
];

final allResetScenarios = [quickResetScenario, ...resetScenarios];

List<ResetScenario> scenariosForState(String stateTitle) {
  return resetScenarios
      .where((scenario) => scenario.stateTitle == stateTitle)
      .toList();
}

ResetScenarioVariant? scenarioVariantById(String? scenarioVariantId) {
  if (scenarioVariantId == null) {
    return null;
  }

  for (final scenario in allResetScenarios) {
    for (final variant in scenario.variants) {
      if (variant.id == scenarioVariantId) {
        return variant;
      }
    }
  }

  return null;
}

String scenarioStateTitleForUserState(String stateTitle) {
  return switch (stateTitle) {
    'Я устала' => 'Усталость',
    'Усталость' => 'Усталость',
    'Эмоциональное истощение' => 'Эмоциональное истощение',
    'Мне ничего не хочется' => 'Мне ничего не хочется',
    'Я перегружена задачами' => 'Слишком много задач',
    'Мне нужно быстро собраться перед встречей' =>
      'Мне нужно собраться перед встречей',
    'Мне нужно восстановиться после тяжёлого разговора' =>
      'Был тяжёлый разговор',
    _ => stateTitle,
  };
}

List<ResetScenario> scenariosForUserState(String stateTitle) {
  return scenariosForState(
    scenarioStateTitleForUserState(stateTitle),
  ).map((scenario) => scenario.withStateTitle(stateTitle)).toList();
}

ResetScenarioVariant? defaultScenarioVariantForStateAndDuration({
  required String stateTitle,
  required int durationMinutes,
}) {
  for (final scenario in allResetScenarios) {
    if (scenario.stateTitle == stateTitle &&
        scenario.durationMinutes == durationMinutes) {
      return scenario.defaultVariant;
    }
  }

  return null;
}

ResetScenarioVariant? defaultScenarioVariantForClusterAndDuration({
  required ResetCluster cluster,
  required int durationMinutes,
}) {
  for (final scenario in scenariosForUserState(cluster.stateTitles.first)) {
    if (scenario.durationMinutes == durationMinutes) {
      return scenario.defaultVariant;
    }
  }

  return null;
}

ResetScenarioVariant? defaultScenarioVariantForUserStateAndDuration({
  required String stateTitle,
  required int durationMinutes,
}) {
  for (final scenario in scenariosForUserState(stateTitle)) {
    if (scenario.durationMinutes == durationMinutes) {
      return scenario.defaultVariant;
    }
  }

  return null;
}
