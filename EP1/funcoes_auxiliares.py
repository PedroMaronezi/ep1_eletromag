import numpy as np
import math

def calcula_potencial(matriz_de_potenciais):

    for i in range(matriz_de_potenciais.shape[0]):
        for j in range(matriz_de_potenciais.shape[1]):
            if i != 0 and i != matriz_de_potenciais.shape[0] - 1 and j != 0 and j != matriz_de_potenciais.shape[1] - 1:
                if i < 21 or i > 51 or j < 21 or j > 61:
                    matriz_de_potenciais[i, j] = (matriz_de_potenciais[i-1, j] + matriz_de_potenciais[i+1, j] + matriz_de_potenciais[i, j-1] + matriz_de_potenciais[i, j+1])/4

    return matriz_de_potenciais

def cria_matriz_de_potenciais(Vinterna, m, n, a, b, c, d, g, h, precisao):

    matriz_de_potenciais = np.zeros((m, n))

    for i in range(m - int(h*1E2 + d*1E2) * precisao, m - int(h*1E2) * precisao):
        for j in range(int(g*1E2) * precisao + 1, int(g*1E2 + c*1E2) * precisao + 1):
            matriz_de_potenciais[i][j] = Vinterna
            

    return matriz_de_potenciais