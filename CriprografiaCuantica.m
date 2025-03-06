clear; clc

% Número de bits
N = 1e4;

% Tipo de polarización
pol = {'+','x'};

% Probabilidad que el bit recibido haya sido alterado por ruido
p = 0.00;

% ------------------------------ SIN ESPÍA ------------------------------

% Elegir bits de Alicia (secuencia aleatoria de unos y ceros).
Alicia_bit = double(rand(1,N) < 0.5);

% Elegir bases de Alicia i Benito (secuencia aleatoria de '+' i 'x').
Alicia_pol = Base_random(pol,N);
Benito_pol = Base_random(pol,N);

% Medida de los bits que le envía Alicia a Benito. Si tienen la misma base,
% el bit es el mismo (puede alterarse por ruido), si no, es aleatorio.
Benito_bit = zeros(1,N);
for i = 1:N
    if Alicia_pol{i} ~= Benito_pol{i} 
        Benito_bit(i) = double(rand < 0.5);
    elseif rand < p
        Benito_bit(i) = double(not(Alicia_bit(i)));
    else
        Benito_bit(i) = Alicia_bit(i);
    end
end

% Puesta en común, nos quedamos con las medidas que compartan base.
No_descartar = zeros(1,N);
for i = 1:N
    No_descartar(i) = Alicia_pol{i} == Benito_pol{i};
end
Buenos = find(No_descartar);
Alicia_bit = Alicia_bit(Buenos); Benito_bit = Benito_bit(Buenos);

% Bits de prueba (primer 10% de los que se han medido con la misma base)
n = round(0.1*length(Buenos));

% Porcentaje de fallos en los bits de prueba.
P = sum(Alicia_bit(1:n) ~= Benito_bit(1:n))/n;
fprintf(['----------- SIN ESPÍA -----------\n ',...
         'Bits de prueba erróneos = %1.2f%%\n\n'],P*100)

% ------------------------------ CON ESPÍA ------------------------------

% Elegir bits de Alicia (secuencia aleatoria de unos y ceros).
Alicia_bit = double(rand(1,N) < 0.5);

% Elegir bases de Alicia, Eva i Benito (secuencia aleatoria de '+' i 'x').
Alicia_pol = Base_random(pol,N);
Eva_pol = Base_random(pol,N);
Benito_pol = Base_random(pol,N);

% Medida de los bits que le envía Alicia a Eva. Si tienen la misma base,
% el bit es el mismo (puede alterarse por ruido), si no, es aleatorio.
Eva_bit = zeros(1,N);
for i = 1:N
    if Alicia_pol{i} ~= Eva_pol{i}
        Eva_bit(i) = double(rand < 0.5);
    elseif rand < p
        Eva_bit(i) = double(not(Alicia_bit(i)));
    else
        Eva_bit(i) = Alicia_bit(i);
    end
end

% Medida de los bits que le envía Eva a Benito. Si tienen la misma base,
% el bit es el mismo (puede alterarse por ruido), si no, es aleatorio.
Benito_bit = zeros(1,N);
for i = 1:N
    if Eva_pol{i} ~= Benito_pol{i}
        Benito_bit(i) = double(rand < 0.5);
    elseif rand < p
        Benito_bit(i) = double(not(Eva_bit(i)));
    else
        Benito_bit(i) = Eva_bit(i);
    end
end

% Puesta en común, nos quedamos con las medidas que compartan base.
No_descartar = zeros(1,N);
for i = 1:N
    No_descartar(i) = Alicia_pol{i} == Benito_pol{i};
end
Buenos = find(No_descartar);
Alicia_bit = Alicia_bit(Buenos); Benito_bit = Benito_bit(Buenos);

% Bits de prueba (primer 10% de los que se han medido con la misma base)
n = round(0.1*length(Buenos)); % bits de prueba

% Porcentaje de fallos en los bits de prueba.
P = sum(Alicia_bit(1:n) ~= Benito_bit(1:n))/n;
fprintf(['----------- CON ESPÍA ------------\n ',...
         'Bits de prueba erróneos = %1.2f%%\n\n'],P*100)

% ------------------------------- FUNCIÓN -------------------------------

% Elección aleatoria de bases
function base = Base_random(pol,N)
    base = cell(1,N);
    for i = 1:N
        if rand < 0.5
            base{i} = pol{1};
        else
            base{i} = pol{2};
        end
    end
end
