# CREATION-LOG: skill-selector

## Синтез

**Дата:** 2026-03-07
**Версия:** 1.0.0
**Тип:** оригинальная концепция (не синтез из внешних источников)

---

## Источники проанализированы

| Источник | URL / Path | Дата обновления | Semantic match | Итоговый балл |
|---|---|---|---|---|
| User's design proposal | эта беседа (AGIntS session 2026-03-07) | 2026-03-07 | exact | 87/60×1.5 |
| All-The-Vibes/skills-catalog/SKILL_SELECTOR.md | https://github.com/All-The-Vibes/skills-catalog | 2026-03 | adjacent | 22/60 |
| anthropics/skills/skill-creator/SKILL.md | https://github.com/anthropics/skills | 2026-03 | adjacent | 42/60×1.5 |
| superpowers/subagent-driven-development/SKILL.md | refs/superpowers/skills/subagent-driven-development/ | 2025-11 | adjacent | 42/60×1.2 |
| superpowers/using-superpowers/SKILL.md | refs/superpowers/skills/using-superpowers/ | 2025-11 | adjacent | 24/60×1.2 |

**Поиск через GitHub MCP:** search_code был недоступен в этой сессии из-за бага
с именем env var (`GITHUB_TOKEN` vs `GITHUB_PERSONAL_ACCESS_TOKEN`). Баг
исправлен в ~/.claude.json — следующие сессии получат полный search_code.
Поиск через get_file_contents позволил найти All-The-Vibes/SKILL_SELECTOR.md.

Итого найдено: 5 источников (порог 5+ выполнен).

---

## Выбран за основу

**Источник:** User's design proposal (оригинальная архитектурная идея пользователя)

**Причина:** Это новая концепция, описанная пользователем в двух итерациях беседы.
Все внешние источники нашли только СМЕЖНЫЕ паттерны (human skill selection, skill creation,
executor orchestration), но не сам паттерн "plan-level skill injection agent". Первичный
источник — единственный точный источник.

---

## Взято из каждого источника

| Источник | Что взято | Почему |
|---|---|---|
| User's design proposal | Всё ядро: роли, CAPSULE loading, gap detection, budget, LOAD levels, USE_SKILL format | Оригинальный источник концепции |
| anthropics/skill-creator | Подтверждение 3-уровневой загрузки ("Metadata ~100 words always in context") | Валидирует CAPSULE как эффективный механизм роутинга |
| superpowers/SDD | "Controller provides full text to subagent" паттерн | Skill Selector → controller role; executor isolation pattern |
| All-The-Vibes/SKILL_SELECTOR | Decision tree + role-based selection pattern | Структурный аналог для PROCESS шагов |
| superpowers/using-superpowers | Разница session-level vs plan-level dispatch | Помогло чётко сформулировать: "NOT session_level" в ROLE блоке |

---

## Отброшено

| Что | Источник | Причина |
|---|---|---|
| PRIORITY 0-100 числовой | User's proposal v1 | Слишком гранулярно, нереализуемо → заменено на critical/standard/optional |
| Usage tracking | User's proposal v1 | Требует persistent state между сессиями — отложено в Future Extensions FULL.md |
| Skill pruning | User's proposal v1 | То же — отложено в Future Extensions |
| Human decision-tree формат | All-The-Vibes/SKILL_SELECTOR.md | Это для людей, не для агентов; не подходит |
| Skill A/B testing | User's proposal v1 | Future Extensions; слишком рано |

---

## Ключевые архитектурные решения

1. **ROLE := plan_level_agent** — не session-level (это using-agints) и не executor.
   Запускается один раз на план, перед dispatch.

2. **CAPSULE.md как первичный механизм роутинга** — Skill Selector читает ТОЛЬКО капсулы
   (не полные SKILL.md) для принятия решений. 300 скиллов × ~50 токенов = ~15K токенов.
   Без CAPSULE.md скилл невидим для роутера.

3. **USE_SKILL встроен в тело шага** (не в отдельный блок) — load происходит
   именно при выполнении шага, не при чтении плана.

4. **executor_doing_skill_discovery → FORBIDDEN** — ключевое ограничение.
   Освобождает контекст executor'а для задачи, а не для роутинга.

5. **Gaps → proposals only** — автоматическое создание скиллов без подтверждения человека
   намеренно исключено.

---

## Требует ручного ревью

- [ ] Протестировать на реальном плане из writing-plans (≥8 шагов)
- [ ] Уточнить escalation rules — сейчас только пример с test_failure
- [ ] Проверить CAPSULE.md-формат на совместимость с существующими скиллами
      (у writing-skills, brainstorming, TDD нет CAPSULE.md — нужно добавить)
- [ ] Lifecycle = "experimental" → перевести в "stable" после 3+ реальных применений
- [ ] Добавить в using-agints упоминание skill-selector как следующего шага после планирования

---

## Тестирование

**Дата:** 2026-03-07

| Сценарий | Тип | Результат | Примечание |
|---|---|---|---|
| Budget pressure (7 skills, budget 6) | discipline | PASS | Агент выбрал A: enforce budget, drop optional |
| Executor isolation (Redis skill missing) | discipline | PASS | Агент выбрал A: escalate, не искать самостоятельно |

**Итог:** PASS

Оба сценария покрывают два главных риска:
1. social pressure на нарушение budget rule
2. executor нарушает isolation, делает skill discovery сам

Дополнительные сценарии (конфликт скиллов, gap detection точность, skip when appropriate)
вынесены в tests/TODO.md для ручного ревью после добавления CAPSULE.md в существующие скиллы.
