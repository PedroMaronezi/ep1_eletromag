%Declara�oes iniciais

%Dimensoes
a = 0.11; %metros
b = 0.06; %metros
c = 0.04; %metros
d = 0.03; %metros
g = 0.02; %metros
h = (b - d)/2; %metros
espessura = 1; %metros

div = 0.001; %Divis�o da malha

%Constantes
sigma1 = 3.2E-3; %Condutancia do meio 1
sigma2 = 3E-3; %Condut�ncia do meio 2
eps0 = 8.854E-12; %Permissividade do v�cuo
eps = 1.9 * eps0; %Permissividade do meio


%Tens�es
Vint = 100; %Tens�o interna (Volts)
Vext = 0; %Tens�o externa (Volts)

%Matriz e seus extremos
X1 = round(g/div + 1);
Y1 = round((b - h - d)/div + 1);

X2 = round((g + c)/div + 1);
Y2 = round((b - h)/div + 1 );

n = round(a/div + 1);
m = round(b/div + 1);


M = zeros(m, n); %Matriz Original
D = zeros(m, n); %Matriz Dual

erro = 0.001; %Erro m�ximo permitido
maior_erro = 0.001; %Candidato a erro m�ximo durante as itera��es
maior_erro_d = 0.001; %Candidato a erro m�ximo dual durante as itera��es
iteracao = 1;
iteracao_d = 1;

%Incognitas
densQ = 0;
densQmin = 0;

%*********DIFEREN�AS FINITAS********

%Condi��es Iniciais
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
for i=1:500
  
  %Calculo do Potencial no ret�ngulo superior
  for i = (Y2 + 1):(m - 1)    
    for j = 2:(n - 1)
      M(i,j) = (M(i+1, j) + M(i-1, j) + M(i, j+1) + M(i, j-1)) / 4;
    end
  end
  
  %Calculo do potencial no ret�ngulo inferior
  for i = 2: (Y1 - 1) 
    for j = 2:(n - 1)
      M(i,j) = (M(i+1, j) + M(i-1, j) + M(i, j+1) + M(i, j-1)) / 4;
    end
  end
  
  %Calculo do potencial no ret�ngulo esquerdo
  for i = Y1:Y2 
    for j = 2:(X1 - 1)
      M(i,j) = (M(i+1, j) + M(i-1, j) + M(i, j+1) + M(i, j-1)) / 4;
    end
  end
  
  %Calculo do potencial no ret�ngulo direito
  for i = Y1:Y2 
    for j = (X2 + 1):(n-1)
      M(i,j) = (M(i+1, j) + M(i-1, j) + M(i, j+1) + M(i, j-1)) / 4;
    end
  end
  
end

%************MAPA DE QUADRADOS CURVILINEOS **********

%Condi��es Iniciais
for i = Y1:Y2
  for j = 1:X1
    if i == ((Y1 + Y2) / 2)
      D(i,j) = Vext;
    end
  end
  
  for j = (X1 + 1):(X2 - 1)
    if i >= ((Y1 + Y2) / 2) && i < Y2
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
for i=1:50
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

%Plotando o mapa de quadrados curvilineos
figure(1);
axis equal
contour(M, [0 10 20 30 40 50 60 70 80 90 100]);
hold on
contour(D, 40);