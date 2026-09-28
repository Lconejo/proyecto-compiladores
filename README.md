# Proyecto Compiladores

Actualmente se está trabajando la `Parte 1`, que consiste en un **Analizador Léxico para C**.

---

## Las clases de los componentes léxicos válidos para el analizador léxico son: 

| Clase | Descripción |
|-------|-------------|
| **0** | Operadores aritméticos: `+`, `-`, `/`, `*`, `%`, `1` |
| **1** | Operadores lógicos (ver tabla). |
| **2** | Operadores relacionales (ver tabla). |
| **3** | Constantes numéricas enteras en base 10. Si están con signo, se encierran entre paréntesis. Ejemplos: `0`, `672`, `(-265)`, `(+49)` |
| **4** | Palabras reservadas (ver tabla). |
| **5** | Identificadores: inician con `_` seguido de una letra (mayúscula o minúscula). Después pueden contener letras, dígitos y `_`. |
| **6** | Símbolos especiales: `( ) { } ; , [ ] : #` |
| **7** | Operadores de asignación (ver tabla). |
| **8** | Constantes cadenas: encerradas entre comillas `"..."`. Pueden incluir cualquier secuencia de caracteres, incluso salto de línea. |
| **9** | Operadores sobre cadenas (ver tabla). |

