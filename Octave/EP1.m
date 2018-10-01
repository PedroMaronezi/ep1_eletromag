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
sigma1 = 3.2E-3; %Condutancia do meio 1
sigma2 = 3E-3; %Condutância do meio 2
eps0 = 8.854E-12; %Permissividade do vácuo
eps = 1.9 * eps0; %Permissividade do meio


%Tensões
Vint = 100; %Tensão interna (Volts)
Vext = 0; %Tensão externa (Volts)

%Matriz e seus extremos
X1 = round(g/div + 1);
Y1 = round(h/div + 1);

X2 = round((g + c)/div + 1);
Y2 = round((h + d)/div + 1 );

n = round(a/div + 1);
m = round(b/div + 1);


M = zeros(m, n); %Matriz Original
D = zeros(m, n); %Matriz Dual

erro = 0.001; %Erro máximo permitido
maior_erro = 0.001; %Candidato a erro máximo durante as iterações
maior_erro_d = 0.001; %Candidato a erro máximo dual durante as iterações
iteracao = 1;
iteracao_d = 1;

%Incognitas
densQ = 0;
densQmin = 0;

%*********DIFERENÇAS FINITAS********

%Condições Iniciais
for i = Y1:Y2
  for j = X1:X2
    if (i == Y1 || i == Y2) || (j == X1 || j == X2)
      M(i,j) = Vint;
    else
      M(i,j) = NaN;
     end
  end
end

%Calculo de Potenciais
for i=1:5000
  
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

%************MAPA DE QUADRADOS CURVILINEOS **********

%Condições Iniciais
for i = Y1:Y2
  for j = 1:X1
    if i == ((Y1 + Y2) / 2)
      D(i,j) = Vext;
    end
  end
  
  for j = (X1 + 1):(X2 - 1)
    if (i >= ((Y1 + Y2) / 2)) && (i < Y2)
      D(i,j) = NaN;
    end
  end
  
  for j = X2:n
    if i == ((Y1 + Y2) / 2)
      D(i,j) = Vint;
    end
  end
end

%Calculo de metade do potencial dual
for i=1:5000
    for i = ((Y1 + Y2) / 2) + 1:m
      
      for j = 1:X1
        if i ~= m
          if j == 1
            D(i,j) = (D(i-1,j) + D(i+1,j) + 2*D(i,j+1)) / 4;
          else
            if isnan(D(i,j+1))
              D(i,j) = (D(i-1,j) + D(i+1,j) + 2*D(i,j-1)) / 4;
            else
              D(i,j) = (D(i-1,j) + D(i+1,j) + D(i,j-1) + D(i,j+1)) / 4;
            end
          end
        else
          if j == 1
            D(i,j) = (2*D(i-1,j) + 2*D(i,j+1)) / 4;
          else
            D(i,j) = (2*D(i-1,j) + D(i,j-1) + D(i,j+1)) / 4;
          end
        end
      end
      
      for j = (X1 + 1):(X2 - 1)
        if i == m
          D(i,j) = (2*D(i-1,j) + D(i,j-1) + D(i,j+1)) / 4;
        else
          if isnan(D(i-1,j))
            D(i,j) = (2*D(i+1,j) + D(i,j-1) + D(i,j+1)) / 4;
          else
            D(i,j) = (D(i-1,j) + D(i+1,j) + D(i,j-1) + D(i,j+1)) / 4;
          end
        end
      end
      
      for j = X2:n
        if i ~= m
          if j == n
            D(i,j) = (D(i-1,j) + D(i+1,j) + 2*D(i,j-1)) / 4;
          else
            if isnan(D(i,j-1))
              D(i,j) = (D(i-1,j) + D(i+1,j) + 2*D(i,j+1)) / 4;
            else
              D(i,j) = (D(i-1,j) + D(i+1,j) + D(i,j-1) + D(i,j+1)) / 4;
            end
          end
        else
          if j == n
            D(i,j) = (2*D(i-1,j) + 2*D(i,j-1)) / 4;
          else
            D(i,j) = (2*D(i-1,j) + D(i,j-1) + D(i,j+1)) / 4;
          end
        end
      end
    end
    
end

%Completando a outra metade da matriz
for i = 1:(((Y1 + Y2) / 2) - 1)
  for j = 1:n
    D(i,j) = D(m-i+1,j);
  end
end


%Densidade de carga minima
%Extremo Superior
for j = 1:n
  i = 1;
  densQ = -eps*(M(i+1,j) - M(i,j))/div;
  if densQ < densQmin
    densQmin = densQ;
  end
end

%Extremo Inferior
for j = 1:n
  i = m - 1;
  densQ = eps*(M(i+1,j) - M(i,j))/div;
  if densQ < densQmin
    densQmin = densQ;
  end
end

%Lateral Esquerda
for i = 1:m
  j = 1;
  densQ = eps*(M(i,j) - M(i,j+1))/div;
  if densQ < densQmin
    densQmin = densQ;
  end
end

%Lateral Direita
for i = 1:m
  j = n - 1;
  densQ = -eps*(M(i,j) - M(i,j+1))/div;
  if densQ < densQmin
    densQmin = densQ;
  end
end

%RESISTENCIA E CAPACITÂNCIA
%Cálculo da Integral Numérica do Campo Elétrico
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

FluxoCampoE = soma * espessura;
FluxoCampoEDual = espessura * (D(1+(Y1 + Y2)/2,1)/2 + sum(D(1+(Y1 + Y2)/2,2:X1-1)) + D(1+(Y1 + Y2)/2,X1)/2);
RLinhaNumerico = Vint/(sigma2*FluxoCampoEDual);
R = Vint/(sigma1*FluxoCampoE);
RLinhaDual = 1/(2*R*sigma1*(espessura.^2)*sigma2);
C = eps*FluxoCampoE/Vint;

%Plotando o mapa de quadrados curvilineos
figure(1);
axis equal
contour(M, [0 10 20 30 40 50 60 70 80 90 100]);
hold on
contour(D, 40);