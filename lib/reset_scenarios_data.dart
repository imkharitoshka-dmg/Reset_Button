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
  'Усталость',
  'Я тревожусь',
  'Слишком много задач',
  'Я не могу сфокусироваться',
  'У меня хаос в голове',
  'Мне нужно быстро собраться перед встречей',
  'Мне нужно восстановиться после тяжёлого разговора',
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

const resetScenarios = [
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
  ResetScenario(
    id: 'anxious-3',
    stateTitle: 'Я тревожусь',
    title: '3 минуты заземления',
    durationMinutes: 3,
    description:
        'Быстрый способ вернуться из тревожных мыслей в текущий момент.',
    steps: [
      'Почувствуй опору стоп и спины.',
      'Назови пять предметов, которые видишь вокруг.',
      'Сделай длинный выдох и напомни себе, что сейчас происходит прямо здесь.',
    ],
  ),
  ResetScenario(
    id: 'anxious-5',
    stateTitle: 'Я тревожусь',
    title: '5 минут спокойствия',
    durationMinutes: 5,
    description:
        'Короткий сценарий, чтобы мягко собрать внимание и следующий шаг.',
    steps: [
      'Запиши тревожную мысль одной фразой.',
      'Отдели факт от предположения.',
      'Сделай пять медленных выдохов.',
      'Выбери одно действие, которое можешь сделать сейчас.',
    ],
  ),
  ResetScenario(
    id: 'anxious-10',
    stateTitle: 'Я тревожусь',
    title: '10 минут стабилизации',
    durationMinutes: 10,
    description:
        'Спокойный reset, чтобы чуть упорядочить мысли и собрать план.',
    steps: [
      'Выпиши всё, что крутится в голове.',
      'Подчеркни только то, на что реально можешь повлиять.',
      'Сделай дыхание с длинным выдохом в удобном темпе.',
      'Сформулируй первый безопасный шаг.',
    ],
  ),
  ResetScenario(
    id: 'overloaded-3',
    stateTitle: 'Я перегружена задачами',
    title: '3 минуты разгрузки',
    durationMinutes: 3,
    description: 'Быстро вынести задачи из головы и увидеть ближайший шаг.',
    steps: [
      'Открой заметку или лист бумаги.',
      'Выпиши все задачи без сортировки.',
      'Обведи одну задачу, которую важно сделать первой.',
    ],
  ),
  ResetScenario(
    id: 'overloaded-5',
    stateTitle: 'Я перегружена задачами',
    title: '5 минут приоритизации',
    durationMinutes: 5,
    description: 'Мини-план, чтобы отделить важное от шума.',
    steps: [
      'Выпиши задачи короткими глаголами.',
      'Отметь срочное, важное и лишнее.',
      'Убери одну задачу из списка на сегодня.',
      'Начни с действия, которое занимает меньше десяти минут.',
    ],
  ),
  ResetScenario(
    id: 'overloaded-10',
    stateTitle: 'Я перегружена задачами',
    title: '10 минут упорядочивания',
    durationMinutes: 10,
    description:
        'Сценарий для перегруза, когда нужно собрать понятный порядок.',
    steps: [
      'Собери все задачи в один список.',
      'Раздели их на сегодня, позже и можно не делать.',
      'Выбери максимум три задачи на сегодня.',
      'Определи первый физический шаг для каждой выбранной задачи.',
    ],
  ),
  ResetScenario(
    id: 'unfocused-3',
    stateTitle: 'Я не могу сфокусироваться',
    title: '3 минуты фокуса',
    durationMinutes: 3,
    description:
        'Быстрый reset, чтобы убрать лишнее и выбрать одну точку внимания.',
    steps: [
      'Закрой всё, что не относится к текущей задаче.',
      'Запиши задачу одним предложением.',
      'Поставь рядом только то, что нужно для первого шага.',
    ],
  ),
  ResetScenario(
    id: 'unfocused-5',
    stateTitle: 'Я не могу сфокусироваться',
    title: '5 минут возвращения внимания',
    durationMinutes: 5,
    description: 'Сценарий для мягкого возвращения к одной задаче.',
    steps: [
      'Убери уведомления и лишние окна.',
      'Определи, что считается завершением ближайшего шага.',
      'Разбей шаг на действие меньше пяти минут.',
      'Начни с самой простой части.',
    ],
  ),
  ResetScenario(
    id: 'unfocused-10',
    stateTitle: 'Я не могу сфокусироваться',
    title: '10 минут концентрации',
    durationMinutes: 10,
    description: 'Подготовка к спокойной работе без таймера в приложении.',
    steps: [
      'Очисти рабочее место от лишнего.',
      'Запиши одну цель на ближайший рабочий отрезок.',
      'Составь три последовательных шага.',
      'Начни первый шаг и не оценивай результат до завершения.',
    ],
  ),
  ResetScenario(
    id: 'mental-chaos-3',
    stateTitle: 'У меня хаос в голове',
    title: '3 минуты ясности',
    durationMinutes: 3,
    description:
        'Короткая разгрузка мыслей, чтобы стало понятнее, что происходит.',
    steps: [
      'Выпиши все мысли потоком без редактирования.',
      'Подчеркни одну самую повторяющуюся мысль.',
      'Сформулируй её проще и спокойнее.',
    ],
  ),
  ResetScenario(
    id: 'mental-chaos-5',
    stateTitle: 'У меня хаос в голове',
    title: '5 минут сортировки мыслей',
    durationMinutes: 5,
    description: 'Сценарий, чтобы разложить мысли по понятным категориям.',
    steps: [
      'Выпиши мысли списком.',
      'Отметь, где факт, где эмоция, где задача.',
      'Выбери одну задачу, которую можно сделать или отложить.',
      'Запиши короткое решение по этой задаче.',
    ],
  ),
  ResetScenario(
    id: 'mental-chaos-10',
    stateTitle: 'У меня хаос в голове',
    title: '10 минут наведения порядка',
    durationMinutes: 10,
    description:
        'Более спокойный reset для мыслей, эмоций и задач одновременно.',
    steps: [
      'Выпиши всё, что занимает внимание.',
      'Раздели список на мысли, чувства и действия.',
      'Для действий выбери ближайший конкретный шаг.',
      'Для чувств назови одно, которое сильнее всего сейчас.',
    ],
  ),
  ResetScenario(
    id: 'before-meeting-3',
    stateTitle: 'Мне нужно быстро собраться перед встречей',
    title: '3 минуты перед встречей',
    durationMinutes: 3,
    description: 'Быстро собраться и войти во встречу с понятной целью.',
    steps: [
      'Проверь время, ссылку или место встречи.',
      'Запиши одну цель встречи.',
      'Сформулируй первый вопрос или фразу для начала.',
    ],
  ),
  ResetScenario(
    id: 'before-meeting-5',
    stateTitle: 'Мне нужно быстро собраться перед встречей',
    title: '5 минут подготовки к встрече',
    durationMinutes: 5,
    description: 'Короткая подготовка, чтобы войти в разговор чуть спокойнее.',
    steps: [
      'Открой нужные материалы.',
      'Запиши цель встречи и желаемый результат.',
      'Отметь два вопроса, которые важно задать.',
      'Сделай один спокойный вдох перед входом.',
    ],
  ),
  ResetScenario(
    id: 'before-meeting-10',
    stateTitle: 'Мне нужно быстро собраться перед встречей',
    title: '10 минут уверенной подготовки',
    durationMinutes: 10,
    description: 'Подготовить цель, материалы и позицию перед важной встречей.',
    steps: [
      'Проверь повестку, материалы и технические детали.',
      'Запиши главную цель и запасной результат.',
      'Подготовь три тезиса, которые важно сказать.',
      'Определи, с какого вопроса начнёшь.',
    ],
  ),
  ResetScenario(
    id: 'after-hard-talk-3',
    stateTitle: 'Мне нужно восстановиться после тяжёлого разговора',
    title: '3 минуты после разговора',
    durationMinutes: 3,
    description:
        'Короткий reset после сложного контакта, чтобы вернуться к себе.',
    steps: [
      'Отойди от переписки или места разговора.',
      'Назови эмоцию, которая сейчас сильнее всего.',
      'Сделай длинный выдох и верни внимание к телу.',
    ],
  ),
  ResetScenario(
    id: 'after-hard-talk-5',
    stateTitle: 'Мне нужно восстановиться после тяжёлого разговора',
    title: '5 минут восстановления после разговора',
    durationMinutes: 5,
    description:
        'Сценарий, чтобы отделить себя от разговора и выбрать мягкое действие.',
    steps: [
      'Запиши, что именно было тяжёлым.',
      'Отдели слова другого человека от своих выводов о себе.',
      'Назови одну границу, которую хочешь сохранить.',
      'Выбери мягкое действие для поддержки себя.',
    ],
  ),
  ResetScenario(
    id: 'after-hard-talk-10',
    stateTitle: 'Мне нужно восстановиться после тяжёлого разговора',
    title: '10 минут восстановления после разговора',
    durationMinutes: 10,
    description:
        'Более подробный reset после сложного или болезненного общения.',
    steps: [
      'Выпиши факты разговора без интерпретаций.',
      'Отдельно запиши свои чувства и потребности.',
      'Реши, нужно ли что-то сделать дальше или можно завершить тему.',
      'Выбери один способ поддержать себя прямо сейчас.',
    ],
  ),
];

const allResetScenarios = [quickResetScenario, ...resetScenarios];

List<ResetScenario> scenariosForState(String stateTitle) {
  return resetScenarios
      .where((scenario) => scenario.stateTitle == stateTitle)
      .toList();
}

String scenarioStateTitleForUserState(String stateTitle) {
  return switch (stateTitle) {
    'Меня накрыл стресс' => 'Я тревожусь',
    'Я переживаю из-за будущего' => 'Я тревожусь',
    'Я устала' => 'Усталость',
    'Усталость' => 'Усталость',
    'Эмоциональное истощение' => 'Эмоциональное истощение',
    'Мне ничего не хочется' => 'Мне ничего не хочется',
    'Слишком много задач' => 'Я перегружена задачами',
    'Слишком много информации' => 'У меня хаос в голове',
    'Я не могу начать' => 'Я не могу сфокусироваться',
    'Я распыляюсь' => 'Я не могу сфокусироваться',
    'Усталость от общения' =>
      'Мне нужно восстановиться после тяжёлого разговора',
    'Был тяжёлый разговор' =>
      'Мне нужно восстановиться после тяжёлого разговора',
    'Мне нужно собраться перед встречей' =>
      'Мне нужно быстро собраться перед встречей',
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
