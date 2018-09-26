%Declaraçoes iniciais
a = 11E-2; 
b = 6E-2;
c = 4E-2;
d = 3E-2;
g = 2E-2;
h = (b-d)/2;
w = 1;
sigma = 3.2E-2;
epsilon = 1.9*8.854E-11;
delta = 0.0005
Vint = 100;
Vext = 0;


x1 = round(g/delta + 1);
x2 = round((g+c)/delta + 1);
x3 = round(a/delta + 1);
y1 = round((b-h-d)/delta + 1);
y2 = round((b-h)/delta + 1);
y3 = round(b/delta + 1);
M = zeros(y3, x3);
M_ant = [y3, x3];
MAX = 0.001;
numero = 1;
stop_value = 0.000001*Vint

%Funcoes

%Metodo das Diferencas Finitas

%Montando a Matriz com Condicoes Iniciais

for i=y1:y2
  for j=x1:x2
    if ((i == y1|| i == y2) || (j == x1 || j == x2))
      M(i,j) = Vext;
    else
      M(i,j) = NaN;
    end
  end
end

%Calculando Potenciais
while(MAX > stop_value)
    MAX = 0;
    fprintf('\n\nIteração N°: %d\n', numero);
    
    for i = 2:(y1-1)%Cálculo do Potencial acima do Retângulo.
        for j = 2:(x3-1)
            anteior = M(i,j);
            M(i,j) = (M(i-1,j) + M(i+1,j) + M(i,j-1) + M(i,j+1)) / 4;
            if abs((M(i,j)-anteior))>MAX
                MAX = abs(anteior-M(i,j));
            end
            
        end
    end
    
    for i = y1:y2  %Cálculo do Potencial à Esquerda do Retângulo.
        for j = 2:(x1-1)
            anteior = M(i,j);
            M(i,j) = (M(i-1,j) + M(i+1,j) + M(i,j-1) + M(i,j+1)) / 4;
            if abs((M(i,j)-anteior))>MAX
                MAX = abs(anteior-M(i,j));
            end
        end
    end
    
    for i = y1:y2  %Cálculo do Potencial à Direita do Retângulo.
        for j = (x2+1):(x3-1)
            anteior = M(i,j);
            M(i,j) = (M(i-1,j) + M(i+1,j) + M(i,j-1) + M(i,j+1)) / 4;
            if abs((M(i,j)-anteior))>MAX
                MAX = abs(anteior-M(i,j));
            end
        end
    end
    
    for i = (y2+1):(y3-1)  %Cálculo do Potencial abaixo do Retângulo.
        for j = 2:(x3-1)
            anteior = M(i,j);
            M(i,j) = (M(i-1,j) + M(i+1,j) + M(i,j-1) + M(i,j+1))/ 4;
            if abs((M(i,j)-anteior))>MAX
                MAX = abs(anteior-M(i,j));
            end
        end
    end
    
    
    
    numero = numero + 1;
end



