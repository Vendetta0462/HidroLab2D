# HidroLab2D: Laboratorio Virtual de Inestabilidad de Plateau-Rayleigh 🧪💧

## Descripción General ✨

HidroLab2D es un laboratorio virtual diseñado para el estudio y la visualización de la inestabilidad de Plateau-Rayleigh (IPR) en dos dimensiones. Este proyecto utiliza simulaciones numéricas avanzadas para modelar la ruptura de columnas líquidas en gotas, un fenómeno fundamental en la dinámica de fluidos con aplicaciones en áreas como la impresión por inyección de tinta, la microfluídica y la astrofísica.

El objetivo principal de HidroLab2D es proporcionar una herramienta interactiva que permita a investigadores y estudiantes explorar la IPR bajo diversas condiciones, ofreciendo un control directo sobre los parámetros del sistema y facilitando la comprensión de su compleja evolución no lineal.

## Métodos Numéricos 💻

La simulación se basa en la resolución de las ecuaciones de Euler para fluidos compresibles. Los métodos numéricos implementados incluyen:

-   **Método de Volúmenes Finitos (MVF):** Utilizado para la discretización espacial, garantizando la conservación de cantidades físicas fundamentales y la capacidad de capturar discontinuidades (como la formación de gotas).
-   **Solucionador de Riemann (HLL) y Limitador Minmod:** Empleados para manejar las discontinuidades y mantener la estabilidad numérica.
-   **Runge-Kutta Dormand-Prince (RKDP) con Paso Adaptativo:** Un integrador temporal de orden 5(4) que ajusta dinámicamente el tamaño del paso de tiempo para optimizar la eficiencia y la precisión de la simulación.

## Concepto de Laboratorio Virtual 🔬

HidroLab2D transforma la simulación en un entorno experimental virtual. Permite al usuario:

-   **Modificar parámetros:** Ajustar condiciones iniciales, propiedades del fluido y parámetros numéricos a través de un archivo de configuración (`input.par`).
-   **Ejecutar simulaciones:** Compilar y correr el código Fortran con los parámetros definidos.
-   **Visualizar resultados:** Generar animaciones y datos 2D que muestran la evolución del fenómeno, facilitando el análisis cualitativo y cuantitativo.

### Demostración de Simulación (GIF) 🎬

Aquí puedes ver una animación de la inestabilidad de Plateau-Rayleigh simulada con HidroLab2D:

![Inestabilidad de Plateau-Rayleigh](results/animaciones/generacion_de_gota.gif)

### Prototipo de Interfaz Gráfica (GUI) 🖥️

Estamos desarrollando una interfaz gráfica de usuario interactiva para facilitar la interacción con el laboratorio virtual. Aquí un pantallazo del prototipo:

![Prototipo de GUI](prototype.png)

## Estructura del Repositorio 📂

-   `source/`: Contiene el código fuente Fortran de la simulación.
-   `compilados/`: Directorio para los archivos objeto generados durante la compilación.
-   `results/`: Almacena los datos de salida de las simulaciones (archivos `.xl`) y las animaciones (`.gif`).
-   `python_gui/`: Contiene el prototipo de la interfaz gráfica de usuario (GUI) desarrollada con PyQt5.
-   `input.par`: Archivo de configuración para los parámetros de la simulación.
-   `Makefile`: Script para compilar el código Fortran.
-   `requirements.txt`: Lista de dependencias de Python.

## Cómo Ejecutar el Prototipo de la GUI ▶️

Para ejecutar el prototipo de la interfaz gráfica (requiere PyQt5):

1.  Asegúrate de tener Python 3 y `pip` instalados.
2.  Instala las dependencias de Python:
    ```bash
    pip install -r requirements.txt
    ```
3.  Ejecuta el prototipo de la GUI:
    ```bash
    python python_gui/hidrolab_gui_prototype.py
    ```

## Contribuciones 🤝

Las contribuciones son bienvenidas. Por favor, abre un 'issue' o envía un 'pull request'.

## Licencia 📄

Este proyecto está bajo la Licencia Creative Commons Atribución-NoComercial 4.0 Internacional (CC BY-NC 4.0). Consulta el archivo `LICENSE` para más detalles.