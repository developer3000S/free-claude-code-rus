# Estructura de Lecciones Aprendidas

## Archivo de Almacenamiento

```
outputs/lecciones_aprendidas.json
```

## Estructura Inicial

```json
{
  "timestamp_inicio": "2025-12-29T10:30:00Z",
  "timestamp_ultima_actualizacion": "2025-12-29T10:30:00Z",
  "tikz": {
    "exitos": [],
    "problemas": []
  },
  "python": {
    "aplicar_de_tikz": [],
    "exitos": [],
    "problemas": []
  },
  "r": {
    "aplicar_de_tikz": [],
    "aplicar_de_python": [],
    "exitos": [],
    "problemas": []
  }
}
```

## Registro de Exitos

```json
{
  "descripcion": "Usar pgfplots con axis environment para funciones suaves",
  "categoria": "funciones",
  "codigo_ejemplo": "\\begin{axis}[...]\\addplot {x^2};\\end{axis}",
  "iteracion": 2
}
```

## Registro de Problemas

```json
{
  "descripcion": "Posicionamiento de etiquetas requirio 3 iteraciones para ajustar",
  "categoria": "posicionamiento",
  "solucion": "Usar coordenadas relativas con anchor y shift para posicionamiento preciso",
  "iteraciones_requeridas": 3
}
```

## Registro de Aplicacion

```json
{
  "leccion": "Color RGB(0,102,204) funciono perfectamente en TikZ",
  "aplicacion": "Usar mismo RGB en matplotlib: color='#0066CC'",
  "resultado": "exitoso"
}
```

## Categorias Disponibles

| Categoria | Descripcion |
|-----------|-------------|
| colores | Codigos RGB/Hex, paletas, transparencia |
| posicionamiento | Coordenadas, alineacion, anclas |
| estilos | Grosores, tipos de linea, fuentes |
| funciones | Librerias, metodos de renderizado |
| anotaciones | Texto, formulas, etiquetas |
| otro | Cualquier otra leccion |
