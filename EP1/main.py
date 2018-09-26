# Importação de bibliotecas do python
import matplotlib.pyplot as plt
import numpy as np
np.set_printoptions(threshold=np.inf)

# Importação de funções de outras páginas
from funcoes_auxiliares import *
from grafico import *

#---------------------------------------------#
#------------ INÍCIO DO PROGRAMA -------------#
#---------------------------------------------#


a, b, c, d, g, h = 11E-2, 6E-2, 4E-2, 3E-2, 2E-2, 1E-2       # Variáveis de medida 
sigma, epsilon = 3.2E-3, 1.9*8.854E-11                       # Constantes do meio
Vinterna = 100                                               # Potenciais das placas


# Define-se o tamanho da matriz de potenciais (quanto maior maior a precisão) e as variáveis que dependem disso
precisao = 10

matriz_de_potenciais = cria_matriz_de_potenciais(Vinterna, a, b, c, d, g, h, precisao)
m, n = matriz_de_potenciais.shape[0], matriz_de_potenciais.shape[1]
deltaX, deltaY = a / (n - 1), b / (m - 1)


#atualiza-se o valor de cada elemento da matriz até que sua variação seja menor que 0.1%
matriz_de_potenciais, lista_alteracoes = calcula_potencial(matriz_de_potenciais, Vinterna)
while len(lista_alteracoes) != 0:
    matriz_de_potenciais, lista_alteracoes = calcula_potencial(matriz_de_potenciais, Vinterna)

plotar_mapa(matriz_de_potenciais, Vinterna, a, b, precisao)
