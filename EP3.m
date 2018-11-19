tic
%Declaraçoes iniciais

%Dimensoes
a = 0.11; %metros
b = 0.06; %metros
c = 0.04; %metros
d = 0.03; %metros
g = 0.02; %metros
h = (b - d)/2; %metros
espessura = 1; %metros

div = 0.001; %Divisão da malha

%Constantes
u0 = 1.2566E-6; %Permeabilidade do ar


%Potencial vetores
Pot_int = 100E-6; %Potencial vetor do condutor interno (Wb/m)
Pot_ext = 0; %Potencial vetor do condutor externo (Wb/m)

%Matriz e seus extremos
X1 = round(g/div + 1);
Y1 = round((b - d - h)/div + 1);

X2 = round((g + c)/div + 1);
Y2 = round((b - h)/div + 1 );

n = round(a/div + 1);
m = round(b/div + 1);


M = zeros(m, n); %Matriz Original



%*********DIFERENÇAS FINITAS********

%Condições Iniciais
for i = Y1:Y2
  for j = X1:X2
    if (i == Y1 || i == Y2) || (j == X1 || j == X2)
      M(i,j) = Pot_int;
    else
      M(i,j) = NaN;
     end
  end
end

%Calculo de Potenciais
for numero=1:5000 %Iterações
  
  %Calculo do Potencial no retângulo superior
  for i = (Y2 + 1):(m - 1)    
    for j = 2:(n - 1)
      M(i,j) = (M(i+1, j) + M(i-1, j) + M(i, j+1) + M(i, j-1)) / 4;
    end
  end
  
  %Calculo do potencial no retângulo inferior
  for i = 2: (Y1 - 1) 
    for j = 2:(n - 1)
      M(i,j) = (M(i+1, j) + M(i-1, j) + M(i, j+1) + M(i, j-1)) / 4;
    end
  end
  
  %Calculo do potencial no retângulo esquerdo
  for i = Y1:Y2 
    for j = 2:(X1 - 1)
      M(i,j) = (M(i+1, j) + M(i-1, j) + M(i, j+1) + M(i, j-1)) / 4;
    end
  end
  
  %Calculo do potencial no retângulo direito
  for i = Y1:Y2 
    for j = (X2 + 1):(n-1)
      M(i,j) = (M(i+1, j) + M(i-1, j) + M(i, j+1) + M(i, j-1)) / 4;
    end
  end
  
end

%Cálculo da Integral da Corrente
soma = 0;

%Extremo Superior
for j = 2:(n-1)
  soma = soma + M(2,j);
end

%Extremo Inferior
for j = 2:(n-1)
  soma = soma + M((m-1),j);
end

%Lateral Esquerda
for i = 2:(m-1)
  soma = soma + M(i,2);
end

%Lateral Direita
for i = 2:(m-1)
  soma = soma + M(i,(n-1));
end

I = soma / u0 %Corrente (A)

L = ((Pot_int - Pot_ext) * espessura) / I %Indutância

%Plotando as equipotenciais (linhas de campo)
figure(1);
axis equal
contour(M, [0 10 20 30 40 50 60 70 80 90 100]);
toc