import numpy as np

def cria_matriz_de_potenciais(Vinterna, a, b, c, d, g, h, precisao):

    m, n = int(precisao * (b*1E2)) + 1, int(precisao * (a*1E2)) + 1     # Dimensões da matriz

    matriz_de_potenciais = np.zeros((m, n))

    for i in range(m - int(h*1E2 + d*1E2) * precisao, m - int(h*1E2) * precisao):
        for j in range(int(g*1E2) * precisao + 1, int(g*1E2 + c*1E2) * precisao + 1):
            #Dá uma olhada nisso, aqui o meio fica com none (= null) e só as bordas ficam com Vinterno
            if i == m - int(h*1E2 + d*1E2) * precisao or i == m - int(h*1E2) * precisao or j == int(g*1E2) * precisao + 1 or j == int(g*1E2 + c*1E2) * precisao + 1:
                matriz_de_potenciais[i][j] = Vinterna
            else:
                matriz_de_potenciais[i][j] = None
            
    return matriz_de_potenciais

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
                        matriz_de_potenciais[i][j] = valor
                except ZeroDivisionError:
                    continue
    
    for alteracao in lista_alteracoes:
        matriz_de_potenciais[alteracao[0]][alteracao[1]] = alteracao[2]

    return matriz_de_potenciais, lista_alteracoes

def matrizes_de_campo_eletrico(matriz_de_potenciais, Vinterna, deltaX, deltaY):
    
    m, n = matriz_de_potenciais.shape[0], matriz_de_potenciais.shape[1]     # Dimensões da matriz

    matriz_campo_eletrico_x, matriz_campo_eletrico_y = np.zeros((m, n)), np.zeros((m, n))

    for i in range(m-1):
        for j in range(n-1):
            if not (matriz_de_potenciais[i][j] == matriz_de_potenciais[i][j+1] == matriz_de_potenciais[i+1][j] == matriz_de_potenciais[i+1][j+1] == Vinterna):
                #falta fazer os limites de borda
                matriz_campo_eletrico_x[i][j] = (matriz_de_potenciais[i][j] + matriz_de_potenciais[i][j+1] - matriz_de_potenciais[i+1][j] - matriz_de_potenciais[i+1][j+1])/(2*deltaX)
                matriz_campo_eletrico_y[i][j] = (matriz_de_potenciais[i][j] + matriz_de_potenciais[i+1][j] - matriz_de_potenciais[i][j+1] - matriz_de_potenciais[i+1][j+1])/(2*deltaY)

    return matriz_campo_eletrico_x, matriz_campo_eletrico_y 

#def calcula_resistencia():

def cria_matriz_dual_de_potenciais(Vinterna, a, b, c, d, g, h, precisao):
    m, n = int(precisao * (b / 2 * 1E2)) + 1, int(precisao * (a * 1E2)) + 1  # Dimensões da matriz

    matriz_dual_de_potenciais = np.zeros((m, n))

    for i in range(m - int(d/2 * 1E2) * precisao, m):
        for j in range(int(g * 1E2) * precisao + 1, int(g * 1E2 + c * 1E2) * precisao + 1):
            # Dá uma olhada nisso, aqui o meio fica com none (= null) e só as bordas ficam com Vinterno
            if i == m - int(d/2 * 1E2) * precisao or j == int(g * 1E2) * precisao + 1 or j == int(g * 1E2 + c * 1E2) * precisao + 1:
                matriz_dual_de_potenciais[i][j] = Vinterna
            else:
                matriz_dual_de_potenciais[i][j] = None

    return matriz_dual_de_potenciais

def calcula_potencial_dual(matriz_dual_de_potenciais, Vinterna):
    m, n = matriz_dual_de_potenciais.shape[0], matriz_dual_de_potenciais.shape[1]

    lista_alteracoes = []

    for i in range(m):
        for j in range(n):
            if i != 0 and i != m - 1 and j != 0 and j != n - 1 and matriz_dual_de_potenciais[i][j] != Vinterna:

                valor = (matriz_dual_de_potenciais[i - 1][j] + matriz_dual_de_potenciais[i + 1][j] + matriz_dual_de_potenciais[i][j - 1] +
                    matriz_dual_de_potenciais[i][j + 1]) / 4

                try:
                    if abs(matriz_dual_de_potenciais[i][j] - valor) / matriz_dual_de_potenciais[i][j] > 0.001:
                        lista_alteracoes.append((i, j, valor))
                        matriz_dual_de_potenciais[i][j] = valor
                except ZeroDivisionError:
                    continue

    for alteracao in lista_alteracoes:
        matriz_dual_de_potenciais[alteracao[0]][alteracao[1]] = alteracao[2]

    return matriz_dual_de_potenciais, lista_alteracoes