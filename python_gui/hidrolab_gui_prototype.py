import sys
from PyQt5.QtWidgets import (QApplication, QWidget, QVBoxLayout, QHBoxLayout,
                             QGroupBox, QLabel, QLineEdit, QPushButton, QComboBox,
                             QDoubleSpinBox, QSpinBox, QTextEdit)
from PyQt5.QtGui import QMovie, QPixmap
from PyQt5.QtCore import Qt, QSize
from pathlib import Path

class HidroLabGUI(QWidget):
    def __init__(self):
        super().__init__()
        self.setWindowTitle("HidroLab2D - Laboratorio Virtual (Prototipo)")
        self.setGeometry(100, 100, 1200, 800) # Tamaño de ventana inicial

        self.init_ui()

    def init_ui(self):
        main_layout = QHBoxLayout()

        # Panel Izquierdo: Control de Parámetros
        params_group = QGroupBox("Control de Parámetros")
        params_layout = QVBoxLayout()
        params_group.setLayout(params_layout)

        # Ejemplo de parámetros (simplificado para el prototipo)
        params_layout.addWidget(QLabel("res_num:"))
        params_layout.addWidget(QSpinBox())
        params_layout.addWidget(QLabel("Ntt:"))
        params_layout.addWidget(QSpinBox(maximum=10000))
        params_layout.addWidget(QLabel("bconditions:"))
        bcond_combo = QComboBox()
        bcond_combo.addItems(["Periodical", "Neumann"])
        params_layout.addWidget(bcond_combo)
        params_layout.addWidget(QLabel("rho_0_L:"))
        params_layout.addWidget(QDoubleSpinBox())

        # Botones de acción
        params_layout.addStretch(1) # Empuja los botones hacia abajo
        params_layout.addWidget(QPushButton("Guardar Parámetros"))
        params_layout.addWidget(QPushButton("Compilar Código"))
        params_layout.addWidget(QPushButton("Ejecutar Simulación"))
        params_layout.addWidget(QPushButton("Cargar Animación"))

        main_layout.addWidget(params_group, 1) # Ocupa 1/3 del espacio

        # Panel Central: Visualización de Resultados
        viz_group = QGroupBox("Visualización de Resultados")
        viz_layout = QVBoxLayout()
        viz_group.setLayout(viz_layout)

        self.animation_label = QLabel("Cargando animación...")
        self.animation_label.setAlignment(Qt.AlignCenter)
        
        # Cargar el GIF de ejemplo
        # Usar Path para construir la ruta de forma robusta
        gif_path = str(Path(__file__).parent.parent / "results" / "animaciones" / "generacion_de_gota.gif")
        
        self.movie = QMovie(gif_path)
        if self.movie.isValid():
            self.animation_label.setMovie(self.movie)
            self.movie.setScaledSize(QSize(800, 600)) # Ajustar tamaño del GIF para que sea más grande
            self.movie.start()
        else:
            self.animation_label.setText(f"Error al cargar GIF: {gif_path}")
            print(f"Error al cargar GIF: {gif_path}")

        viz_layout.addWidget(self.animation_label)
        viz_layout.addStretch(1) # Empuja la animación hacia arriba

        main_layout.addWidget(viz_group, 2) # Ocupa 2/3 del espacio

        # Panel Derecho: Consola de Salida / Logs
        log_group = QGroupBox("Consola de Salida / Logs")
        log_layout = QVBoxLayout()
        log_group.setLayout(log_layout)

        self.log_text_edit = QTextEdit()
        self.log_text_edit.setReadOnly(True)
        self.log_text_edit.setText("""Iniciando proceso...

Compilando código Fortran:
gfortran -c -O3 source/arrays.f90 -o compilados/arrays.o
gfortran -c -O3 source/global_numbers.f90 -o compilados/global_numbers.o
... (más archivos .f90) ...
gfortran -O3 -o Plateau_Rayleigh compilados/*.o
Compilación exitosa.

Ejecutando simulación:
./Plateau_Rayleigh
*****************************************
***** Some numbers to the Sceen *********
*****************************************
rmin  =  -1.0000000000000000     
rmax  =   1.0000000000000000     
dr  =   1.0000000000000000E-002
dt  =   1.5000000000000000E-003
... (más output de la simulación) ...
Simulación completada. Guardando resultados en results/rho_1.xl, results/P_1.xl
""")
        log_layout.addWidget(self.log_text_edit)

        main_layout.addWidget(log_group, 1) # Ocupa 1/3 del espacio

        self.setLayout(main_layout)

if __name__ == "__main__":
    app = QApplication(sys.argv)
    window = HidroLabGUI()
    window.show()
    sys.exit(app.exec_())
