import matplotlib.pyplot as plt
import numpy as np
from matplotlib import cm


def plotar_mapa(matriz_de_potenciais, Vinterna, a, b, precisao):
    
    # Define o título do gráfico
    plt.title("Curvas de nivel do potencial (Precisao: " + str(precisao) + ")")
    
    # Define o intervalo dos eixos x e y do gráfico
    plt.xlim(0, int(a*1E2) * precisao)
    plt.ylim(0, int(b*1E2) * precisao)

    # Define o nome dos eixos x e y do gráfico
    plt.xlabel('$x * precisao (cm)$')
    plt.ylabel('$y * precisao (cm)$')

    # Plota as curvas de nível da matriz com linhas invertidas (porque a função contour inverte as linhas dela)
    V = [0, 10, 20, 30, 40, 50, 60, 70, 80, 90, 100]
    plt.contour(matriz_de_potenciais[::-1], V)

    # Salva a figura na pasta de imagens e mostra o gráfico gerado
    plt.savefig("Imagens/" + "precisao" + str(precisao) + ".png", dpi=250, bbox_inches="tight", pad_inches=0.02)
    plt.show()

    return