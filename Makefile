#FC = mpif90
FC=gfortran
#FC=/opt/intel/bin/ifort

#FFLAGS = -O3 -fopenmp
FFLAGS = -O3 -J$(COMPILED_DIR)

#LNK = mpif90
LNK=gfortran
#LNK=/opt/intel/bin/ifort

# Directorio para archivos compilados
COMPILED_DIR = compilados

# Directorio de archivos fuente
SOURCE_DIR = source

# Lista de Objetos
OBJS = $(COMPILED_DIR)/evolve.o $(COMPILED_DIR)/allocate.o $(COMPILED_DIR)/initializing_arrays.o $(COMPILED_DIR)/grid.o $(COMPILED_DIR)/initial.o $(COMPILED_DIR)/rhs.o $(COMPILED_DIR)/main.o $(COMPILED_DIR)/check_parameters.o  $(COMPILED_DIR)/RKDP.o $(COMPILED_DIR)/Info_Screen.o $(COMPILED_DIR)/BC.o $(COMPILED_DIR)/save0Ddata_x.o $(COMPILED_DIR)/save2Ddata_x.o 

# Lista de Modulos
MODS = $(COMPILED_DIR)/arrays.o $(COMPILED_DIR)/global_numbers.o 

$(OBJS):	$(MODS)

cafe:  $(OBJS) $(MODS)
		$(LNK) $(FFLAGS) -o Plateau_Rayleigh $(OBJS) $(MODS) 

.PHONY:	clean

clean:
	-rm -rf $(COMPILED_DIR) *.mod Plateau_Rayleigh

$(COMPILED_DIR)/%.o : $(SOURCE_DIR)/%.f90
	@ mkdir -p $(COMPILED_DIR)
	$(FC) -c $(FFLAGS) -I$(COMPILED_DIR) $< -o $@
