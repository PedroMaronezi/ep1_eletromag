%Declara�oes iniciais

%Dimensoes
a = 11E-2; %metros
b = 6E-2; %metros
c = 4E-2; %metros
d = 3E-2; %metros
g = 2E-2; %metros
h = (b-d)/2; %metros
espessura = 1; %metros

%Constantes
sigma = 3.2E-2; %Condutancia do meio
eps = 1.9*8.854E-11; %Permissividade do meio

precisao = 0.001; %Divis�o da malha

%Tens�es
Vint = 100; %Tens�o interna (Volts)
Vext = 0; %Tens�o externa (Volts)

%Matriz e seus extremos
n = round(a/precisao + 1);
m = round(b/precisao + 1);

linha1 = round((b-d-h)/precisao + 1);
coluna1 = round((g+c)/precisao + 1);

linha2 = round((b-h)/precisao + 1 );
coluna2 = round(g/precisao + 1);

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
for i = linha1:linha2
  for j = coluna2:coluna1
    if (i == linha1 || j == coluna2 || i == linha2 || j == coluna2)
      M(i,j) = Vint;
    else
      M(i,j) = NaN;
     end
  endfor
endfor

%Calculo de Potenciais
while(maior_erro >= erro)
  maior_erro = 0;
  fprintf('\n\nItera��o N�: %d\n', iteracao);
  
  %Calculo do Potencial no ret�ngulo superior
  for i = 2:(linha1-1)    
    for j = 2:(n-1)
      anterior = M(i,j);
      M(i,j) = (M(i+1, j) + M(i-1, j) + M(i, j+1) + M(i, j-1)) / 4;
      if (abs(anterior - M(i,j)) / anterior) > maior_erro
        maior_erro = abs(anterior - M(i,j);
      endif
    endfor
  endfor
  
  %Calculo do potencial no ret�ngulo inferior
  for i = (linha2 + 1): (m - 1) 
    for j = 2:(n-1)
      anterior = M(i,j);
      M(i,j) = (M(i+1, j) + M(i-1, j) + M(i, j+1) + M(i, j-1)) / 4;
      if (abs(anterior - M(i,j)) / anterior) > maior_erro
        maior_erro = abs(anterior - M(i,j);
      endif
    endfor
  endfor
  
  %Calculo do potencial no ret�ngulo esquerdo
  for i = linha1:linha2 
    for j = 2:(coluna2 - 1)
      anterior = M(i,j);
      M(i,j) = (M(i+1, j) + M(i-1, j) + M(i, j+1) + M(i, j-1)) / 4;
      if (abs(anterior - M(i,j)) / anterior) > maior_erro
        maior_erro = abs(anterior - M(i,j);
      endif
    endfor
  endfor
  
  %Calculo do potencial no ret�ngulo direito
  for i = linha1:linha2 
    for j = (linha2 + 1):(n-1)
      anterior = M(i,j);
      M(i,j) = (M(i+1, j) + M(i-1, j) + M(i, j+1) + M(i, j-1)) / 4;
      if (abs(anterior - M(i,j)) / anterior) > maior_erro
        maior_erro = abs(anterior - M(i,j);
      endif
    endfor
  endfor
  
  iteracao = iteracao + 1;
end

%************MAPA DE QUADRADOS CURVILINEOS **********

%Condi��es Iniciais
for i = linha1:linha2
  for j = 1:coluna2
    if i == ((linha1 + linha2) / 2)
      D(i,j) = Vext;
    endif
  endfor
  
  for j = (coluna2 + 1):(coluna1 - 1)
    if i >= ((linha1 + linha2) / 2) && i < linha2
      D(i,j) = NaN;
    endif
  endfor
  
  for j = coluna1:n
    if i == ((linha1 + linha2) / 2)
      D(i,j) = Vint;
    endif
  endfor
endfor

%Calculo de metade do potencial dual
while(maior_erro_d > erro)
    maior_erro_d = 0;
    fprintf('\n\nItera��o Dual N�: %d\n', iteracao_d);
    for i = ((linha1 + linha2) / 2) + 1:m
      for j = 1:coluna2
        if i ~= m
          if j == 1
            D(i,j) = (D(i-1,j) + D(i+1,j) + 2*D(i,j+1)) / 4;
          else
            if isnan(D(i,j+1)
              D(i,j) = (D(i-1,j) + D(i+1,j) + 2*D(i,j-1)) / 4;
            else
              D(i,j) = (D(i-1,j) + D(i+1,j) + D(i,j-1) + D(i,j+1)) / 4;
            endif
          endif
         endif
        else
          if j == 1
            D(i,j) = (2*D(i-1,j) + 2*D(i,j+1))/4;
          else
            D(i,j) = (2*D(i-1,j) + D(i,j-1) + D(i,j+1))/4;
          endif
        endif
      endfor
      
      for j = (coluna2 + 1):(coluna1 - 1)
        if i == m
          D(i,j) = (2*D(i-1,j) + D(i,j-1) + D(i,j+1)) / 4;
        else
          if isnan(D(i-1,j))
            D(i,j) = (2*D(i+1,j) + D(i,j-1) + D(i,j+1)) / 4;
          else
            D(i,j) = (D(i-1,j) + D(i+1,j) + D(i,j-1) + D(i,j+1)) / 4;
          endif
        endif
      endfor
      
      for j = coluna1:n
        if i ~= m
          if j == n
            D(i,j) = (D(i-1,j) + D(i+1,j) + 2*D(i,j-1)) / 4;
          else
            if isnan(D(i,j-1))
              D(i,j) = (D(i-1,j) + D(i+1,j) + 2*D(i,j+1)) / 4;
            else
              D(i,j) = (D(i-1,j) + D(i+1,j) + D(i,j-1) + D(i,j+1)) / 4;
            endif
          endif
        else
          if j == n
            D(i,j) = (2*D(i-1,j) + 2*D(i,j-1)) / 4;
          else
            D(i,j) = (2*D(i-1,j) + D(i,j-1) + D(i,j+1)) / 4;
          endif
        endif
      endfor
    endfor
    
    iteracao_d = iteracao_d + 1;
end

%Completando a outra metade da matriz
for i = 1:((linha1+linha2)/2 - 1)
  for j = 1:n
    D(i,j) = D(m-i+1,j);
  endfor
endfor
