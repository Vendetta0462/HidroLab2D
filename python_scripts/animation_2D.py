"""
Animación de la evolución temporal de datos 2D

Este script lee archivos de datos 2D con el formato generado por la subrutina Fortran save2Ddata.
Crea una animación mostrando la evolución temporal del campo usando un mapa de calor.
"""

import numpy as np
import matplotlib.pyplot as plt
from matplotlib.animation import FuncAnimation
import matplotlib.colors as colors

def _isfloat(val):
    global count
    try:
        float(val)
        return True
    except Exception:
        if count%200 == 0:
            print(f'Value of order {val[-4:]} not a float')
        count += 1
        return False

def read_2d_fortran_data(filename):
    """
    Lee datos 2D guardados por la subrutina Fortran
    """
    with open(filename, 'r') as f:
        lines = f.readlines()
    
    times = []
    data_blocks = []
    x_positions = None
    y_positions = None
    nr = 0
    
    i = 0
    while i < len(lines):
        line = lines[i].strip()
        
        # Leer tiempo
        if line.startswith('# Time ='):
            time = float(line.split('=')[1])
            times.append(time)
            i += 1
            
            # Leer dimensiones solo la primera vez
            if lines[i].startswith('# Nr ='):
                nr = float(lines[i].split('=')[1])
                i += 1
            
            # Leer posiciones x (solo la primera vez)
            if x_positions is None and lines[i].startswith('# x positions:'):
                x_positions = np.array([float(x) for x in lines[i].split(':')[1].split()])
                i += 1
                
            # Leer posiciones y (solo la primera vez)
            if y_positions is None and lines[i].startswith('# y positions:'):
                y_positions = np.array([float(y) for y in lines[i].split(':')[1].split()])
                i += 1
            
            # Leer bloque de datos
            data = []
            while i < len(lines) and lines[i].strip() and not lines[i].startswith('#'):
                row = [float(val) if _isfloat(val) else 0.0 for val in lines[i].split()]
                data.append(row)
                i += 1
            
            if data:
                data_blocks.append(np.array(data))
        else:
            i += 1
    
    return times, x_positions, y_positions, np.array(data_blocks), nr

def read_0d_fortran_data(filename_dt):
    datadt = np.loadtxt(filename_dt, skiprows=1)
    datadt = datadt[:,1].T
    return datadt

