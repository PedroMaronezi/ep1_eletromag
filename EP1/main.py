# Importação de bibliotecas do python
import matplotlib.pyplot as plt
import numpy as np

# Importação de funções de outras páginas
from funcoes_auxiliares import *
from grafico import *


a, b, c, d, g, h = 11E-2, 6E-2, 4E-2, 3E-2, 2E-2, 1E-2                     # Variáveis de medida 
sigma, epsilon = 3.2E-3, 1.9*8.854E-11                                     # Constantes do meio
Vinterna = 100                                                             # Potenciais das placas


# Define-se o tamanho da matriz de potenciais (quanto maior maior a precisão) e as variáveis que dependem disso
#precisao = int(input("Digite a proporção: "))
precisao = 10

m, n = int(precisao*(b*1E2)) + 1, int(precisao*(a*1E2)) + 1                                 # Dimensões da matriz
deltaX, deltaY = a/(n-1), b/(m-1)                                                           # Dimensão 
matriz_de_potenciais = cria_matriz_de_potenciais(Vinterna, m, n, a, b, c, d, g, h, precisao)   # Matriz com os potenciais

print(matriz_de_potenciais)