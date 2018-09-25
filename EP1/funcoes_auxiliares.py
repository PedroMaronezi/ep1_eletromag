import numpy as np
import math

def calcula_potencial(matriz_de_potenciais):

    for i in range(matriz_de_potenciais.shape[0]):
        for j in range(matriz_de_potenciais.shape[1]):
            if i != 0 and i != matriz_de_potenciais.shape[0] - 1 and j != 0 and j != matriz_de_potenciais.shape[1] - 1:
                if i < 21 or i > 51 or j < 21 or j > 61:
                    matriz_de_potenciais[i, j] = (matriz_de_potenciais[i-1, j] + matriz_de_potenciais[i+1, j] + matriz_de_potenciais[i, j-1] + matriz_de_potenciais[i, j+1])/4

    return matriz_de_potenciais

def cria_matriz_de_potenciais(Vinterna, Vexterna):
    
    matriz_de_potenciais = np.zeros((61,111))

    for i in range(matriz_de_potenciais.shape[0]):
        for j in range(matriz_de_potenciais.shape[1]):

            if i == 0 or i == matriz_de_potenciais.shape[0] - 1 or j == 0 or j == matriz_de_potenciais.shape[1] - 1:
                matriz_de_potenciais[i, j] = Vexterna
            
            elif (i == 21 and j > 21 and j < 61) or (i == 51 and j > 21 and j < 61) or (j == 21 and i > 21 and i < 51) or (j == 61 and i > 21 and i < 51):
                matriz_de_potenciais[i, j] = Vinterna 

    return matriz_de_potenciais