# ---------------------------
# Parámetros de animación
# ---------------------------
if __name__=='__main__':
    campo ='rho_1' # Nombre del archivo
    campo_dt = 'dt_1'
    frames_amount = 0 # Cantidad de frames. 0 para usar todos
    colormap = 'seismic' # Mapa de color de la animación
    anim_skip = 1  # Usar cada x frames (1 es no saltar frames)
    interval_ms = 100  # Milisegundos entre frames
    mostrar_snapshot = False # Decidir si mostrar snapshot
    snap_idx = 0 # En caso de mostrar snapshot, cual frame
    save_animation = False # Decidir si guardar animación
    anim_path = f"../results/animaciones/nombre.gif" # Path en caso de guardar animación

    # ---------------------------
    # Lectura de data_blocks
    # ---------------------------
    filename = f'../results/{campo}.xl'
    print(f"Leyendo archivo: {filename}")

    try:
        count = 0
        times, x_pos, y_pos, data, nr = read_2d_fortran_data(filename)
        if frames_amount != 0:
            times = times[0:frames_amount]
            data = data[0:frames_amount]
        print(f"Datos cargados exitosamente:")
        print(f"  - Número de pasos temporales: {len(times)}")
        print(f"  - Número de pasos espaciales: {len(x_pos)}")
        print(f"  - Dimensiones de la malla: {data[0].shape}, Nr = {nr}")
        print(f"  - Rango de tiempo: [{min(times):.2e}, {max(times):.2e}]")
    except Exception as e:
        print(f"Error al leer el archivo: {e}")
        exit(1)

    filename_dt = f'../results/{campo_dt}.xl'
    print(f"Leyendo dt en: {filename_dt}")

    try:
        dt = read_0d_fortran_data(filename_dt)
        if frames_amount != 0:
            dt = dt[0:frames_amount]
        print(f"Datos ({len(dt)}) cargados exitosamente.")
    except Exception as e:
        print(f"Error al leer el archivo: {e}")
        exit(1)

    # ---------------------------
    # Configuración de la figura
    # ---------------------------
    fig, ax = plt.subplots(figsize=(10, 8))

    # Determinar los límites de los datos para la escala de colores
    vmin = np.min(data[~np.isnan(data)])
    vmax = np.max(data[~np.isnan(data)])

    print(f'vmax: {vmax}, vmin:{vmin}')

    # Si los datos varían en órdenes de magnitud, usar escala logarítmica
    if vmax > 0 and vmin > 0 and vmax/vmin > 100:
        norm = colors.LogNorm(vmin=vmin, vmax=vmax)
        print("Usando escala logarítmica para los colores")
    else:
        norm = colors.Normalize(vmin=vmin, vmax=vmax)
        print("Usando escala lineal para los colores")

    # Crear el mapa de calor inicial
    im = ax.pcolormesh(x_pos, y_pos, data[0], 
                       shading='auto', cmap=colormap, norm=norm)

    # Añadir barra de colores
    cbar = fig.colorbar(im, ax=ax, pad=0.02)
    cbar.set_label(f'{campo}', fontsize=12)

    # Configurar los ejes
    ax.set_xlabel('x', fontsize=12)
    ax.set_ylabel('y', fontsize=12)
    ax.set_title(f'Evolución temporal de {campo}', fontsize=14)
    ax.set_aspect('equal')

    # Agregar texto para mostrar el tiempo
    time_text = ax.text(0.02, 0.98, '', transform=ax.transAxes, 
                       fontsize=12, verticalalignment='top',
                       bbox=dict(boxstyle='round', facecolor='white', alpha=0.8))

    # Agregar texto para mostrar estadísticas
    stats_text = ax.text(0.02, 0.02, '', transform=ax.transAxes, 
                        fontsize=10, verticalalignment='bottom',
                        bbox=dict(boxstyle='round', facecolor='white', alpha=0.8))

    # ---------------------------
    # Función de inicialización
    # ---------------------------
    def init():
        im.set_array(data[0].ravel())
        time_text.set_text('')
        stats_text.set_text('')
        return im, time_text, stats_text

    # ---------------------------
    # Función de actualización
    # ---------------------------
    def update(frame):
        # Actualizar los datos
        current_data = data[frame]
        im.set_array(current_data.ravel())
        
        # Actualizar el texto del tiempo
        time_text.set_text(f'Tiempo: {times[frame]:.3e}\n'+rf'$\Delta t$: {dt[frame]:.3e}'+f'\nPaso: {frame+1}/{len(times)}')
        
        # Actualizar estadísticas
        data_min = np.min(current_data)
        data_max = np.max(current_data)
        data_mean = np.mean(current_data)
        stats_text.set_text(f'Min: {data_min:.3e}\nMax: {data_max:.3e}\nMedia: {data_mean:.3e}')
        
        return im, time_text, stats_text

    # ---------------------------
    # Crear la animación
    # ---------------------------

    print(f"\nCreando animación...")
    print(f"  - Frames totales: {len(times)}")
    print(f"  - Frames a animar: {len(range(0, frames_amount, anim_skip))}")
    print(f"  - Intervalo entre frames: {interval_ms} ms")

    anim = FuncAnimation(fig, update, frames=range(0, len(times), anim_skip),
                         init_func=init, interval=interval_ms, blit=True)

    plt.tight_layout()

    # ---------------------------
    # Mostrar snapshot
    # ---------------------------

    if mostrar_snapshot:
        fig_snap, ax_snap = plt.subplots(figsize=(8, 6))
            
        im_snap = ax_snap.pcolormesh(x_pos, y_pos, data[snap_idx], 
                                     shading='auto', cmap=colormap, norm=norm)
        
        cbar_snap = fig_snap.colorbar(im_snap, ax=ax_snap)
        cbar_snap.set_label(f'{campo}')
        
        ax_snap.set_xlabel('x')
        ax_snap.set_ylabel('y')
        ax_snap.set_title(f'{campo} en t = {times[snap_idx]:.3e}')
        ax_snap.set_aspect('equal')
        
        plt.tight_layout()
        plt.show()

    # ---------------------------
    # Guardar o mostrar
    # ---------------------------

    if save_animation:
        print("\nGuardando animación...")

        
        # Opciones para guardar
        # Para GIF:
        anim.save(anim_path, writer='pillow', fps=20)
        
        # Para MP4 (requiere ffmpeg):
        # anim_path = f"../results/animaciones/{campo}_2D_animation.mp4"
        # anim.save(anim_path, writer='ffmpeg', fps=30, bitrate=2000)
        
        print(f"Animación guardada exitosamente en: {anim_path}")
    else:
        plt.show()

    # ---------------------------
    # Opcional: Crear figuras estáticas de momentos específicos
    # ---------------------------
    save_snapshots = False

    if save_snapshots:
        print("\nCreando snapshots...")
        # Seleccionar algunos tiempos específicos
        snapshot_indices = [0, len(times)//4, len(times)//2, 3*len(times)//4, -1]
        
        for idx in snapshot_indices:
            if idx < 0:
                idx = len(times) + idx
                
            fig_snap, ax_snap = plt.subplots(figsize=(8, 6))
            
            im_snap = ax_snap.pcolormesh(x_pos, y_pos, data[idx], 
                                         shading='auto', cmap='viridis', norm=norm)
            
            cbar_snap = fig_snap.colorbar(im_snap, ax=ax_snap)
            cbar_snap.set_label(f'{campo}')
            
            ax_snap.set_xlabel('x')
            ax_snap.set_ylabel('y')
            ax_snap.set_title(f'{campo} en t = {times[idx]:.3e}')
            ax_snap.set_aspect('equal')
            
            plt.tight_layout()
            snap_path = f"../results/snapshots/{campo}_t{idx:04d}.png"
            plt.savefig(snap_path, dpi=150)
            plt.close(fig_snap)
            
        print(f"Snapshots guardados en ../results/snapshots/")