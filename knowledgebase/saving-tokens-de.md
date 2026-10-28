# KI-Tokenverbrauch, Caching und Kostenoptimierung

> **Hinweis:** KI-Agenten-Tools, Modelle, Integrationen, Preise sowie das Verhalten von Kontext und Caching ändern sich schnell. Prüfe die aktuelle Dokumentation und teste typische Aufgaben in deiner Umgebung, bevor du dich auf Aussagen zu Kompatibilität oder Einsparungen verlässt.

## TL;DR

Gehe bewusst mit Kontext und Caching um, wähle ein zur jeweiligen Aufgabe passendes Modell und halte den Projektkontext übersichtlich. So können Agents effizient arbeiten und ihre Ergebnisse überprüfen. Der Tokenverbrauch wirkt sich auf die Kosten aus, während zu viel Kontext die Ausgabequalität beeinträchtigen kann. Beginne bei einem Aufgabenwechsel einen neuen Chat oder übergib nur den relevanten Kontext. Nutze Tools, Skills und Hooks, um unnötige Informationen nicht zu laden.

**Inhalt**

- [Tokenverbrauch verstehen](#tokenverbrauch-verstehen)
  - [Wichtige Faktoren](#wichtige-faktoren)
  - [Tokenarten](#tokenarten)
  - [So funktioniert Prompt-Caching](#so-funktioniert-prompt-caching)
    - [Beispiel: Warum eine Kaffeepause teuer werden kann](#beispiel-warum-eine-kaffeepause-teuer-werden-kann)
  - [Häufige Ursachen für Cache Misses](#häufige-ursachen-für-cache-misses)
- [Warum das wichtig ist](#warum-das-wichtig-ist)
- [Empfehlungen zur Senkung von Kosten und Tokenverbrauch](#empfehlungen-zur-senkung-von-kosten-und-tokenverbrauch)
  - [Kurzfristige Optimierungen](#kurzfristige-optimierungen)
    - [Nutzung überprüfen](#nutzung-überprüfen)
    - [Kontext optimieren](#kontext-optimieren)
    - [Geladenen Kontext bereinigen](#geladenen-kontext-bereinigen)
    - [Ein passendes Modell und Reasoning-Level auswählen](#ein-passendes-modell-und-reasoning-level-auswählen)
    - [Skills für wiederkehrende Aufgaben nutzen](#skills-für-wiederkehrende-aufgaben-nutzen)
    - [Deterministische Aufgaben in Skripte umwandeln](#deterministische-aufgaben-in-skripte-umwandeln)
    - [Aufgaben und Prompts im Voraus planen](#aufgaben-und-prompts-im-voraus-planen)
  - [Langfristige Optimierung: Die Codebasis für Agents vorbereiten](#langfristige-optimierung-die-codebasis-für-agents-vorbereiten)
  - [Weitere Ressourcen](#weitere-ressourcen)
    - [Tools](#tools)
      - [Nutzung und Kosten überwachen](#nutzung-und-kosten-überwachen)
      - [Kontext abrufen und Ausgaben filtern](#kontext-abrufen-und-ausgaben-filtern)
      - [Codebasis für KI aufbereiten](#codebasis-für-ki-aufbereiten)
    - [Skills](#skills)
    - [Best Practices für `AGENTS.md` und `CLAUDE.md`](#best-practices-für-agentsmd-und-claudemd)
- [Weitere Überlegungen](#weitere-überlegungen)
- [Fazit](#fazit)


## Tokenverbrauch verstehen

### Wichtige Faktoren

- **Tokens:** Die Textmenge, die ein Modell verarbeitet. Tokens sind die gängigste Maßeinheit dafür.
- **Modell:** Das Modell beeinflusst, wie viel Rechenleistung jedes Token benötigt. Leistungsfähigere Modelle benötigen im Allgemeinen mehr Rechenleistung pro Token.
- **Compute-Budget:** Die verfügbare Rechenleistung, zum Beispiel das in einem Abonnement enthaltene Kontingent.

```
Verbrauchtes Compute-Budget = verbrauchte Tokens × verwendetes Modell
```


### Tokenarten

Bei der Nutzung von KI-Modellen, auch über Coding-Agents, werden Eingaben und Ausgaben in Tokens gemessen. Für verschiedene Tokenarten können unterschiedliche Preise gelten.

| Tokenart | Bedeutung | Kosten |
| --- | --- | --- |
| Input-Tokens | Dein Prompt, der bisherige Chatverlauf und weiterer Kontext, der dem Modell bereitgestellt wird | Üblicher Input-Preis |
| Output-Tokens | Generierte Antworten, Code, Tool-Aufrufe und andere Ausgaben | In der Regel deutlich teurer als Input |
| Reasoning-Tokens | Interne Denkschritte, die das Modell bei komplexen Aufgaben ausführt | Werden normalerweise zum Output-Token-Preis abgerechnet |
| Gecachte Input-Tokens | Bereits verarbeitete Eingaben, die aus einem Cache wiederverwendet werden können | Deutlich günstiger als normaler Input |

Ein Coding-Agent verarbeitet mehr als nur deinen letzten Prompt. Er kann dem Modell auch den bisherigen Chatverlauf, Systemanweisungen, Tool-Beschreibungen und relevanten Code erneut senden.


### So funktioniert Prompt-Caching

Prompt-Caching ermöglicht es einem Modell, bereits verarbeitete Teile eines Chatverlaufs wiederzuverwenden.

- **Cache-Hit:** Der relevante Teil des Chatverlaufs ist unverändert und noch im Cache verfügbar. Wiederverwendete Input-Tokens werden zum günstigeren Cache-Preis abgerechnet.
- **Cache-Miss:** Der relevante Teil des Chatverlaufs hat sich geändert oder der Cache ist abgelaufen. Die betroffenen Input-Tokens müssen dann erneut zum regulären Input-Preis verarbeitet werden.

#### Beispiel: Warum eine Kaffeepause teuer werden kann

Stell dir vor, du arbeitest schon eine Weile mit einem Coding-Agent an einem Projekt. Der Agent hat deine Anforderungen, deinen Code und den Chatverlauf bereits im Kontext.

Du machst eine zehnminütige Pause. Wenn du zurückkommst, kann Folgendes passieren:

1. Der Cache ist abgelaufen.
2. Du sendest eine neue Nachricht.
3. Der Agent muss den bisherigen Kontext erneut verarbeiten.
4. Für Tokens, die nicht mehr im Cache liegen, zahlst du statt des vergünstigten Cache-Preises den regulären Input-Preis.

Das kann die Kosten deutlich erhöhen, besonders bei langen Unterhaltungen. Die Pause selbst verbraucht keine Tokens. Entscheidend ist, ob der Cache bei deiner Rückkehr noch verfügbar ist.

Ein Cache-Fehler bedeutet nicht immer, dass die gesamte Unterhaltung erneut zum vollen Preis verarbeitet werden muss. Je nach Anbieter, Funktionsweise des Caches und den Änderungen am Prompt können nur einzelne Teile betroffen sein.

### Häufige Ursachen für Cache Misses

- **Lange Pausen zwischen Nachrichten:** Der Cache läuft nach einer bestimmten Zeit ab. Wie lange er verfügbar bleibt, hängt vom Modell und Anbieter ab.
- **Modellwechsel:** Zum Beispiel der Wechsel von einem Modell zu einem anderen, etwa von Opus zu Sonnet.
- **Änderung des Reasoning-Levels:** Zum Beispiel der Wechsel von High zu Extra High, sofern sich dadurch die Cache-Kompatibilität ändert.
- **Änderungen an Tools oder MCP-Servern:** Neue Tool-Beschreibungen können den Anfang des Prompts verändern.
- **Änderungen an System-Prompts:** Wenn sich die ursprünglichen Anweisungen des Agents ändern, kann der vorhandene Cache teilweise oder vollständig unbrauchbar werden.

Ob eine bestimmte Änderung tatsächlich zu einem Cache-Fehler führt, hängt von der Implementierung des Cachings ab. Entscheidend ist, ob der wiederverwendbare Teil am Anfang des Prompts gleich bleibt.

## Warum das wichtig ist

1. **Kosten und Monatsbudgets:** Der Tokenverbrauch summiert sich über Prompts und Antworten hinweg. Wenn du ihn im Blick behältst, kannst du dein Budget besser einhalten.
2. **Die DumbZone:** Mit wachsendem Kontext muss ein Modell mehr Informationen und Zusammenhänge im Blick behalten. Die Qualität der Ausgabe kann dadurch allmählich sinken, statt plötzlich abzufallen. Es gibt keine Einigkeit darüber, ab wann die DumbZone beginnt; das hängt vom Modell und der Aufgabe ab. Als grobe Faustregel gelten etwa 150.000 Tokens.

## Empfehlungen zur Senkung von Kosten und Tokenverbrauch

Die Empfehlungen gliedern sich in kurzfristige Maßnahmen für den Alltag und langfristige Verbesserungen an deiner Codebasis.

### Kurzfristige Optimierungen

#### Nutzung überprüfen

- <img src="./images/claude-code.svg" alt="Claude Code" width="20" /> **Claude:** Mit `/usage` siehst du, wie viele Tokens du verbraucht hast und wodurch dein Kontingent genutzt wird. Mit `/context` kannst du den aktuellen Chat-Kontext überprüfen.
- <img src="./images/githubcopilot.svg" alt="GitHub Copilot" width="20" /> **GitHub Copilot:** Prüfe den Verbrauch deiner AI Credits.

#### Kontext optimieren

- Wenn du die Aufgabe wechselst, führe `/clear` aus oder starte einen neuen Chat. Ein langer Chatverlauf muss bei jeder neuen Nachricht möglicherweise erneut berücksichtigt werden. Bei einer anderen Aufgabe solltest du einen neuen Chat beginnen, statt nicht mehr benötigten Kontext mitzunehmen.
- Wenn du den bisherigen Kontext behalten musst, nutze Handoff- oder Compaction-Skills und -Tools, um mit den relevanten Informationen eine neue Session zu starten. Ein Handoff-Dokument sollte Folgendes enthalten:
  - Aktueller Implementierungsstand
  - Relevante Architekturentscheidungen
  - Geänderte Dateien
  - Offene Punkte
  - Konkrete nächste Schritte
- Arbeite möglichst kontinuierlich, statt lange Pausen zwischen Nachrichten zu lassen. Wenn du zehn Minuten mit der Antwort wartest, profitierst du möglicherweise nicht mehr vom Caching. Die Cache-Einstellungen unterscheiden sich je nach Tool.
- <img src="./images/claude-code.svg" alt="Claude Code" width="20" /> Passe das Effort-Level an.
- <img src="./images/githubcopilot.svg" alt="GitHub Copilot" width="20" /> Bei GitHub Copilot hängt die Verfügbarkeit von der Plugin-Version ab. Das Effort-Level ist zum Beispiel derzeit in VS Code verfügbar.

#### Geladenen Kontext bereinigen

- Entferne Skills, MCP-Server, Connectoren und Plugins, die du nicht verwendest.
- Kürze Skill-Beschreibungen oder deaktiviere bei Bedarf die Modellaufrufe:

  ```yaml
  name: my-skill
  description: Runs a complex workflow
  disable-model-invocation: true
  ```

- Kürze `AGENTS.md`- oder <img src="./images/claude-code.svg" alt="Claude Code" width="20" /> `CLAUDE.md`-Dateien und orientiere dich dabei an den [Best Practices](#best-practices-für-agentsmd-und-claudemd).

#### Ein passendes Modell und Reasoning-Level auswählen

Verwende ein leistungsfähiges Modell, wenn eine Aufgabe es erfordert. Für einfache Refactorings, kleine Änderungen oder Dokumentation reicht oft ein günstigeres Modell. Höhere Reasoning-Levels sind nicht immer effizienter: Sie können die Erfolgsquote verbessern, aber auch die Kosten deutlich erhöhen.

Ein günstigeres Modell bedeutet nicht immer eine günstigere Lösung. Wiederholte Überlegungen, zusätzliche Prompts, Debugging und Codeänderungen können die Aufgabe insgesamt verteuern.

Beispiele:

- Verwende ein leistungsfähigeres Modell zur Koordination und kleinere Modelle für bestimmte Teilaufgaben, die Subagents übernehmen. Bei manchen Skills kannst du festlegen, welches Modell verwendet wird.
- Nutze einen integrierten Planungsmodus oder einen Planning-Skill mit einem leistungsfähigeren Modell und anschließend ein schnelleres, kleineres Modell zur Umsetzung des Plans.

#### Skills für wiederkehrende Aufgaben nutzen

Wenn du häufig dieselben Aufgaben erledigst, etwa Code-Reviews, Dokumentation oder Refactorings, erstelle wiederverwendbare Skills oder Anweisungen. Dadurch werden Prompts einheitlicher, Anforderungen klarer und unnötige Rückfragen seltener. Achte darauf, dass der Skill selbst nicht zu viel Kontext hinzufügt.

#### Deterministische Aufgaben in Skripte umwandeln

Agents können oft gut Skripte für Aufgaben schreiben, die nach vorhersehbaren Schritten ablaufen.

#### Aufgaben und Prompts im Voraus planen

Lege Aufgabe und Rahmenbedingungen von Anfang an fest, statt den Prompt durch wiederholte Versuche zu verfeinern.

Ein hilfreiches Prompt-Schema:

1. **Der Auftrag:** Die Aufgabe oder das Ziel.
2. **Das Warum:** Warum die Aufgabe wichtig ist.
3. **Die Leitplanken:** Was schiefgehen kann und welche Regeln das verhindern.
4. **Abschlusskriterien:** Woran du erkennst, dass die Aufgabe erledigt ist.

Du kannst ein Modell bitten, Ideen zu einem Thema zu sammeln und anschließend beim Formulieren des Prompts zu helfen. Skills wie [grilling](https://github.com/mattpocock/skills/blob/main/skills/productivity/grilling/SKILL.md) können dabei helfen.

**Beispiel-Prompt zur Prüfung des Kontexts beim Session-Start:**

```text
Prüfe alles, was zu Beginn einer Session in meinen Kontext geladen wird, und hilf mir, den Umfang zu reduzieren. Drei Bereiche:
1. MCPs: Liste alle verbundenen MCP-Server auf und kennzeichne diejenigen, die ich nicht verwendet habe. Empfiehl, welche ich entfernen sollte.
2. Skills: Liste meine Skills und ihre Beschreibungen auf. Kennzeichne ungenutzte Skills, die gelöscht werden können, und kürze unnötig lange Beschreibungen.
3. AGENTS.md: Kürze die Datei auf weniger als 200 Zeilen, ohne die Funktionsweise des Systems zu verlieren.

Zeige mir deine Empfehlungen, bevor du etwas entfernst oder bearbeitest.
```

**Beispiel-Prompt, um Skills in Skripte umzuwandeln:**

```text
Analysiere mein Projekt und finde Schritte in meinen vorhandenen Skills, die sich als Skripte umsetzen lassen. Nenne diese Skills und erkläre, wie du sie in Skills mit Skriptunterstützung umwandeln würdest.

Prüfe den gesamten Gesprächsverlauf und finde heraus, ob ich weitere Skills erstellen sollte.
```

### Langfristige Optimierung: Die Codebasis für Agents vorbereiten

Das Ziel ist, einem Coding-Agent zu helfen, dein Projekt schnell zu verstehen, weniger Fehler zu machen und seine Ergebnisse zu überprüfen.

1. **Bewährte Technologien verwenden.** Bevorzuge gut dokumentierte, weit verbreitete Frameworks und Bibliotheken, mit denen Modelle vertraut sind und zu denen es viele Beispiele gibt.
2. **Eine klare Projektstruktur schaffen.** Ein Monorepo kann einem Agent helfen, die Zusammenhänge zwischen Frontend, Backend und gemeinsamen Paketen zu verstehen. Wichtiger als die konkrete Repository-Strategie sind klare Abhängigkeiten, einheitliche Konventionen und eine Struktur, in der sich relevanter Code leicht finden lässt.
3. **Dokumentation so organisieren, dass Details leicht zu finden sind.** Erstelle eine knappe `AGENTS.md`, die erklärt, wie der Agent im Repository arbeiten soll, und verweise darin auf spezialisierte Dokumente, zum Beispiel:
   - `docs/vision.md` — Projektvision und Ziele
   - `docs/db.md` — Datenbankentscheidungen
   - `docs/api.md` — API-Konventionen
   - Architektur- und Entwicklungsrichtlinien

   Der Agent erhält zunächst nur die wichtigsten Informationen und liest bei Bedarf weitere Dokumentation. So wird unnötiger Kontext reduziert und die zentralen Anweisungen bleiben übersichtlich.
4. Benutzerdefinierte **Hooks** können Daten aufbereiten, bevor ein Agent sie sieht. Statt eine 10.000 Zeilen lange Logdatei nach Fehlern zu durchsuchen, kann ein Hook nach `ERROR` suchen und nur passende Zeilen zurückgeben. Dadurch wird der Kontextumfang reduziert.

### Weitere Ressourcen

#### Tools

##### Nutzung und Kosten überwachen
- [Token Optimizer](https://github.com/alexgreensh/token-optimizer/tree/main) reduziert unnötige Tokens, erhält deine Arbeit über Sessions und Compactions hinweg und zeigt dir die Ausgaben in einem Live-Dashboard.

##### Kontext abrufen und Ausgaben filtern
- [Code Review Graph](https://github.com/tirth8205/code-review-graph) ermöglicht die Suche in einem Graphen über MCP, statt Dateien in Abschnitten lesen zu müssen.
- [RTK](https://github.com/rtk-ai/rtk) filtert und kürzt Kommandoausgaben, bevor sie im Kontext deines Modells landen.

##### Codebasis für KI aufbereiten
- [Gitingest](https://github.com/coderamp-labs/gitingest) wandelt ein Git-Repository in Text um, der sich leichter in einen Prompt aufnehmen lässt. Für sehr große Codebasen ist es möglicherweise ungeeignet.
- [Repomix](https://github.com/yamadashy/repomix) verpackt deine Codebasis in Formaten, die sich gut mit KI-Tools verwenden lassen.

#### Skills

- [intent-layer](https://github.com/crafter-station/skills/tree/main/skills/intent-layer) erstellt hierarchische `AGENTS.md`-Dateien, die Agents bei der Orientierung in Codebasen helfen. Es funktioniert nur mit Harnesses, die hierarchische `AGENTS.md`-Dateien unterstützen. In <img src="./images/githubcopilot.svg" alt="GitHub Copilot" width="20" /> GitHub Copilot ist diese Funktion derzeit experimentell.
- [handoff](https://github.com/mattpocock/skills/tree/main/skills/productivity/handoff) wandelt die aktuelle Unterhaltung in ein Handoff-Dokument um, das ein anderer Agent verwenden kann.

#### Best Practices für `AGENTS.md` und `CLAUDE.md`

- Halte die Dateien unter 300 Zeilen.
- Nenne die **Motivation**: Erkläre in einem Satz, was das Projekt bezweckt und warum es existiert.
- Dokumentiere **nicht offensichtliche Tools**:
  - Führe Befehle auf, die im Repository nicht offensichtlich sind.
  - KI-Modelle wurden oft mit älteren Framework-Versionen trainiert. Halte deshalb mögliche Stolperfallen bei neueren Versionen fest.
- Erstelle eine knappe **Architekturübersicht**. Sie muss nicht vollständig sein und keine Diagramme enthalten, sollte aber alles Ungewöhnliche abdecken, zum Beispiel `intent-layer`.
- Formuliere **überprüfbare Anweisungen**. Schreibe zum Beispiel „Alle SQL-Abfragen parametrisieren“ statt „Sauberen Code schreiben“.
- Nenne **feste Vorgaben und Anti-Patterns**.
- Verweise auf ausführlichere Dokumentation, wenn die Datei zu lang wird.
- Halte **Fallstricke und gemeinsames Wissen** fest, einschließlich Lösungen für aufgetretene Probleme.

## Weitere Überlegungen

- <img src="./images/claude-code.svg" alt="Claude Code" width="20" /> Claude benötigt möglicherweise weniger Tokens, wenn du Text als Bild statt als Klartext einfügst. [PXPipe](https://github.com/teamchong/pxpipe) kann Text in Bilder umwandeln. Das könnte sich in Zukunft ändern.
- Du kannst Modelle lokal ausführen. Dadurch sinkt nicht der Tokenverbrauch, aber möglicherweise die Kosten. Dafür ist leistungsstarke Hardware nötig, und Open-Source-Modelle sind derzeit weniger leistungsfähig.

## Fazit

Die größten Einsparungen entstehen nicht dadurch, dass jeder Prompt künstlich verkürzt wird. Entscheidend sind ein bewusster Umgang mit Kontext und Caching, die Wahl des passenden Modells und eine Codebasis, die dem Agent hilft, die Aufgabe zu verstehen und seine Arbeit zu überprüfen.


## Offizielle Referenzen

### <img src="./images/claude-code.svg" alt="Claude Code" width="20" /> Claude

- [Prompting best practices for Claude](https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/claude-prompting-best-practices) — Behandelt explizite Anweisungen, Ausgabeformate und Einschränkungen, aufeinander aufbauende Schritte, Kontext, Beispiele und die Strukturierung von Prompts.
- [Prompt engineering overview for Claude](https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/overview) — Empfiehlt, Erfolgskriterien und Möglichkeiten zu ihrer Überprüfung zu definieren, bevor ein Prompt verfeinert wird.
- [Prompt caching (Claude API)](https://platform.claude.com/docs/en/build-with-claude/prompt-caching) — Wie präfixbasiertes Caching funktioniert, automatische und explizite Cache-Breakpoints sowie Cache-Laufzeiten von 5 Minuten und 1 Stunde.
- [How Claude Code uses prompt caching](https://code.claude.com/docs/en/prompt-caching) — Erklärt die Cache-Ebenen, warum Modell- oder Effort-Wechsel und `/compact` den Cache ungültig machen und wie du deine Cache-Trefferquote prüfst.
- [Manage costs effectively (Claude Code)](https://code.claude.com/docs/en/costs) — Nutzung mit `/usage` verfolgen und den Tokenverbrauch senken.
- [Token counting (Claude API)](https://platform.claude.com/docs/en/build-with-claude/token-counting) — Tokens zählen, bevor eine Anfrage gesendet wird; die Zahlen sind Schätzungen.
- [Pricing (Claude API)](https://platform.claude.com/docs/en/about-claude/pricing) — Preise für Input, Output, Cache-Schreibzugriffe und Cache-Lesezugriffe pro Modell.

### <img src="./images/githubcopilot.svg" alt="GitHub Copilot" width="20" /> GitHub Copilot

- [Prompt engineering for GitHub Copilot](https://docs.github.com/en/copilot/concepts/prompting-and-context/prompt-engineering) — Behandelt klare Anforderungen, Beispiele, das Aufteilen komplexer Aufgaben, das Vermeiden von Mehrdeutigkeit, relevanten Kontext und einen relevanten Gesprächsverlauf.
- [Usage-based billing for individuals (GitHub Copilot)](https://docs.github.com/en/copilot/concepts/billing-and-usage/individuals/billing) — AI Credits, wie Input-, Output- und gecachte Tokens abgerechnet werden und was die Nutzung beeinflusst.
- [Optimizing your AI usage to maximize efficiency and reduce cost (GitHub Copilot)](https://docs.github.com/en/copilot/tutorials/optimize-ai-usage) — Modellauswahl, Reasoning-Level, klare Prompts und den Cache erhalten.
