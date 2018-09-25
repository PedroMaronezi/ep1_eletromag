# Importação de bibliotecas do python
import matplotlib.pyplot as plt
import numpy as np

# Importação de funções de outras páginas
from funcoes_auxiliares import *
from grafico import *


a, b, c, d, g, h = 11E-2, 6E-2, 4E-2, 3E-2, 2E-2, 1E-2                                  # Variáveis de medida 
sigma, epsilon = 3.2E-3, 1.9*8.854E-11                                                  # Constantes do meio
Vinterna, Vexterna = 100, 0                                                             # Potenciais das placas
m, n = 61, 111                                                                          # Dimensões da matriz de potenciais
matriz_de_potenciais = np.array([[0 for x in range(m)] for y in range(n)])              # Matriz com os potenciais



