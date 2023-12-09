unit Viajero;

interface

uses
  Classes, SysUtils;

procedure loadCities;
procedure greedy;
procedure exhaustiva;
procedure branchAndBound;

implementation

var
  ciudades: array of array of Integer;
  citiesNumber: Integer;

// aqui se define el tipo de estado que se usará para los algoritmos
type
    TEstado = record
      contadorVisitados: Integer;
      contadorDistancia: Integer;
      ciudadActual: Integer;
      visitados: array of boolean;
      camino: array of Integer;
    end;

// esta función carga las ciudades y las distancias entre ellas
procedure loadCities;
var
  i, j: Integer;
begin
  // pide al usuario ingresar el número de ciudades y las distancias entre ellas
  Write('Ingrese el número de ciudades: ');
  ReadLn(citiesNumber);

  // inicializa la matriz de ciudades y sus distancias
  SetLength(ciudades, citiesNumber);
  for i := 0 to citiesNumber - 1 do
    SetLength(ciudades[i], citiesNumber);

  // captura las distancias entre cada par de ciudades
  WriteLn('Ingrese los valores de la matrizz (', citiesNumber, 'x', citiesNumber, '):');
  for i := 0 to citiesNumber - 1 do
  begin
    for j := 0 to citiesNumber - 1 do
    begin
      Write('Ciudad[', i, ',', j, ']: ');
      Read(ciudades[i, j]);
    end;
  end;

  // muestra la matriz de ciudades y distancias ingresada
  WriteLn('Matriz de ciudades ingresada:');
  for i := 0 to citiesNumber - 1 do
  begin
    for j := 0 to citiesNumber - 1 do
      Write(ciudades[i, j], ' ');
    WriteLn;
  end;
end;

// esta función implementa el algoritmo voraz para encontrar un camino corto
procedure greedy;
var
  ciudadActual, contadorVisitados, destino, caminos, Temp, distancia, distanciaTotal: Integer;
  visitados: array of boolean;
  camino: array of integer;
begin
  // inicialización de variables
  SetLength(visitados, citiesNumber);
  SetLength(camino, citiesNumber + 1);  // +1 para incluir el retorno al inicio
  distanciaTotal := 0;

  // marca todas las ciudades como no visitadas
  for destino := 0 to citiesNumber - 1 do
  begin
    visitados[destino] := False;
  end;

  // selecciona la primera ciudad y marca como visitada
  ciudadActual := 0;
  contadorVisitados := 0;
  visitados[ciudadActual] := True;
  camino[contadorVisitados] := ciudadActual;

  // el bucle principal encuentra el vecino más cercano no visitado
  while contadorVisitados < citiesNumber - 1 do
  begin
    distancia := MaxInt;
    for destino := 0 to citiesNumber - 1 do
    begin
      // busca la ciudad más cercana
      if (not visitados[destino]) and (ciudades[ciudadActual][destino] < distancia) and (ciudades[ciudadActual][destino] <> 0) then
      begin
        distancia := ciudades[ciudadActual][destino];
        Temp := destino;
      end;
    end;

    // actualiza la distancia total y marca la nueva ciudad como visitada
    distanciaTotal := distanciaTotal + distancia;
    ciudadActual := Temp;
    Inc(contadorVisitados);
    visitados[ciudadActual] := True;
    camino[contadorVisitados] := ciudadActual;
  end;

  // agrega la distancia de regreso a la ciudad de origen
  distanciaTotal := distanciaTotal + ciudades[ciudadActual][0];

  // completa el camino con la ciudad de origen
  camino[citiesNumber] := 0;

  // imprime el camino más corto encontrado y la distancia total
  WriteLn('EL CAMINO MAS CORTO ES');
  for caminos := 0 to citiesNumber do
  begin
    Write(camino[caminos]);
    if caminos < citiesNumber then
      Write(' -> ');
  end;

  WriteLn;
  WriteLn('Distancia total del recorrido: ', distanciaTotal);
end;

type
    Tcamino = record
            contadorVisitados, contadorDistancia, ciudadActual, mejorDistancia:Integer;
            visitados: Array of boolean;
            camino : Array of Integer
end;

// función recursiva para el algoritmo exhaustivo
function recursion_exhaustiva(recorrido: Tcamino): Tcamino;
var
  i: Integer;
  temp: Tcamino;
begin
  // marca la ciudad actual como visitada y actualiza el recorrido
  recorrido.camino[recorrido.contadorVisitados] := recorrido.ciudadActual;
  recorrido.visitados[recorrido.ciudadActual] := True;
  Inc(recorrido.contadorVisitados);

  // si todas las ciudades han sido visitadas, verifica si esta ruta es la mejor
  if recorrido.contadorVisitados = citiesNumber then
  begin
    // agrega la distancia de regreso a la ciudad de origen
    recorrido.contadorDistancia := recorrido.contadorDistancia + ciudades[recorrido.ciudadActual][0];

    // compara la distancia total con la mejor encontrada hasta ahora
    if recorrido.contadorDistancia < recorrido.mejorDistancia then
    begin
      recorrido.mejorDistancia := recorrido.contadorDistancia;
      Result := recorrido;
    end;

    // resta la distancia de regreso para la próxima iteración
    recorrido.contadorDistancia := recorrido.contadorDistancia - ciudades[recorrido.ciudadActual][0];

    Exit;
  end;

  // explora rutas no visitadas para encontrar la mejor ruta
  for i := 0 to citiesNumber - 1 do
  begin
    if (not recorrido.visitados[i]) and (ciudades[recorrido.ciudadActual][i] <> 0) then
    begin
      temp := recorrido;
      temp.ciudadActual := i;
      temp.contadorDistancia := temp.contadorDistancia + ciudades[recorrido.ciudadActual][i];
      temp := recursion_exhaustiva(temp);

      // actualiza si se encuentra una ruta mejor
      if temp.mejorDistancia < recorrido.mejorDistancia then
      begin
        recorrido := temp;
      end;
    end;
  end;

  Result := recorrido;
