# CORE — infrastructură partajată

Cod folosit de mai multe straturi, care nu aparține niciunui feature anume.

| Subfolder | Ce conține |
|---|---|
| `network/` | `ApiClient` — clientul HTTP (GET, decode JSON, timeout) |
| `error/` | `Failure` — eroarea standardizată care circulă între straturi |
| `constants/` | `ApiConstants` — baza URL-urilor și căile endpoint-urilor |
| `theme/` | tema vizuală (paleta portocalie, fonturi, etc.) |
| `widgets/` | widget-uri comune (`AppSvg`, `StateViews`, …) |

`core/` nu conține logică de business. Este „sculele" folosite de `data/`
și `presentation/`.
