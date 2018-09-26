import numpy as np
import math

def calcula_potencial(matriz_de_potenciais, c, d, g, h, precisao):

    m, n = matriz_de_potenciais.shape[0], matriz_de_potenciais.shape[1]

    for i in range(m):
        for j in range(n):
            if i != 0 and i != m - 1 and j != 0 and j != n - 1:
                if i < m - int(h*1E2 + d*1E2) * precisao or i > m - int(h*1E2) * precisao or j < int(g*1E2) * precisao + 1 or j > int(g*1E2 + c*1E2) * precisao + 1:
                    matriz_de_potenciais[i, j] = (matriz_de_potenciais[i-1, j] + matriz_de_potenciais[i+1, j] + matriz_de_potenciais[i, j-1] + matriz_de_potenciais[i, j+1])/4

    return matriz_de_potenciais

def cria_matriz_de_potenciais(Vinterna, a, b, c, d, g, h, precisao):

    m, n = int(precisao*(b*1E2)) + 1, int(precisao*(a*1E2)) + 1     # Dimensões da matriz

    matriz_de_potenciais = np.zeros((m, n))

    for i in range(m - int(h*1E2 + d*1E2) * precisao, m - int(h*1E2) * precisao):
        for j in range(int(g*1E2) * precisao + 1, int(g*1E2 + c*1E2) * precisao + 1):
            matriz_de_potenciais[i][j] = Vinterna
            

    return matriz_de_potenciais