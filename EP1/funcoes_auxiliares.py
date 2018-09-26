import numpy as np

def calcula_potencial(matriz_de_potenciais, Vinterna):

    m, n = matriz_de_potenciais.shape[0], matriz_de_potenciais.shape[1]

    lista_alteracoes = []

    for i in range(m):
        for j in range(n):
            if i != 0 and i != m - 1 and j != 0 and j != n - 1 and matriz_de_potenciais[i][j] != Vinterna:

                valor = (matriz_de_potenciais[i-1][j] + matriz_de_potenciais[i+1][j] + matriz_de_potenciais[i][j-1] + matriz_de_potenciais[i][j+1])/4
               
                try:
                    if abs(matriz_de_potenciais[i][j] - valor) / matriz_de_potenciais[i][j] > 0.001:
                        lista_alteracoes.append((i, j, valor))
                except ZeroDivisionError:
                    continue
    
    for alteracao in lista_alteracoes:
        matriz_de_potenciais[alteracao[0]][alteracao[1]] = alteracao[2]

    return matriz_de_potenciais, lista_alteracoes










def cria_matriz_de_potenciais(Vinterna, a, b, c, d, g, h, precisao):

    m, n = int(precisao * (b*1E2)) + 1, int(precisao * (a*1E2)) + 1     # Dimensões da matriz

    matriz_de_potenciais = np.zeros((m, n))

    for i in range(m - int(h*1E2 + d*1E2) * precisao, m - int(h*1E2) * precisao):
        for j in range(int(g*1E2) * precisao + 1, int(g*1E2 + c*1E2) * precisao + 1):
            matriz_de_potenciais[i][j] = Vinterna
            

    return matriz_de_potenciais
'''
def cria_lista_de_indices(matriz_de_potenciais, Vinterna):
    m, n = matriz_de_potenciais.shape[0], matriz_de_potenciais.shape[1]
    lista_de_indices = []

    for i in range(m):
        for j in range(n):
            if i != 0 and i != m - 1 and j != 0 and j != n - 1:
                if matriz_de_potenciais[i][j] != Vinterna:
                    lista_de_indices.append((i, j))
    
    return lista_de_indices

def atualiza_lista_de_indices(matriz_de_potenciais, lista_de_indices):
    for indice in lista_de_indices:



def calcularPotencial(matriz, index, border='Nenhuma'):

    i = index

    if (i[1]+1) < matriz[0].size:
        if matriz[i[0]][i[1]+1] == None and border != 'Direita e baixo':
            border = 'Direita'
    elif i[1]-1 > 0:
        if matriz[i[0]][i[1]-1] == None and border != 'Esquerda e baixo':
            border = 'Esquerda'
    if border == 'Nenhuma':
        Baixo = matriz[i[0]+1][i[1]]
        Cima = matriz[i[0]-1][i[1]]
        Esquerda = matriz[i[0]][i[1]-1]
        Direita = matriz[i[0]][i[1]+1]

    elif border == 'Direita':
        Baixo = matriz[i[0]+1][i[1]]
        Cima = matriz[i[0]-1][i[1]]
        Esquerda = matriz[i[0]][i[1]-1]
        Direita = Esquerda

    elif border == 'Esquerda':
        Baixo = matriz[i[0]+1][i[1]]
        Cima = matriz[i[0]-1][i[1]]
        Direita = matriz[i[0]][i[1]+1]
        Esquerda = Direita

    elif border == 'Cima' or matriz[i[0]-1][i[1]] is None:
        Baixo = matriz[i[0]+1][i[1]]
        Cima = Baixo
        Esquerda = matriz[i[0]][i[1]-1]
        Direita = matriz[i[0]][i[1]+1]

    elif border == 'Baixo':
        Cima = matriz[i[0]-1][i[1]]
        Baixo = Cima
        Esquerda = matriz[i[0]][i[1]-1]
        Direita = matriz[i[0]][i[1]+1]

    elif border == 'Esquerda e baixo':
        Cima = matriz[i[0]-1][i[1]]
        Baixo = Cima
        Direita = matriz[i[0]][i[1]+1]
        Esquerda = Direita

    elif border == 'Direita e baixo':
        Cima = matriz[i[0]-1][i[1]]
        Baixo = Cima
        Esquerda = matriz[i[0]][i[1]-1]
        Direita = Esquerda


    return (Baixo + Cima + Esquerda + Direita)/4
    '''