end;

// esta función ejecuta el algoritmo exhaustivo para encontrar el camino más corto
procedure exhaustiva;
var
  i: Integer;
  recorrido, mejorCamino: Tcamino;
begin
  // inicializa el recorrido con la primera ciudad
  recorrido.contadorVisitados := 0;
  recorrido.ciudadActual := 0;
  recorrido.contadorDistancia := 0;
  SetLength(recorrido.visitados, citiesNumber);
  SetLength(recorrido.camino, citiesNumber);
  recorrido.mejorDistancia := MaxInt;

  // marca todas las ciudades como no visitadas y prepara el camino
  for i := 0 to citiesNumber - 1 do
  begin
    recorrido.visitados[i] := False;
    recorrido.camino[i] := 0;
  end;

  // encuentra el mejor camino usando la recursión
  mejorCamino := recursion_exhaustiva(recorrido);

  // imprime el mejor camino y su distancia
  WriteLn('EL CAMINO MAS CORTO ES');
  for i := 0 to citiesNumber - 1 do
  begin
    Write(mejorCamino.camino[i]);
    if i < citiesNumber - 1 then
      Write(' -> ');
  end;
  WriteLn(' con una distancia de ', mejorCamino.mejorDistancia);
end;


// función para calcular el límite inferior (lower bound) de un estado
function lowerBound(estado: TEstado): Integer;
var
  lb, i: Integer;
begin
  // calcula el lower bound para el estado actual
  lb := estado.contadorDistancia;
  // implementa un cálculo simple del lower bound
  for i := 0 to citiesNumber - 1 do
  begin
    if not estado.visitados[i] then
      lb := lb + (ciudades[estado.ciudadActual][i] div 2); // estimación simple
  end;
  Result := lb;
end;


// branchandboundrecursion es una función recursiva que se utiliza en el algoritmo de ramificación y poda
procedure branchAndBoundRecursion(var mejorEstado: TEstado; estadoActual: TEstado);
var
  i, idx: Integer;
  nuevoEstado: TEstado;
begin
  // verifica si se han visitado todas las ciudades
  if estadoActual.contadorVisitados = citiesNumber then
  begin
    // calcula la distancia total incluyendo el regreso a la ciudad de inicio
    estadoActual.contadorDistancia := estadoActual.contadorDistancia + ciudades[estadoActual.ciudadActual][0];
    // si la distancia total es menor que la mejor encontrada hasta ahora, actualiza el mejor estado
    if estadoActual.contadorDistancia < mejorEstado.contadorDistancia then
    begin
      mejorEstado := estadoActual;
      // copia el camino encontrado en el mejor estado
      for idx := 0 to citiesNumber do
        mejorEstado.camino[idx] := estadoActual.camino[idx];
    end;
    // termina la función si todas las ciudades han sido visitadas
    Exit;
  end;

  // itera sobre todas las ciudades para encontrar la siguiente ciudad a visitar
  for i := 0 to citiesNumber - 1 do
  begin
    // verifica si la ciudad no ha sido visitada y hay una conexión con la ciudad actual
    if (not estadoActual.visitados[i]) and (ciudades[estadoActual.ciudadActual][i] <> 0) then
    begin
      // crea un nuevo estado con la ciudad actualizada y la distancia acumulada
      nuevoEstado := estadoActual;
      nuevoEstado.ciudadActual := i;
      nuevoEstado.contadorDistancia := nuevoEstado.contadorDistancia + ciudades[estadoActual.ciudadActual][i];
      nuevoEstado.visitados[i] := True;
      Inc(nuevoEstado.contadorVisitados);
      nuevoEstado.camino[nuevoEstado.contadorVisitados - 1] := i;

      // llama recursivamente a la función si el límite inferior es menor que la mejor distancia encontrada
      if lowerBound(nuevoEstado) < mejorEstado.contadorDistancia then
        branchAndBoundRecursion(mejorEstado, nuevoEstado);
    end;
  end;
end;

// branchandbound es el procedimiento principal que implementa el algoritmo de ramificación y poda
procedure branchAndBound;
var
  i: Integer;
  estadoInicial, mejorEstado: TEstado;
begin
  // inicializa el estado inicial con valores por defecto
  estadoInicial.contadorVisitados := 0;
  estadoInicial.ciudadActual := 0;
  estadoInicial.contadorDistancia := 0;
  SetLength(estadoInicial.visitados, citiesNumber);
  SetLength(estadoInicial.camino, citiesNumber + 1);
  mejorEstado.contadorDistancia := MaxInt;
  SetLength(mejorEstado.camino, citiesNumber + 1); // establece el tamaño correcto para el camino

  // marca todas las ciudades como no visitadas en el estado inicial
  for i := 0 to citiesNumber - 1 do
  begin
    estadoInicial.visitados[i] := False;
    estadoInicial.camino[i] := -1;
  end;

  // llama a la función recursiva para comenzar el algoritmo
  branchAndBoundRecursion(mejorEstado, estadoInicial);

  // imprime el camino más corto encontrado y su distancia
  WriteLn('EL CAMINO MAS CORTO ES');
  for i := 0 to citiesNumber - 1 do
  begin
    Write(mejorEstado.camino[i]);
    if i < citiesNumber - 1 then
      Write(' -> ');
  end;
  WriteLn(' con una distancia de ', mejorEstado.contadorDistancia);
end;

end.

end.

