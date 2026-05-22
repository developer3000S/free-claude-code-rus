# Patrones matplotlib por Tipo de Contenido

## 1. Funciones Matematicas

### Funcion basica

```python
x = np.linspace(-5, 5, 1000)
y = x**2 - 4*x + 3

fig, ax = plt.subplots(figsize=(8, 6))
ax.plot(x, y, 'b-', linewidth=2, label=r'$f(x)=x^2-4x+3$')
ax.axhline(y=0, color='k', linewidth=0.5)
ax.axvline(x=0, color='k', linewidth=0.5)
ax.grid(True, alpha=0.3)
ax.legend()
```

### Multiples funciones

```python
ax.plot(x, x**2, 'r-', linewidth=2, label=r'$y=x^2$')
ax.plot(x, 2*x + 1, 'b--', linewidth=2, label=r'$y=2x+1$')
ax.plot(x, np.sin(x), 'g:', linewidth=2, label=r'$y=\sin(x)$')
```

### Funciones trigonometricas

```python
x = np.linspace(0, 2*np.pi, 500)
ax.plot(x, np.sin(x), 'b-', label=r'$\sin(x)$')
ax.plot(x, np.cos(x), 'r-', label=r'$\cos(x)$')
ax.set_xticks([0, np.pi/2, np.pi, 3*np.pi/2, 2*np.pi])
ax.set_xticklabels(['0', r'$\frac{\pi}{2}$', r'$\pi$',
                   r'$\frac{3\pi}{2}$', r'$2\pi$'])
```

## 2. Figuras Geometricas

### Triangulo

```python
import matplotlib.patches as patches

vertices = [(0, 0), (4, 0), (2, 3)]
triangle = patches.Polygon(vertices, fill=False, edgecolor='black', linewidth=2)
ax.add_patch(triangle)

# Etiquetas
ax.text(0, 0, 'A', fontsize=12, ha='right', va='top')
ax.text(4, 0, 'B', fontsize=12, ha='left', va='top')
ax.text(2, 3, 'C', fontsize=12, ha='center', va='bottom')
ax.set_aspect('equal')
ax.axis('off')
```

### Circulo

```python
circle = plt.Circle((0, 0), 2, fill=True, facecolor='blue',
                    alpha=0.3, edgecolor='blue', linewidth=2)
ax.add_patch(circle)
ax.plot([0, 2], [0, 0], 'k-', linewidth=1)  # Radio
ax.set_aspect('equal')
```

### Poligono regular

```python
n = 5  # pentagono
angles = np.linspace(0, 2*np.pi, n+1)
x = np.cos(angles)
y = np.sin(angles)
ax.plot(x, y, 'b-', linewidth=2)
ax.fill(x, y, alpha=0.3, color='blue')
ax.set_aspect('equal')
```

## 3. Graficos Estadisticos

### Barras

```python
categories = ['A', 'B', 'C', 'D']
values = [12, 18, 7, 22]

bars = ax.bar(categories, values, color='#4CAF50', width=0.6,
              edgecolor='black', linewidth=1.2)

for bar in bars:
    height = bar.get_height()
    ax.text(bar.get_x() + bar.get_width()/2., height,
            f'{int(height)}', ha='center', va='bottom')
```

### Histograma

```python
data = np.random.normal(100, 15, 1000)
ax.hist(data, bins=20, edgecolor='black', color='skyblue', alpha=0.7)
```

### Dispersion con regresion

```python
ax.scatter(x, y, c='blue', s=50, alpha=0.6, edgecolors='black')
z = np.polyfit(x, y, 1)
p = np.poly1d(z)
ax.plot(x, p(x), 'r--', linewidth=2, label='Tendencia')
```

### Circular (pie)

```python
sizes = [30, 25, 20, 25]
labels = ['A', 'B', 'C', 'D']
colors = ['#FF6B6B', '#4ECDC4', '#45B7D1', '#FFA07A']
ax.pie(sizes, labels=labels, colors=colors, autopct='%1.1f%%', startangle=90)
```

## 4. Vectores

```python
vectors = [(0, 0, 3, 2), (0, 0, -2, 3)]
colors = ['red', 'blue']

for (x, y, dx, dy), color in zip(vectors, colors):
    ax.arrow(x, y, dx, dy, head_width=0.2, head_length=0.2,
             fc=color, ec=color, linewidth=2)

ax.set_aspect('equal')
ax.axhline(y=0, color='k', linewidth=0.5)
ax.axvline(x=0, color='k', linewidth=0.5)
```
